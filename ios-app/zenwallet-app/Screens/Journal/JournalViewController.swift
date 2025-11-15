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
        // Giả định bạn có một helper extension để load NIB
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
        
        // 3. Chiều rộng Cell (đã trừ padding 2 bên)
        let columnWidth = cv.bounds.width / CGFloat(JournalLayout().numberOfColumns)
        let cellWidth = columnWidth - (JournalLayout().cellPadding * 2)
        
        let cell: UICollectionViewCell
        
        // 4. Chọn Cell mẫu và Config data
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
        
        // 5. Tính chiều cao bằng Auto Layout
        let targetSize = CGSize(width: cellWidth, height: UIView.layoutFittingCompressedSize.height)
        let size = cell.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required, // Chiều rộng cố định
            verticalFittingPriority: .fittingSizeLevel // Để Auto Layout tính chiều cao
        )
        
        // 6. Trả về chiều cao đã tính
        return size.height
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
            // Cộng thêm JournalLayout().cellPadding * 2 cho padding trên dưới nếu cần
            // Nếu size.height đã bao gồm hết nội dung, thì chỉ cần size.height
            let calculatedHeight = calculateCellHeight(for: indexPath)
            // Cộng padding trên và dưới của cell: 4*2 = 8
            return calculatedHeight + (JournalLayout().cellPadding * 2)
        }
}
