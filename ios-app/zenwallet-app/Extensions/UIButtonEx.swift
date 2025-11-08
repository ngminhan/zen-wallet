//
//  UIButtonEx.swift
//  zenwallet
//
//  Created by Nguyễn Minh An on 26/10/25.
//

import UIKit

extension UIButton {
    func setResizedImage(named image: UIImage,
                         scaleRatio: CGFloat = 0.6,
                         backgroundColor: UIColor? = nil,
                         cornerRadius: CGFloat? = nil) {
        self.configuration = nil
        
        let buttonHeight = self.frame.height
        let imageSize = CGSize(width: buttonHeight * scaleRatio,
                               height: buttonHeight * scaleRatio)
        
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: imageSize))
        }
        
        self.setImage(resizedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment = .center
        
        if let radius = cornerRadius {
            self.layer.cornerRadius = radius
            self.clipsToBounds = true
        }
        if let bg = backgroundColor {
            self.backgroundColor = bg
        }
    }
}


