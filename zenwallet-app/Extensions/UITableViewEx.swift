//
//  UITableViewEx.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 9/11/25.
//

import UIKit

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Futura", size: 16)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView(frame: bounds)
        container.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        self.backgroundView = container
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
    }
}
