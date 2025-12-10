//
//  JournalViewModel.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 15/11/25.
//

import Foundation

class JournalViewModel {
    
    var journal: JournalResponse?
    
    var selectedDate: Date = Date()
    
    func fetchJournal(for date: String, completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        
        JournalService.shared.fetchJournal(date: dateString) { result in
            switch result {
            case .success(let data):
                self.journal = data
                print(data)
                completion()
            case .failure(let error):
                print("Error fetching journal:", error)
                completion()
            }
        }
    }
    
    var items: [JournalCardType] {
        guard let journal else { return [] }
        
        return [
            .autoSummary(journal.autoSummary),
            .rate(journal.rate),
            .quote(journal.quote),
            .question(text: journal.question, answer: journal.answer),
            .note(journal.note),
        ]
    }
    
    func updateAnswer(_ newText: String) {
        journal?.answer = newText
    }
    
    func updateNote(_ newText: String) {
        journal?.note = newText
    }
}
