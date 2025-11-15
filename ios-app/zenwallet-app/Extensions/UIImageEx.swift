//
//  UIImageEx.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 9/11/25.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func resized(by scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width * scale,
                             height: self.size.height * scale)
        return resized(to: newSize)
    }
}
