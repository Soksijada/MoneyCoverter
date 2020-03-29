//
//  CurrenciesFetchingResponse.swift
//  MoneyCoverter
//
//  Created by Krešimir Baković on 28/03/2020.
//  Copyright © 2020 Kreso Bakovic. All rights reserved.
//

import Foundation

enum CurrenciesFetchingResponse {
    case success([Currency])
    case error(MoneyConverterError)
}
