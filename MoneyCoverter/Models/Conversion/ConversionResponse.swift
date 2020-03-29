//
//  ConversionResponse.swift
//  MoneyCoverter
//
//  Created by Krešimir Baković on 29/03/2020.
//  Copyright © 2020 Kreso Bakovic. All rights reserved.
//

import Foundation

enum ConversionResponse {
    case success(Double)
    case error(MoneyConverterError)
}
