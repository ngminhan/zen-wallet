//
//  JournalViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 28/10/25.
//

import UIKit

class JournalViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    let viewModel = JournalViewModel()
    
    var cellHeights: [IndexPath: CGFloat] = [:]
    
    private lazy var sampleQuoteCell: QuoteCollectionViewCell = {
        return QuoteCollectionViewCell.loadFromNib()
    }()
    private lazy var sampleNoteCell: NoteCollectionViewCell = {
        return NoteCollectionViewCell.loadFromNib()
    }()
    private lazy var sampleQuestionCell: QuestionCollectionViewCell = {
        return QuestionCollectionViewCell.loadFromNib()
    }()
    private lazy var sampleSummaryCell: AutoSummaryCollectionViewCell = {
        return AutoSummaryCollectionViewCell.loadFromNib()
    }()
    private lazy var sampleRateCell: RateCollectionViewCell = {
        return RateCollectionViewCell.loadFromNib()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        fetchData()
        NotificationCenter.default.addObserver(self, selector: #selector(handleTransactionUpdate), name: .transactionDidUpdate, object: nil)
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 50
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView.clipsToBounds = true
        
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        
        let layout = JournalLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        
        collectionView.register(QuoteCollectionViewCell.nib, forCellWithReuseIdentifier: QuoteCollectionViewCell.identifier)
        collectionView.register(AutoSummaryCollectionViewCell.nib, forCellWithReuseIdentifier: AutoSummaryCollectionViewCell.identifier)
        collectionView.register(NoteCollectionViewCell.nib, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
        collectionView.register(QuestionCollectionViewCell.nib, forCellWithReuseIdentifier: QuestionCollectionViewCell.identifier)
        collectionView.register(RateCollectionViewCell.nib, forCellWithReuseIdentifier: RateCollectionViewCell.identifier)
    }
    
    func calculateCellHeight(for indexPath: IndexPath) -> CGFloat {
        guard let cv = collectionView else { return 50 }
        let item = viewModel.items[indexPath.item]
        
        let columnWidth = cv.bounds.width / CGFloat(JournalLayout().numberOfColumns)
        let cellWidth = columnWidth - (JournalLayout().cellPadding * 2)
        
        let cell: UICollectionViewCell
        
        switch item {
        case .quote(let text):
            sampleQuoteCell.configData(text: text)
            cell = sampleQuoteCell
        case .note(let text):
            sampleNoteCell.configData(note: text)
            cell = sampleNoteCell
        case .question(let question, let answer):
            sampleQuestionCell.configData(question: question, answer: answer)
            cell = sampleQuestionCell
        case .autoSummary(let text):
            sampleSummaryCell.configData(summary: text)
            cell = sampleSummaryCell
        case .rate:
            cell = sampleRateCell
        }
        
        let targetSize = CGSize(width: cellWidth, height: UIView.layoutFittingCompressedSize.height)
        let size = cell.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size.height
    }
    
    
    func fetchData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: viewModel.selectedDate)
        
        viewModel.fetchJournal(for: dateString) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    @objc func handleTransactionUpdate() {
        self.fetchData()
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        guard let datePicker = sender as? UIDatePicker else { return }
        let selectedDate = datePicker.date
        let selectedDateOnly = Calendar.current.startOfDay(for: selectedDate)
        
        self.viewModel.selectedDate = selectedDateOnly
        self.fetchData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            
            cell.onHeightChange = { [weak self] in
                guard let self else { return }
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.performBatchUpdates(nil)
            }
            
            return cell
            
        case .note(let noteText):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteCollectionViewCell.identifier,
                for: indexPath
            ) as! NoteCollectionViewCell
            cell.configData(note: noteText)
            
            cell.onNoteChanged = { [weak self] newText in
                self?.viewModel.updateNote(newText ?? "")
            }
            
            cell.onHeightChange = { [weak self] in
                guard let self else { return }
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.performBatchUpdates(nil)
            }
            
            return cell
        }
    }
}

extension JournalViewController: JournalLayoutDelegate {
    
    func journalItemType(at indexPath: IndexPath) -> JournalCardType {
        return viewModel.items[indexPath.item]
    }
    
    func journalContentHeight(at indexPath: IndexPath) -> CGFloat {
        let calculatedHeight = calculateCellHeight(for: indexPath)
        return calculatedHeight + (JournalLayout().cellPadding * 2)
    }
}
