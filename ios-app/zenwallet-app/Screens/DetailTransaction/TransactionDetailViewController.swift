//
//  TransactionDetailViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 11/11/25.
//

import UIKit

class TransactionDetailViewController: UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var viewModel: TransactionDetailViewModel!
    
    var onTransactionDeleted: (() -> Void)?
    var onTransactionEditted: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configData(transaction: viewModel.transaction)
    }
    
    func configData(transaction: Transaction) {
        typeLabel.text = transaction.type.displayText
        amountLabel.text = transaction.amount.formattedWithDot
        noteLabel.text = transaction.note
        
        timeLabel.text = transaction.createdAt.toLocalString(format: "HH:mm, dd/MM/yyyy")
        
        view.backgroundColor = transaction.type.themeColor
        
        if transaction.type == .expense {
            categoryStackView.isHidden = false
            categoryImage.image = transaction.category?.icon
            categoryLabel.text = transaction.category?.displayText
        } else {
            categoryStackView.isHidden = true
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let editTransactionVC = EditTransactionViewController()
        editTransactionVC.viewModel = viewModel
        editTransactionVC.onTransactionUpdated = { [weak self] updatedTransaction in
            self?.configData(transaction: updatedTransaction)
            self?.onTransactionEditted?()
        }
        editTransactionVC.modalPresentationStyle = .overCurrentContext
        present(editTransactionVC, animated: false)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        showSelectAlert(title: "Delete Transaction",
                        message: "Are you sure you want to delete this transaction?",
                        cancelTitle: "No",
                        okTitle: "Yes",
                        onOK: { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteTransaction { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("🗑️ Deleted successfully")
                        self.onTransactionDeleted?()
                        self.dismiss(animated: true)
                    case .failure(let error):
                        self.showConfirmAlert(title: "❌ Error", message: error.localizedDescription)
                    }
                }
            }
        })
    }
    
    
    
}

