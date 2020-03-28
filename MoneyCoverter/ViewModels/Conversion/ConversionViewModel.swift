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
    
    var currenciesFetchinResponse = ReplaySubject<CurrenciesFetchingResponse>.create(bufferSize: 1)
    
    init(currencyNetworking: CurrencyNetworkingProtocol) {
        self.currencyNetworking = currencyNetworking
        setUpObservables()
    }
    
    private func setUpObservables() {
        self.currencyNetworking.fetchAllCurrenciesFromServer()
            .subscribe(onNext: { currenciesFetchingResponse in
                self.currenciesFetchinResponse.onNext(currenciesFetchingResponse)
            }).disposed(by: disposeBag)
    }
}
