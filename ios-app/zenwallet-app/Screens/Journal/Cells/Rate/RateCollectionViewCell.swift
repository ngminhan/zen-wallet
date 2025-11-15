//
//  RateCollectionViewCell.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 14/11/25.
//

import UIKit

class RateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var starButtons: [UIButton]!
    
    var onRateChanged: ((Int) -> Void)?
    
    private var currentRate: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor = UIColor.greenSheen.cgColor
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 4
        
        for (index, button) in starButtons.enumerated() {
            button.tag = index + 1
        }
    }
    
    func configData(rate: Int?) {
        self.currentRate = rate ?? 0
        layoutIfNeeded()
        updateStarAppearance()
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        let newRate = sender.tag
        currentRate = newRate
        
        updateStarAppearance()
        onRateChanged?(newRate)
    }
    
    private func updateStarAppearance() {
        for (index, button) in starButtons.enumerated() {
            let isSelected = index < currentRate
            setSelectedStar(isSelected: isSelected, index: index)
        }
    }
    
    func setSelectedStar(isSelected: Bool, index: Int) {
        let button = starButtons[index]
        let starSize = button.frame.size
        let unSelectedImage = UIImage.starLine.resized(to: starSize)
        let selectedImage = UIImage.starFilled.resized(to: starSize)
        
        button.setImage(isSelected ? selectedImage : unSelectedImage, for: .normal)
    }
}
