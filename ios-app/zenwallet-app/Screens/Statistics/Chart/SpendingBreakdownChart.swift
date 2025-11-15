//
//  SpendingBreakdow.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 14/11/25.
//

import SwiftUI
import Charts

// MARK: - CUSTOM LEGEND VIEW
struct CustomLegendView: View {
    let data: [ExpenseCategoryItem]
    let customFont: Font
    
    // Ánh xạ màu dựa trên Category (Cần định nghĩa Color cho từng Category trong project của bạn)
    private func categoryColor(_ categoryRaw: String) -> Color {
        // Đây là ví dụ, bạn cần thay thế bằng logic ánh xạ màu thực tế của bạn
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
                    
                    // Hiển thị displayText và phần trăm/số tiền
                    VStack(alignment: .leading, spacing: 3) {
                        // Label chính (Sử dụng displayText và Font tùy chỉnh)
                        Text(displayLabel)
                            .font(customFont)
                            .foregroundColor(Color(.text))
                        
                        // Giá trị phụ (Ví dụ: 100.000₫)
                        Text(item.amount.formattedWithDot) // Giả định .formattedWithDot khả dụng
                            .font(customFont)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}


// MARK: - MAIN CHART VIEW
struct SpendingBreakdownChart: View {
    let data: [ExpenseCategoryItem]

    // Khai báo Font tùy chỉnh
    private let customFont = Font(UIFont(name: "Futura", size: 12)!) // Có thể điều chỉnh size

    // Ánh xạ màu sắc cho Chart
    private func categoryColor(_ categoryRaw: String) -> Color {
        // Cần đồng bộ với CustomLegendView
        switch Category(rawValue: categoryRaw) {
        case .essential: return .essential
        case .nonEssential: return .nonEssential
        case .spiritual: return .spiritual
        case .unexpected: return .unexpected
        case .none: return .gray
        }
    }

    // Ánh xạ displayText cho Chart
    private func categoryDisplayText(for rawValue: String) -> String {
        return Category(rawValue: rawValue)?.displayText ?? rawValue
    }
    
    var body: some View {
        // Sử dụng HStack để bố cục Chart và Legend cạnh nhau
        HStack(alignment: .top, spacing: 16) {
            // 1. CHART (Khoảng 60% chiều rộng)
            Chart(data, id: \.category) { item in
                SectorMark(
                    angle: .value("Amount", item.amount),
                    innerRadius: .ratio(0.6), // Tăng innerRadius để tạo Donut đẹp hơn
                    angularInset: 4.0
                )
                // Áp dụng màu sắc tùy chỉnh
                .foregroundStyle(categoryColor(item.category))
                // Dùng displayText để Tooltip hiển thị nhãn chính xác (nếu bạn bật Tooltip)
                .accessibilityLabel(categoryDisplayText(for: item.category))
            }
            .frame(width: 230, height: 230) // Cố định kích thước Chart
            .chartLegend(.hidden) // Ẩn Legend mặc định

            // 2. CUSTOM LEGEND (Khoảng 40% còn lại)
            CustomLegendView(data: data, customFont: customFont)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 30)
        }
        .frame(height: 280, alignment: .top) // Khung View tổng thể
        .padding(.horizontal)
        .padding(.top, 20)
        .animation(.easeOut(duration: 0.3), value: data)
    }
}
