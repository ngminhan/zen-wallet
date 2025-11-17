//
//  UITableViewCellEx.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 7/11/25.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}


