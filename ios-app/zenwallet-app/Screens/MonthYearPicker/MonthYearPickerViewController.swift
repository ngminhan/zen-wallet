//
//  MonthYearPickerViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 12/11/25.
//

import UIKit

class MonthYearPickerViewController: UIViewController {

    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var containerStackView: UIStackView!
    
    var onMonthYearChanged: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPicker()
    }
    
    func setupUI() {
        containerStackView.layer.cornerRadius = 30
        containerStackView.layer.borderWidth = 10
        containerStackView.layer.borderColor = UIColor.greenSheen.cgColor
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    func setupPicker() {
        picker.datePickerMode = .yearAndMonth
    }
    
    @IBAction func cancelButtonChanged(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func doneButtonChanged(_ sender: Any) {
        onMonthYearChanged?(picker.date)
        dismiss(animated: false)
    }
}
