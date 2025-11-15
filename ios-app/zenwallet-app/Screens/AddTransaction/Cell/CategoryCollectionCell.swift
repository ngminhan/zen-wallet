//
//  CategoryCollectionCell.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 10/11/25.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = isSelected ? .mossGreen : .creamyYellow
        }
    }

    private func setupUI() {
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
    }
    
    func configData(category: Category) {
        categoryImage.image = category.icon
        categoryLabel.text = category.displayText
    }
}
