//
//  CustomTabBar.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 7/11/25.
//

import UIKit

final class CustomTabBar: UITabBar {
    private let shopButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShopButton()
        setUpAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShopButton()
        setUpAppearance()
    }
    
    private func setupShopButton() {
        shopButton.backgroundColor = .greenSheen
        
        var config = UIButton.Configuration.plain()
        config.image = nil
        config.imagePlacement = .top
        config.imagePadding = 5
        config.attributedTitle = AttributedString("Shop", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white
        ]))
        
        shopButton.configuration = config
        
        addSubview(shopButton)
        bringSubviewToFront(shopButton)
        
        shopButton.addTarget(self, action: #selector(shopButtonTapped), for: .touchUpInside)
    }
    
    @objc private func shopButtonTapped() {
        (self.window?.rootViewController as? UITabBarController)?.selectedIndex = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tabbarHeight = super.sizeThatFits(bounds.size).height
        let buttonSize = tabbarHeight * 0.88
        
        shopButton.frame = CGRect(
            x: (bounds.width - buttonSize) / 2,
            y: -16,
            width: buttonSize,
            height: buttonSize
        )
        shopButton.layer.cornerRadius = shopButton.frame.width/2
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        let padding: CGFloat = 15
        newSize.height += padding
        return newSize
    }
    
    func setUpAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
    }
}
