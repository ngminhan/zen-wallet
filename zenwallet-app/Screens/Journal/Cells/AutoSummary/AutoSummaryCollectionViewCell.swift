//
//  AutoSummaryCollectionViewCell.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 14/11/25.
//

import UIKit

class AutoSummaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderColor = UIColor.greenSheen.cgColor
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        summaryLabel.text = ""
    }
    
    func configData(summary: AutoSummaryResponse?) {
        guard let summary = summary else {
            summaryLabel.text = "Loading summary..."
            return
        }
        
        let text = "\(summary.commentToday)\n*********\n\(summary.commentSaving)"
        
        let attributed = NSMutableAttributedString(string: text)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 6
        attributed.addAttribute(.paragraphStyle,
                                value: paragraph,
                                range: NSMakeRange(0, attributed.length))
        
        summaryLabel.attributedText = attributed
    }
}
