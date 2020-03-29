//
//  ConversionViewModel.swift
//  MoneyCoverter
//
//  Created by Krešimir Baković on 28/03/2020.
//  Copyright © 2020 Kreso Bakovic. All rights reserved.
//

import Foundation
import RxSwift

class ConversionViewModel: ConversionViewModelProtocol {
    
    private let currencyNetworking: CurrencyNetworkingProtocol
    private let disposeBag = DisposeBag()
    
    private var amount: Double?
    private var fromCurrency: Currency?
    private var toCurrency: Currency?
    private var allCurrencies = [Currency]()
    
    var currenciesFetchinResponse = ReplaySubject<CurrenciesFetchingResponse>.create(bufferSize: 1)
    var textInFromCurrencyTextFieldChanges = PublishSubject<String?>()
    var textInToCurrencyTextFieldChanges = PublishSubject<String?>()
    var textInAmountTextFieldChanges = PublishSubject<String?>()
    var convertButtonTouched = PublishSubject<Void>()
    
    var conversionResult: Observable<Double>!
    
    init(currencyNetworking: CurrencyNetworkingProtocol) {
        self.currencyNetworking = currencyNetworking
        setUpObservables()
    }
    
    private func setUpObservables() {
        self.currencyNetworking.fetchAllCurrenciesFromServer()
            .subscribe(onNext: { currenciesFetchingResponse in
                self.currenciesFetchinResponse.onNext(currenciesFetchingResponse)
                switch currenciesFetchingResponse {
                case .success(let currencies):
                    self.allCurrencies = currencies
                case .error(let error):
                    print("ERROR: \(error.errorMessage)")
                }
            }).disposed(by: disposeBag)
        
        textInFromCurrencyTextFieldChanges
            .subscribe(onNext: { [weak self] newText in
                guard let `self` = self else { return }
                self.fromCurrency = self.findAndReturnCurrency(allCurrencies: self.allCurrencies, currencyName: newText)
            }).disposed(by: disposeBag)
        
        textInToCurrencyTextFieldChanges
            .subscribe(onNext: { [weak self] newText in
                guard let `self` = self else { return }
                self.toCurrency = self.findAndReturnCurrency(allCurrencies: self.allCurrencies, currencyName: newText)
            }).disposed(by: disposeBag)
        
        textInAmountTextFieldChanges
            .subscribe(onNext: { [weak self] newText in
                guard let `self` = self,
                    let amountString = newText else { return }
                self.amount = Double(amountString)
            }).disposed(by: disposeBag)
        
        conversionResult = convertButtonTouched
            .flatMapLatest({ [weak self] _ -> Observable<Double> in
                guard let `self` = self else { return Observable.empty() }
                guard let fromCurrency = self.fromCurrency,
                    let toCurrency = self.toCurrency,
                    let amount = self.amount else { return Observable.just(1.0)}
                let result = self.convertCurrency(fromCurrency: fromCurrency, toCurrency: toCurrency, amount: amount)
                return Observable.just(result)
            })
    }
    
    private func findAndReturnCurrency(allCurrencies: [Currency], currencyName: String?) -> Currency? {
        var currencyWithGivenName: Currency?
        for currency in allCurrencies {
            if currency.currencyCode == currencyName {
                currencyWithGivenName = currency
            }
        }
        return currencyWithGivenName
    }
    
    private func convertCurrency(fromCurrency: Currency, toCurrency: Currency, amount: Double) -> Double {
        let exchangeRate = Double(fromCurrency.medianRate)! / Double(toCurrency.medianRate)!
        let moneyRatio = Double(toCurrency.unitValue) / Double(fromCurrency.unitValue)
        let result = ((amount * exchangeRate * moneyRatio) * 100).rounded() / 100
        return result
    }
}
