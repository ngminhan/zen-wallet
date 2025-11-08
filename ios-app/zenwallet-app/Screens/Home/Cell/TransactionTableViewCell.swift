//
//  TransactionTableViewCell.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 7/11/25.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = containerView.frame.height / 2
    }
    
    func configData(transaction: Transaction) {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        timeLabel.text = formatter.string(from: transaction.createdAt)
        
        let amountText = String(format: "%.0f", transaction.amount)
        
        switch transaction.type {
        case .income:
            containerView.backgroundColor = .systemTeal.withAlphaComponent(0.2)
            amountLabel.textColor = .systemTeal
            amountLabel.text = "+\(amountText)"
            categoryImage.image = UIImage.profit
            
            if let note = transaction.note, !note.isEmpty {
                noteLabel.text = note
            } else {
                noteLabel.text = "Income"
            }
            
        case .expense:
            containerView.backgroundColor = .systemRed.withAlphaComponent(0.15)
            amountLabel.textColor = .systemRed
            amountLabel.text = "-\(amountText)"
            
            if let note = transaction.note, !note.isEmpty {
                noteLabel.text = note
            } else {
                noteLabel.text = transaction.category.displayName
            }
            
            switch transaction.category {
            case .essential:
                categoryImage.image = UIImage.essential
            case .nonEssential:
                categoryImage.image = UIImage.nonEssential
            case .spiritual:
                categoryImage.image = UIImage.spiritual
            case .unexpected:
                categoryImage.image = UIImage.unexpected
            }
        }
    }
    
}
