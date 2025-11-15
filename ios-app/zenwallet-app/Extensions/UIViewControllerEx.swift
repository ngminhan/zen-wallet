//
//  UIViewControllerEx.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 11/11/25.
//

import UIKit
import CurrencyUITextFieldDelegate
import CurrencyFormatter

extension UIViewController {
    
    func showConfirmAlert(title: String = "", message: String, okTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title.isEmpty ? nil : title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func showSelectAlert(title: String = "", message: String,
                         cancelTitle: String = "Cancel",
                         okTitle: String = "OK",
                         onOK: (() -> Void)? = nil,
                         onCancel: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title.isEmpty ? nil : title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            onCancel?()
        }
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            DispatchQueue.main.async {
                onOK?()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func setupCurrencyTextField(
        _ textField: UITextField,
        hasDecimals: Bool = false,
        currencySymbol: String = ""
    ) -> (CurrencyFormatter, CurrencyUITextFieldDelegate) {
        
        let formatter = CurrencyFormatter {
            $0.hasDecimals = hasDecimals
            $0.currencySymbol = currencySymbol
        }
        
        let delegate = CurrencyUITextFieldDelegate(formatter: formatter)
        textField.delegate = delegate
        textField.keyboardType = .numberPad
        
        return (formatter, delegate)
    }
    
    func setCurrencyText(
        _ textField: UITextField,
        formatter: CurrencyFormatter,
        amount: Double
    ) {
        textField.text = formatter.string(from: Double(truncating: NSNumber(value: amount)))
    }
    
    func getCurrencyValue(
        from textField: UITextField,
        formatter: CurrencyFormatter
    ) -> Double {
        let formatted = textField.text ?? "0"
        let unformatted = formatter.unformatted(string: formatted) ?? "0"
        return Double(unformatted) ?? 0
    }
}
