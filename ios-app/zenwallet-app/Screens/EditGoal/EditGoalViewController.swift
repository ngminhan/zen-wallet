//
//  EditGoalViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 12/11/25.
//

import UIKit
import CurrencyUITextFieldDelegate
import CurrencyFormatter

class EditGoalViewController: UIViewController {
    
    @IBOutlet weak var goalCotainerView: UIView!
    @IBOutlet weak var goalTextfield: UITextField!
    
    
    var viewModel: GoalsViewModel!
    
    var onGoalEditted: ((Goal) -> Void)?
    
    private var currencyFormatter: CurrencyFormatter!
    private var textFieldDelegate: CurrencyUITextFieldDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        goalCotainerView.layer.cornerRadius = 25
        goalTextfield.text = String((viewModel.goal?.amount) ?? 0)
        
        (currencyFormatter, textFieldDelegate) = setupCurrencyTextField(goalTextfield)
        
        let initialAmount = viewModel.goal?.amount ?? 0
        setCurrencyText(goalTextfield, formatter: currencyFormatter, amount: initialAmount)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let newGoalAmount = getCurrencyValue(from: goalTextfield, formatter: currencyFormatter)
        
        viewModel.updateGoal(amount: newGoalAmount, completion: { [weak self] result in
            switch result {
            case .success(let updatedTransaction):
                self?.onGoalEditted?(updatedTransaction)
                self?.dismiss(animated: true)
            case .failure(let error):
                print("❌ Update failed:", error.localizedDescription)
            }
        })
    }
}
