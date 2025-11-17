//
//  UIAplication.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 28/10/25.
//

import UIKit

extension UIApplication {
    static var sceneDelegate: SceneDelegate? {
        return UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate
    }
}

