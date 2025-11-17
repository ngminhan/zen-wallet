//
//  Journal.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 15/11/25.
//

enum JournalCardType {
    case quote(String)
    case autoSummary(AutoSummaryResponse?)
    case rate(Int?)
    case question(text: String, answer: String?)
    case note(String?)
}

struct JournalResponse: nonisolated Decodable {
    let date: String
    let quote: String
    let question: String
    var answer: String?
    var rate: Int?
    var note: String?
    let autoSummary: AutoSummaryResponse?
}

struct JournalRequest: nonisolated Encodable {
    let date: String
    let quote: String
    let question: String
    let answer: String?
    let rate: Int?
    let note: String?
}

struct JournalListItem: nonisolated Decodable {
    let date: String
    let rate: Int?
}

struct AutoSummaryResponse: nonisolated Decodable {
    let totalIncome: Double
    let totalExpense: Double
    let topCategory: String?

    let commentToday: String
    let savingChange: Double
    let commentSaving: String

    enum CodingKeys: String, CodingKey {
        case totalIncome = "total_income"
        case totalExpense = "total_expense"
        case topCategory = "top_category"
        case commentToday = "comment_today"
        case savingChange = "saving_change"
        case commentSaving = "comment_saving"
    }
}

extension JournalResponse {
    func toItems() -> [JournalCardType] {
        return [
            .quote(quote),
            .autoSummary(autoSummary),
            .rate(rate),
            .question(text: question, answer: answer),
            .note(note)
        ]
    }
}

