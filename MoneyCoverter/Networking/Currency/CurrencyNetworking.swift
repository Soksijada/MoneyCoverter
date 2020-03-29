//
//  CurrencyNetworking.swift
//  MoneyCoverter
//
//  Created by Krešimir Baković on 28/03/2020.
//  Copyright © 2020 Kreso Bakovic. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class CurrencyNetworking: CurrencyNetworkingProtocol {
    
    private let serverURL = "http://hnbex.eu/api/v1/rates/daily"
    
    func fetchAllCurrenciesFromServer() -> Observable<CurrenciesFetchingResponse> {
        return RxAlamofire.request(.get,
                                   serverURL,
                                   parameters: nil,
                                   encoding: JSONEncoding.default)
            .validate()
            .responseData()
            .flatMapLatest ({ (_, data) -> Observable<CurrenciesFetchingResponse> in
                let currencies = try JSONDecoder().decode([Currency].self, from: data)
                return Observable.just(CurrenciesFetchingResponse.success(currencies))
            }).catchError ({ error -> Observable<CurrenciesFetchingResponse> in
                return Observable.just(CurrenciesFetchingResponse.error(.serverError(error)))
            })
    }
}
