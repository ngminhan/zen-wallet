//
//  UIViewEx.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 15/11/25.
//

import UIKit

extension UIView {
    static func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
    }
}
