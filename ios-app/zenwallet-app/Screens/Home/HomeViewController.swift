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
    @IBOutlet weak var transactionTableView: UITableView!
    
    private var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        transactionTableView.dataSource = self
        transactionTableView.delegate = self
        
        transactionTableView.register(TransactionTableViewCell.nib, forCellReuseIdentifier: TransactionTableViewCell.identifier)
        transactionTableView.rowHeight = UITableView.automaticDimension
        transactionTableView.estimatedRowHeight = 80
        
        loadTransactions()
        
    }
    
    func setupUI() {
        incomeView.layer.cornerRadius = 10
        expenseView.layer.cornerRadius = 10
    }
    
    func loadTransactions() {
        TransactionService.shared.fetchTransactions {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let transactions):
                self.transactions = transactions
                DispatchQueue.main.async {
                    self.transactionTableView.reloadData()
                }
            case .failure(let error):
                print("Fetch failed:", error)
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        
        cell.configData(transaction: transactions[indexPath.item])
        
        return cell
    }
}
