//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Anton Gorlov on 06.02.2025.
//

import UIKit

class ConverterViewController: UIViewController {
    private let viewModel: ConverterViewModel
    private var debounceTimer: Timer?
    
    private let amountTextField = UITextField()
    private let fromCurrencyPicker = UIPickerView()
    private let toCurrencyPicker = UIPickerView()
    private let imageView = UIImageView(image: UIImage(systemName: "arrowshape.right.circle.fill"))
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        
        return label
    }()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    init(viewModel: ConverterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        viewModel.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = .cyan.withAlphaComponent(0.8)
        
        amountTextField.placeholder = "Amount"
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
        amountTextField.delegate = self
        
        amountTextField.addTarget(
            self,
            action: #selector(amountTextFieldDidChange),
            for: .editingChanged
        )
        activityIndicator.color = UIColor.systemBlue
        
        fromCurrencyPicker.delegate = self
        fromCurrencyPicker.dataSource = self
        toCurrencyPicker.delegate = self
        toCurrencyPicker.dataSource = self
        
        [amountTextField, fromCurrencyPicker, imageView, toCurrencyPicker, resultLabel, activityIndicator]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
        
        fromCurrencyPicker.selectRow(0, inComponent: 0, animated: false)
        toCurrencyPicker.selectRow(1, inComponent: 0, animated: false)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            amountTextField.heightAnchor.constraint(equalToConstant: 44),
            
            fromCurrencyPicker.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
            fromCurrencyPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fromCurrencyPicker.trailingAnchor.constraint(equalTo: imageView.leadingAnchor),
            fromCurrencyPicker.heightAnchor.constraint(equalToConstant: 120),
            
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: fromCurrencyPicker.centerYAnchor),
            imageView.centerYAnchor.constraint(equalTo: toCurrencyPicker.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            toCurrencyPicker.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
            toCurrencyPicker.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            toCurrencyPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            toCurrencyPicker.heightAnchor.constraint(equalTo: fromCurrencyPicker.heightAnchor),
            
            resultLabel.topAnchor.constraint(equalTo: toCurrencyPicker.bottomAnchor, constant: 20),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func clearResult() {
        resultLabel.text = ""
    }
    
    // MARK: - Pickers
    
    private func selectedCurrency(for pickerView: UIPickerView) -> String? {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        guard selectedRow < viewModel.getAllCurrencies().count else { return nil }
        
        return viewModel.getAllCurrencies()[selectedRow].code
    }
    
    // MARK: - Actions
    
    @objc private func amountTextFieldDidChange(_ textField: UITextField) {
        debounceTimer?.invalidate()
        debounceTimer = nil
        clearResult()
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        
        debounceTimer = Timer.scheduledTimer(
            withTimeInterval: 1.5,
            repeats: false
        ) { [weak self] _ in
            self?.performConversionAction()
        }
    }
    
    private func performConversionAction() {
        let fromCurrency = selectedCurrency(for: fromCurrencyPicker)
        let toCurrency = selectedCurrency(for: toCurrencyPicker)
        clearResult()
        
        Task {
            await viewModel.convertCurrencyAction(
                amount: amountTextField.text,
                from: fromCurrency,
                to: toCurrency
            )
        }
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension ConverterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.getAllCurrencies().count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.text = (viewModel.getAllCurrencies()[row].code)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.backgroundColor = UIColor.systemBlue
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        44
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        let allCurrencies = viewModel.getAllCurrencies()
        let selectedCurrency = allCurrencies[row]
        
        if pickerView == fromCurrencyPicker {
            if selectedCurrency.code == allCurrencies[toCurrencyPicker.selectedRow(inComponent: 0)].code {
                toCurrencyPicker.selectRow((row + 1) % allCurrencies.count,
                                           inComponent: 0,
                                           animated: true)
            }
        } else {
            if selectedCurrency.code == allCurrencies[fromCurrencyPicker.selectedRow(inComponent: 0)].code {
                fromCurrencyPicker.selectRow((row + 1) % allCurrencies.count,
                                             inComponent: 0,
                                             animated: true)
            }
        }
        performConversionAction()
    }
}

// MARK: - UITextFieldDelegate

extension ConverterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn
                   range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return true
        }
        
        let notAvailableCharacter = ","
        let availableCharacter = "."
        let modifiedString = string.replacingOccurrences(of: notAvailableCharacter, with: availableCharacter)
        let newText = text.replacingCharacters(in: textRange, with: modifiedString)
        
        if newText.isEmpty {
            return true
        }
        
        if string.contains(notAvailableCharacter) && viewModel.isValidationAmountInput(newText) {
            textField.text = newText
          
            return false
        }
        
        return viewModel.isValidationAmountInput(newText)
    }
}

// MARK: - IConverterViewModelDelegate

extension ConverterViewController: IConverterViewModelDelegate {
    func startLoading() {
        self.activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        self.activityIndicator.stopAnimating()
    }
    
    func receiveError(_ error: ConverterError) {
        let alert = UIAlertController(
            title: "Error",
            message: error.errorDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func convertedAmount(_ result: ConverterData) {
        self.resultLabel.text = result.amount
    }
    
}

