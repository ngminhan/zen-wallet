//
//  JournalViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 28/10/25.
//

import UIKit

class JournalViewController: UIViewController {
    
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = JournalViewModel()
    
    var cellHeights: [IndexPath: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchData()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        //        collectionView.collectionViewLayout = JournalLayout()
        collectionView.register(QuoteCollectionViewCell.nib, forCellWithReuseIdentifier: QuoteCollectionViewCell.identifier)
        collectionView.register(AutoSummaryCollectionViewCell.nib, forCellWithReuseIdentifier: AutoSummaryCollectionViewCell.identifier)
        collectionView.register(NoteCollectionViewCell.nib, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
        collectionView.register(QuestionCollectionViewCell.nib, forCellWithReuseIdentifier: QuestionCollectionViewCell.identifier)
        collectionView.register(RateCollectionViewCell.nib, forCellWithReuseIdentifier: RateCollectionViewCell.identifier)
    }
    
    func fetchData() {
        viewModel.fetchJournal(for: "2025-11-15") {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        let monthYearPickerVC = MonthYearPickerViewController()
        
        monthYearPickerVC.onMonthYearChanged = { [weak self] date in
            guard let self = self else { return }
            
            let month = Calendar.current.component(.month, from: date)
            let year = Calendar.current.component(.year, from: date)
            
            self.viewModel.selectedMonth = month
            self.viewModel.selectedYear = year
            
            //            self.reloadAll()
        }
        monthYearPickerVC.modalPresentationStyle = .overFullScreen
        present(monthYearPickerVC, animated: false)
    }
}

extension JournalViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = viewModel.items[indexPath.item]
        
        switch item {
            
        case .quote(let quote):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: QuoteCollectionViewCell.identifier,
                for: indexPath
            ) as! QuoteCollectionViewCell
            cell.configData(text: quote)
            return cell
            
        case .autoSummary(let summary):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AutoSummaryCollectionViewCell.identifier,
                for: indexPath
            ) as! AutoSummaryCollectionViewCell
            cell.configData(summary: summary)
            return cell
            
        case .rate(let value):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RateCollectionViewCell.identifier,
                for: indexPath
            ) as! RateCollectionViewCell
            cell.configData(rate: value)
            return cell
            
        case .question(let question, let answer):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: QuestionCollectionViewCell.identifier,
                for: indexPath
            ) as! QuestionCollectionViewCell
            
            cell.configData(question: question, answer: answer)
            
            cell.onAnswerChanged = { [weak self] newText in
                self?.viewModel.updateAnswer(newText)
            }
            return cell
            
        case .note(let noteText):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteCollectionViewCell.identifier,
                for: indexPath
            ) as! NoteCollectionViewCell
            cell.configData(note: noteText)
            return cell
        }
    }
}

extension JournalViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 32
        let item = viewModel.items[indexPath.item]
        
        switch item {
        case .quote:
            return CGSize(width: width, height: 120)
        case .autoSummary:
            return CGSize(width: width, height: 140)
        case .rate:
            return CGSize(width: width, height: 150)
        case .question:
            return CGSize(width: width, height: 180)
        case .note:
            return CGSize(width: width, height: 180)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        // Tương lai nếu cần click card
    }
}
