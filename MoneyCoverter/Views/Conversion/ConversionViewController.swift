//
//  ConversionViewController.swift
//  MoneyCoverter
//
//  Created by Krešimir Baković on 28/03/2020.
//  Copyright © 2020 Kreso Bakovic. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    private let conversionViewModel: ConversionViewModelProtocol
    
    init(conversionViewModel: ConversionViewModelProtocol) {
        self.conversionViewModel = conversionViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
}
