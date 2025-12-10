//
//  HomeViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 28/10/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var incomeView: UIView!
    @IBOutlet weak var expenseView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private let homeViewModel = HomeViewModel()
    
    private var currentFilter: TimeFilter = .day
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        transactionTableView.dataSource = self
        transactionTableView.delegate = self
        
        transactionTableView.register(TransactionTableViewCell.nib, forCellReuseIdentifier: TransactionTableViewCell.identifier)
        transactionTableView.rowHeight = 80
        
        loadTransactions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTransactionUpdate), name: .transactionDidUpdate, object: nil)
    }
    
    @objc func handleTransactionUpdate() {
        self.loadTransactions()
    }
    
    func setupUI() {
        incomeView.layer.cornerRadius = 25
        expenseView.layer.cornerRadius = 25
        
        containerView.layer.cornerRadius = 40
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView.clipsToBounds = true
        
        let normalFont = UIFont(name: "Futura", size: 13)!
        let selectedFont = UIFont(name: "Futura", size: 13)!
        
        segmentControl.setTitleTextAttributes([.font: normalFont, .foregroundColor: UIColor.gray], for: .normal)
        segmentControl.setTitleTextAttributes([.font: selectedFont, .foregroundColor: UIColor.white], for: .selected)
        
        addButton.layer.cornerRadius = 30
        addButton.setImage(.addRecord.resized(to: CGSize(width: 60, height: 60)), for: .normal)
    }
    
    func loadTransactions() {
        TransactionService.shared.fetchTransactions {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let transactions):
                DispatchQueue.main.async {
                    self.homeViewModel.updateTransactions(transactions, filter: self.currentFilter)
                    self.updateUI()
                }
            case .failure(let error):
                print("Fetch failed:", error)
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let filters: [TimeFilter] = [.day, .week, .month, .year]
        currentFilter = filters[sender.selectedSegmentIndex]
        homeViewModel.applyFilter(currentFilter)
        updateUI()
    }
    
    func updateUI() {
        incomeLabel.text = homeViewModel.totalIncome.formattedWithDot
        expenseLabel.text = homeViewModel.totalExpense.formattedWithDot
        transactionTableView.reloadData()
        
        if homeViewModel.filteredTransactions.isEmpty {
            transactionTableView.setEmptyMessage("No transaction recorded")
        } else {
            transactionTableView.restore()
        }
        
    }
    
    func showTransactionDetail(_ transaction: Transaction) {
        let transactionDetailVC = TransactionDetailViewController()
        let viewModel = TransactionDetailViewModel(transaction: transaction)
        transactionDetailVC.viewModel = viewModel
        transactionDetailVC.modalPresentationStyle = .automatic
        present(transactionDetailVC, animated: true)
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        let addTransactionViewController = AddTransactionViewController()
        addTransactionViewController.modalPresentationStyle = .automatic
        present(addTransactionViewController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = homeViewModel.filteredTransactions[indexPath.row]
        showTransactionDetail(transaction)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.filteredTransactions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        
        cell.configData(transaction: homeViewModel.filteredTransactions[indexPath.item])
        cell.selectionStyle = .none
        
        return cell
        
    }
}
