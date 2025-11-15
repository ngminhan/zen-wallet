//
//  U.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 10/11/25.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
