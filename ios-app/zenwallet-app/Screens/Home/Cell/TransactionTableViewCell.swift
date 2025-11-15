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
    
    func setupUI() {
        containerView.layoutIfNeeded()
        containerView.layer.cornerRadius = containerView.frame.height / 2
        containerView.layer.masksToBounds = true
    }
    
    func configData(transaction: Transaction) {
        timeLabel.text = transaction.createdAt.toLocalString(format: "HH:mm, dd/MM/yyyy")
        
        let amountText = transaction.amount.formattedWithDot
        
        switch transaction.type {
        case .income:
            containerView.backgroundColor = .lightBlue
            amountLabel.text = "+\(amountText)"
            categoryImage.image = UIImage.profit
            
            if let note = transaction.note, !note.isEmpty {
                noteLabel.text = note
            } else {
                noteLabel.text = "Income"
            }
            
        case .expense:
            containerView.backgroundColor = .salmon
            amountLabel.text = "-\(amountText)"
            
            if let note = transaction.note, !note.isEmpty {
                noteLabel.text = note
            } else {
                noteLabel.text = transaction.category?.displayName
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
            case .none:
                break
            }
        }
    }
    
}
