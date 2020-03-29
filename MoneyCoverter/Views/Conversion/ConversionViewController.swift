//
//  ConversionViewController.swift
//  MoneyCoverter
//
//  Created by Krešimir Baković on 28/03/2020.
//  Copyright © 2020 Kreso Bakovic. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class ConversionViewController: UIViewController {
    
    private let conversionViewModel: ConversionViewModelProtocol
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let moneyImageView = UIImageView()
    
    private let currenciesStackView = UIStackView()
    
    private let fromCurrencyStackView = UIStackView()
    private let fromLabel = UILabel()
    private let fromCurrenyTextField = UITextField()
    private let fromCurrencySeparator = UIView()
    
    private let arrowsImageView = UIImageView()
    
    private let toCurrencyStackView = UIStackView()
    private let toLabel = UILabel()
    private let toCurrencyTextField = UITextField()
    private let toCurrencySeparator = UIView()
    
    private let amountLabel = UILabel()
    private let amountTextField = UITextField()
    private let amountTextFieldSeparator = UIView()
    
    private let convertButton = UIButton()
    private let resultLabel = UILabel()
    
    private let resultStackView = UIStackView()
    private let fromResultCurrencyLabel = UILabel()
    private let equalLabel = UILabel()
    private let toResultCurrencyLabel = UILabel()
    
    private let resultSeparator = UIView()
    
    private let fromCurrencyPicker = UIPickerView()
    private let toCurrencyPicker = UIPickerView()
    
    private var allCurrencies = [Currency]()
    private var mainCurrency = Currency(currencyCode: "HRK", unitValue: 1, buyingRate: "1", medianRate: "1", sellingRate: "1")
    
    init(conversionViewModel: ConversionViewModelProtocol) {
        self.conversionViewModel = conversionViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        setUpObservables()
        addGestureRecognizer()
        createPickers()
    }
    
    private func render() {
        configureScrollViewAndContainerView()
        renderMoneyImageView()
        configureCurrenciesStackView()
        renderFromLabelAndFromTextField()
        renderArrowsImageView()
        renderToLabelAndToTextField()
        renderAmountLabelAndAmountTextField()
        renderConvertButton()
        renderResultLabelAndResultStackView()
        renderResultSeparator()
    }
    
    private func setUpObservables() {
        conversionViewModel.currenciesFetchinResponse
            .subscribe(onNext: { [weak self] currenciesFetchingResponse in
                guard let `self` = self else { return }
                switch currenciesFetchingResponse {
                case .success(let currencies):
                    self.allCurrencies = currencies
                    self.allCurrencies.insert(self.mainCurrency, at: 0)
                case .error(let error):
                    self.showOneOptionAlert(title: "Error", message: "\(error.errorMessage)", actionTitle: "OK")
                }
            }).disposed(by: disposeBag)
        
        fromCurrenyTextField.rx.text
            .bind(to: conversionViewModel.textInFromCurrencyTextFieldChanges)
            .disposed(by: disposeBag)
        
        toCurrencyTextField.rx.text
            .bind(to: conversionViewModel.textInToCurrencyTextFieldChanges)
            .disposed(by: disposeBag)
        
        amountTextField.rx.text
            .bind(to: conversionViewModel.textInAmountTextFieldChanges)
            .disposed(by: disposeBag)
        
        convertButton.rx.tap
            .do(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.view.endEditing(true)
                MoneyConverterActivityIndicatorView.shared.show(on: self.view)
            })
            .bind(to: conversionViewModel.convertButtonTouched)
            .disposed(by: disposeBag)
        
        conversionViewModel.conversionResult
            .subscribe(onNext: { [weak self] conversionResponse in
                guard let `self` = self else { return }
                switch conversionResponse {
                case .success(let result):
                    let formatedResult = Formatter.shared.replaceAllDotsWithCommas(in: String(result))
                    MoneyConverterActivityIndicatorView.shared.dissmis(from: self.view)
                    self.fromResultCurrencyLabel.text = "\(self.amountTextField.text ?? "") \(self.fromCurrenyTextField.text ?? "")"
                    self.toResultCurrencyLabel.text = "\(formatedResult) \(self.toCurrencyTextField.text ?? "")"
                    self.resultStackView.isHidden = false
                case .error(let error):
                    MoneyConverterActivityIndicatorView.shared.dissmis(from: self.view)
                    self.showOneOptionAlert(title: "Error", message: "\(error.errorMessage)", actionTitle: "OK")
                }
            }).disposed(by: disposeBag)
    }
    
    private func addGestureRecognizer() {
        view.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    private func createPickers() {
        createPickerAndBarForPicker(for: fromCurrenyTextField, with: fromCurrencyPicker)
        createPickerAndBarForPicker(for: toCurrencyTextField, with: toCurrencyPicker)
    }
    
    private func createPickerAndBarForPicker(for textField: UITextField, with picker: UIPickerView) {
        picker.delegate = self
        picker.dataSource = self
        textField.inputView = picker
        picker.backgroundColor = UIColor.myWhite
        addBarOnTopOfPicker(for: textField)
    }
    
    private func addBarOnTopOfPicker(for textField: UITextField) {
        let bar = UIToolbar()
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        bar.setItems([flexibleSpace,doneButton], animated: false)
        bar.isUserInteractionEnabled = true
        textField.inputAccessoryView = bar
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    private func hideNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - UI rendering
private extension ConversionViewController {
    func configureScrollViewAndContainerView() {
        view.backgroundColor = UIColor.myWhite
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.topMargin.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
        scrollView.alwaysBounceVertical = true
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    func renderMoneyImageView() {
        containerView.addSubview(moneyImageView)
        
        moneyImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        moneyImageView.image = UIImage(named: "coinsIcon")
    }
    
    func configureCurrenciesStackView() {
        containerView.addSubview(currenciesStackView)
        
        currenciesStackView.snp.makeConstraints { make in
            make.top.equalTo(moneyImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        currenciesStackView.axis = .horizontal
        currenciesStackView.alignment = .center
        currenciesStackView.distribution = .equalCentering
        currenciesStackView.spacing = 50
    }
    
    func renderFromLabelAndFromTextField() {
        currenciesStackView.addArrangedSubview(fromCurrencyStackView)
        
        fromCurrencyStackView.axis = .vertical
        fromCurrencyStackView.alignment = .center
        fromCurrencyStackView.distribution = .equalSpacing
        fromCurrencyStackView.spacing = 5
        
        fromCurrencyStackView.addArrangedSubview(fromLabel)
        fromLabel.text = "FROM"
        fromLabel.font = fromLabel.font.withSize(22)
        
        fromCurrencyStackView.addArrangedSubview(fromCurrenyTextField)
        fromCurrenyTextField.placeholder = "USD"
        fromCurrenyTextField.borderStyle = .roundedRect
        fromCurrenyTextField.textAlignment = .center
    }
    
    func renderArrowsImageView() {
        currenciesStackView.addArrangedSubview(arrowsImageView)
        
        arrowsButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.centerX.equalToSuperview()
        }
        arrowsImageView.image = UIImage(named: "arrows")
    }
    
    func renderToLabelAndToTextField() {
        currenciesStackView.addArrangedSubview(toCurrencyStackView)
        
        toCurrencyStackView.axis = .vertical
        toCurrencyStackView.alignment = .center
        toCurrencyStackView.distribution = .equalSpacing
        toCurrencyStackView.spacing = 5
        
        toCurrencyStackView.addArrangedSubview(toLabel)
        toLabel.text = "TO"
        toLabel.font = toLabel.font.withSize(22)
        
        toCurrencyStackView.addArrangedSubview(toCurrencyTextField)
        toCurrencyTextField.placeholder = "EUR"
        toCurrencyTextField.borderStyle = .roundedRect
        toCurrencyTextField.textAlignment = .center
    }
    
    func renderAmountLabelAndAmountTextField() {
        containerView.addSubview(amountLabel)
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(currenciesStackView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        amountLabel.text = "Amount"
        amountLabel.font = amountLabel.font.withSize(20)
        
        containerView.addSubview(amountTextField)
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        amountTextField.placeholder = "100"
        amountTextField.keyboardType = .decimalPad
        amountTextField.textAlignment = .center
        amountTextField.font = amountTextField.font?.withSize(25)
        
        containerView.addSubview(amountTextFieldSeparator)
        
        amountTextFieldSeparator.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().inset(50)
            make.height.equalTo(1)
        }
        amountTextFieldSeparator.backgroundColor = .gray
    }
    
    func renderConvertButton() {
        containerView.addSubview(convertButton)
        
        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().inset(25)
            make.height.equalTo(45)
        }
        convertButton.setTitle("CONVERT", for: .normal)
        convertButton.layer.cornerRadius = 17
        convertButton.backgroundColor = #colorLiteral(red: 0.4915086031, green: 0.9697155356, blue: 0.2073277533, alpha: 1)
    }
    
    func renderResultLabelAndResultStackView() {
        containerView.addSubview(resultLabel)
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        resultLabel.text = "Result"
        resultLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        containerView.addSubview(resultStackView)
        
        resultStackView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        resultStackView.axis = .horizontal
        resultStackView.alignment = .center
        resultStackView.distribution = .equalSpacing
        resultStackView.spacing = 10
        resultStackView.isHidden = true
        
        resultStackView.addArrangedSubview(fromResultCurrencyLabel)
        fromResultCurrencyLabel.text = "\(amountTextField.text ?? "") \(fromCurrenyTextField.text ?? "")"
        
        resultStackView.addArrangedSubview(equalLabel)
        equalLabel.text = "="
        equalLabel.font = equalLabel.font.withSize(20)
        
        resultStackView.addArrangedSubview(toResultCurrencyLabel)
        toResultCurrencyLabel.text = "\(amountTextField.text ?? "") \(toCurrencyTextField.text ?? "")"
        
    }
    
    func renderResultSeparator() {
        containerView.addSubview(resultSeparator)
        
        resultSeparator.snp.makeConstraints { make in
            make.top.equalTo(resultStackView.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        resultSeparator.backgroundColor = .gray
    }
}

// MARK: - UIPickerView delegate
extension ConversionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCurrencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCurrencies[row].currencyCode
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fromCurrenyTextField.inputView {
            fromCurrenyTextField.text = "\(allCurrencies[row].currencyCode)"
        } else if pickerView == toCurrencyTextField.inputView {
            toCurrencyTextField.text = "\(allCurrencies[row].currencyCode)"
        }
    }
}
