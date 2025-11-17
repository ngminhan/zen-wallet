//
//  EditTransactionViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 11/11/25.
//

import UIKit
import CurrencyFormatter
import CurrencyUITextFieldDelegate

class EditTransactionViewController: UIViewController {
    
    @IBOutlet weak var amountContainerView: UIView!
    @IBOutlet weak var noteContainerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var noteTextfield: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var viewModel: TransactionDetailViewModel!
    
    private var currencyFormatter: CurrencyFormatter!
    private var textFieldDelegate: CurrencyUITextFieldDelegate!
    
    let categories: [Category] = Category.allCases
    var selectedCategory: Category?
    var selectedTime: Date?
    
    var onTransactionUpdated: ((Transaction) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCategoryCollectionView()
        setupDatePicker()
    }
    
    func setupUI() {
        amountContainerView.layer.cornerRadius = 16
        noteContainerView.layer.cornerRadius = 16
        cancelButton.layer.cornerRadius = 8
        doneButton.layer.cornerRadius = 8
        
        let transaction = viewModel.transaction
        noteTextfield.text = transaction.note
        
        typeSegment.selectedSegmentIndex = transaction.type == .income ? 0 : 1
        let normalFont = UIFont(name: "Futura", size: 13)!
        let selectedFont = UIFont(name: "Futura", size: 13)!
        typeSegment.setTitleTextAttributes([.font: normalFont, .foregroundColor: UIColor.gray], for: .normal)
        typeSegment.setTitleTextAttributes([.font: selectedFont, .foregroundColor: UIColor.greenSheen], for: .selected)
        
        selectedCategory = transaction.category
        categoryCollectionView.reloadData()
        
        if let currentCategory = transaction.category,
           let index = categories.firstIndex(of: currentCategory) {
            let indexPath = IndexPath(item: index, section: 0)
            DispatchQueue.main.async { [weak self] in
                self?.categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }
        
        categoryCollectionView.reloadData()
        
        datePicker.date = transaction.createdAt
        selectedTime = transaction.createdAt
        
        view.backgroundColor = transaction.type == .income ? .lightBlue : .salmon
        categoryCollectionView.isHidden = transaction.type == .income
        
        (currencyFormatter, textFieldDelegate) = setupCurrencyTextField(amountTextfield)
        let initialAmount = transaction.amount
        setCurrencyText(amountTextfield, formatter: currencyFormatter, amount: initialAmount)
    }
    
    func setupDatePicker() {
        datePicker.maximumDate = Date()
        selectedTime = datePicker.date
    }
    
    func setupCategoryCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCollectionCell.nib, forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        let amount = getCurrencyValue(from: amountTextfield, formatter: currencyFormatter)
        guard amount > 0 else { return }
        
        let type = typeSegment.selectedSegmentIndex == 0 ? "INCOME" : "EXPENSE"
        let note = noteTextfield.text ?? ""
        let createdAt = selectedTime ?? Date()
        
        var category: String? = nil
        if type == "EXPENSE" {
            guard let selected = selectedCategory else { return }
            category = selected.rawValue
        }
        
        viewModel.updateTransaction(
            type: type,
            category: category,
            amount: amount,
            note: note,
            createdAt: createdAt
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedTransaction):
                    self?.onTransactionUpdated?(updatedTransaction)
                    self?.dismiss(animated: false)
                case .failure(let error):
                    print("Update failed:", error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch typeSegment.selectedSegmentIndex {
        case 0:
            categoryCollectionView.isHidden = true
            view.backgroundColor = .lightBlue
        case 1:
            categoryCollectionView.isHidden = false
            view.backgroundColor = .salmon
        default:
            break
        }
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        selectedTime = datePicker.date
    }
}

extension EditTransactionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let spacing: CGFloat = 7
        let columns: CGFloat = 4
        let totalSpacing = (columns - 1) * spacing
        let availableWidth = collectionView.frame.width - totalSpacing
        let itemWidth = floor(availableWidth / columns)
        
        return CGSize(width: itemWidth, height: itemWidth + 20)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
    }
    
}

extension EditTransactionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier, for: indexPath) as! CategoryCollectionCell
        
        cell.configData(category: categories[indexPath.item])
        
        return cell
    }
}
