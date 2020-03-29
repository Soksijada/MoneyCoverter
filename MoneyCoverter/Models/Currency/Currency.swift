//
//  Currency.swift
//  MoneyConverter
//
//  Created by Krešimir Baković on 28/03/2020.
//  Copyright © 2020 Krešimir Baković. All rights reserved.
//

import Foundation

class Currency: Codable {
    var currencyCode: String
    var unitValue: Int
    var buyingRate: String
    var medianRate: String
    var sellingRate: String
    
    enum CodingKeys: String, CodingKey {
        case currencyCode = "currency_code"
        case unitValue = "unit_value"
        case buyingRate = "buying_rate"
        case medianRate = "median_rate"
        case sellingRate = "selling_rate"
    }
}
