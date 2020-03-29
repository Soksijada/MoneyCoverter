//
//  CurrencyNetworkingProtocol.swift
//  MoneyCoverter
//
//  Created by Krešimir Baković on 28/03/2020.
//  Copyright © 2020 Kreso Bakovic. All rights reserved.
//

import Foundation
import RxSwift

protocol CurrencyNetworkingProtocol {
    func fetchAllCurrenciesFromServer() -> Observable<CurrenciesFetchingResponse>
}
