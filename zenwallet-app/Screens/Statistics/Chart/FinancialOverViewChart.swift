//
//  FinancialOverviewChart.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 14/11/25.
//
import SwiftUI
import Charts

enum ChartType: String, CaseIterable, Identifiable {
    case income = "Income"
    case expense = "Expense"
    case balance = "Balance"
    var id: String { rawValue }
    
    var config: (label: String, color: Color, isDashed: Bool) {
        switch self {
        case .income: return ("Income", Color(uiColor: UIColor.incomeLine), false)
        case .expense: return ("Expense", Color(uiColor: UIColor.expenseLine), false)
        case .balance: return ("Balance", Color(uiColor: UIColor.balanceLine), false)
        }
    }
}

struct FinancialOverviewChart: View {
    let data: [FinancialOverviewItem]
    let selectedType: ChartType
    
    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let customFont = Font(UIFont(name: "Futura", size: 9)!)
    
    private func dateFromBucket(_ bucket: String) -> Date {
        if let d = Self.isoFormatter.date(from: bucket) {
            return d
        }
        if let d = Self.dateFormatter.date(from: bucket) {
            return d
        }
        return Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    }
    
    var body: some View {
        VStack {
            Chart {
                ForEach(data, id: \.bucket) { item in
                    let chartDate = dateFromBucket(item.bucket)
                    let config = selectedType.config
                    
                    let value: Double = {
                        switch selectedType {
                        case .income: return item.income
                        case .expense: return item.expense
                        case .balance: return item.balance
                        }
                    }()
                    
                    LineMark(x: .value("Date", chartDate, unit: .day), y: .value("Amount", value))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(config.color)
                        .lineStyle(StrokeStyle(lineWidth: 3, dash: config.isDashed ? [6, 4] : []))
                    
                    PointMark(x: .value("Date", chartDate, unit: .day), y: .value("Amount", value))
                        .foregroundStyle(config.color)
                        .symbol(.circle)
                }
            }
            
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let amount = value.as(Double.self) {
                            Text(amount.formattedWithDot)
                                .font(customFont)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date, format: .dateTime.day().month())
                                .font(customFont)
                        }
                    }
                }
            }
            .frame(height: 260)
            .padding(.horizontal, 5)
            .padding(.vertical, 5)
        }
        .background(Color.clear)
    }
}

