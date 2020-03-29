//
//  Cordinator.swift
//  Geofencing
//
//  Created by Krešimir Baković on 16/12/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    
    var window: UIWindow!
    
    static let shared = Coordinator()
    
    private init() {}
    
    func start(_ window: UIWindow) {
        self.window = window
        startConversionViewController()
    }
    
    func startConversionViewController() {
        let currencyNetworking = CurrencyNetworking()
        let conversionViewModel = ConversionViewModel(currencyNetworking: currencyNetworking)
        let conversionViewController = ConversionViewController(conversionViewModel: conversionViewModel)
        let navigationController = UINavigationController(rootViewController: conversionViewController)
        window.rootViewController = navigationController
    }
}
