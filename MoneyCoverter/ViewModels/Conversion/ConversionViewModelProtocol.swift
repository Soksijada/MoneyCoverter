//
//  ConversionViewModelProtocol.swift
//  MoneyCoverter
//
//  Created by Krešimir Baković on 28/03/2020.
//  Copyright © 2020 Kreso Bakovic. All rights reserved.
//

import Foundation
import RxSwift

protocol ConversionViewModelProtocol {
    var currenciesFetchinResponse: ReplaySubject<CurrenciesFetchingResponse> { get }
    var textInFromCurrencyTextFieldChanges: PublishSubject<String?> { get }
    var textInToCurrencyTextFieldChanges: PublishSubject<String?> { get }
    var textInAmountTextFieldChanges: PublishSubject<String?> { get }
    var convertButtonTouched: PublishSubject<Void> { get }
    
    var conversionResult: Observable<ConversionResponse>! { get }
}
