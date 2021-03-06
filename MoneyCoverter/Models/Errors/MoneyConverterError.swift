//
//  MoneyConverterError.swift
//  MoneyConverter
//
//  Created by Krešimir Baković on 28/03/2020.
//  Copyright © 2020 Codable Studio. All rights reserved.
//

import Foundation

enum MoneyConverterError: Error {
    case defaultError
    case dataMakingError
    case emptyFieldsError
    case serverError(Error)
    
    var errorMessage: String {
        switch self {
        case .defaultError:
            return "Default error."
        case .dataMakingError:
            return "Unable to make data."
        case .emptyFieldsError:
            return "Please fill up all the fields."
        case .serverError(let error):
            return "\(error.localizedDescription)"
        }
    }
}
