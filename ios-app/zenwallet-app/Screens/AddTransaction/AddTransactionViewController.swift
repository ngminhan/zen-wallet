//
//  AddTransactionViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 9/11/25.
//

import UIKit
import CurrencyFormatter
import CurrencyUITextFieldDelegate

class AddTransactionViewController: UIViewController {
    
    @IBOutlet weak var amountContainerView: UIView!
    @IBOutlet weak var noteContainerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var noteTextfield: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let categories: [Category] = Category.allCases
    var selectedCategory: Category?
    var selectedTime: Date?
    
    private var currencyFormatter: CurrencyFormatter!
    private var textFieldDelegate: CurrencyUITextFieldDelegate!
    
    var onTransactionAdded: (() -> Void)?
    
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
        
        (currencyFormatter, textFieldDelegate) = setupCurrencyTextField(amountTextfield)
        
        let normalFont = UIFont(name: "Futura", size: 13)!
        let selectedFont = UIFont(name: "Futura", size: 13)!
        typeSegment.setTitleTextAttributes([.font: normalFont, .foregroundColor: UIColor.gray], for: .normal)
        typeSegment.setTitleTextAttributes([.font: selectedFont, .foregroundColor: UIColor.greenSheen], for: .selected)
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
        dismiss(animated: true)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        let amount = getCurrencyValue(from: amountTextfield, formatter: currencyFormatter)
        guard amount > 0,
              let note = noteTextfield.text, note.isEmpty == false else { return }
        
        let type = typeSegment.selectedSegmentIndex == 0 ? "INCOME" : "EXPENSE"
        
        var category: String? = nil
        if type == "EXPENSE" {
            guard let selected = selectedCategory else { return }
            category = selected.rawValue
        }
        
        let createdAt = selectedTime ?? Date()
        
        let viewModel = AddTransactionViewModel()
        viewModel.addTransaction(type: type, category: category, amount: amount, note: note, createdAt: createdAt) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Added transaction successfully")
                    self?.onTransactionAdded?()
                    self?.dismiss(animated: true)
                case .failure(let error):
                    print("❌ Failed to add transaction:", error.localizedDescription)
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

extension AddTransactionViewController: UICollectionViewDelegateFlowLayout {
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

extension AddTransactionViewController: UICollectionViewDataSource {
    
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
