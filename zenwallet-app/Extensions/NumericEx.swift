//
//  NumericEx.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 9/11/25.
//

import Foundation

extension Numeric {
    var formattedWithDot: String {
        let number = self as? Double ?? Double("\(self)") ?? 0
        let rounded = Double(Int(number)) 
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: rounded)) ?? "\(self)"
    }
}


