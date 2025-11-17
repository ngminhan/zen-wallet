//
//  NoteCollectionViewCell.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 14/11/25.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var noteTextView: UITextView!
    
    var onNoteChanged: ((String?) -> Void)?
    var onHeightChange: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderWidth = 4
        containerView.layer.borderColor = UIColor.greenSheen.cgColor
        containerView.layer.cornerRadius = 20
        noteTextView.delegate = self
        noteTextView.layer.cornerRadius = 10
        noteTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func configData(note: String?) {
        noteTextView.text = note
    }
}

extension NoteCollectionViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onNoteChanged?(textView.text)
        onHeightChange?()
    }
}
