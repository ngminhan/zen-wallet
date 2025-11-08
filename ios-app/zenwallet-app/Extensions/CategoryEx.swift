//
//  CategoryEx.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 8/11/25.
//

extension Category {
    var displayName: String {
        switch self {
        case .essential: return "Essential"
        case .nonEssential: return "Non-essential"
        case .spiritual: return "Spiritual"
        case .unexpected: return "Unexpected"
        }
    }
}
