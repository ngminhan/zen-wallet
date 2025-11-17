//
//  QuestionCollectionViewCell.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 14/11/25.
//

import UIKit

class QuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    
    var onAnswerChanged: ((String) -> Void)?
    var onHeightChange: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        answerTextView.delegate = self
        answerTextView.layer.cornerRadius = 10
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor = UIColor.greenSheen.cgColor
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 4
        answerTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func configData(question: String?, answer: String?) {
        self.answerTextView.text = answer
        self.questionLabel.text = question
    }
}

extension QuestionCollectionViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        onAnswerChanged?(textView.text)
        onHeightChange?()
    }
}
