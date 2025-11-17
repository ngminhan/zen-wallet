//
//  QuoteCollectionViewCell.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 15/11/25.
//

import UIKit

class QuoteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor = UIColor.greenSheen.cgColor
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 4
    }
    
    func configData(text: String) {
        quoteLabel.text = "\"\(text)\""
    }
}
