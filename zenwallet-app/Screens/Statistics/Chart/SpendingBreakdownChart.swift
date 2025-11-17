//
//  SpendingBreakdow.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 14/11/25.
//

import SwiftUI
import Charts

struct CustomLegendView: View {
    let data: [ExpenseCategoryItem]
    let customFont: Font
    
    private func categoryColor(_ categoryRaw: String) -> Color {
        switch Category(rawValue: categoryRaw) {
        case .essential: return .essential
        case .nonEssential: return .nonEssential
        case .spiritual: return .spiritual
        case .unexpected: return .unexpected
        case .none: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(data.sorted(by: { $0.amount > $1.amount }), id: \.category) { item in
                let categoryType = Category(rawValue: item.category)
                let displayLabel = categoryType?.displayText ?? item.category
                let categoryColor = categoryColor(item.category)
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(categoryColor)
                        .frame(width: 10, height: 10)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(displayLabel)
                            .font(customFont)
                            .foregroundColor(Color(.text))
                        
                        Text(item.amount.formattedWithDot)
                            .font(customFont)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct SpendingBreakdownChart: View {
    let data: [ExpenseCategoryItem]
    
    private let customFont = Font(UIFont(name: "Futura", size: 12)!)
    
    private func categoryColor(_ categoryRaw: String) -> Color {
        switch Category(rawValue: categoryRaw) {
        case .essential: return .essential
        case .nonEssential: return .nonEssential
        case .spiritual: return .spiritual
        case .unexpected: return .unexpected
        case .none: return .gray
        }
    }
    
    private func categoryDisplayText(for rawValue: String) -> String {
        return Category(rawValue: rawValue)?.displayText ?? rawValue
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Chart(data, id: \.category) { item in
                SectorMark(
                    angle: .value("Amount", item.amount),
                    innerRadius: .ratio(0.6),
                    angularInset: 4.0
                )
                .foregroundStyle(categoryColor(item.category))
                .accessibilityLabel(categoryDisplayText(for: item.category))
            }
            .frame(width: 230, height: 230)
            .chartLegend(.hidden)
            
            CustomLegendView(data: data, customFont: customFont)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 30)
        }
        .frame(height: 280, alignment: .top) 
        .padding(.horizontal)
        .padding(.top, 20)
        .animation(.easeOut(duration: 0.3), value: data)
    }
}
