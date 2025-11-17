//
//  GoalsViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 28/10/25.
//

import UIKit

class GoalsViewController: UIViewController {
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var currentSavingLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var targetPaceLabel: UILabel!
    @IBOutlet weak var goalContainerView: UIView!
    
    var selectedMonth = Calendar.current.component(.month, from: Date())
    var selectedYear = Calendar.current.component(.year, from: Date())
    
    lazy var viewModel = GoalsViewModel(selectedMonth: selectedMonth, selectedYear: selectedYear)
    
    private lazy var circularProgressBarView = CircularProgressBarView()
    
    override func viewDidLoad() {
        setupUI()
        setupProgressBar()
        fetchData()
    }
    
    private func setupUI() {
        progressBarView.layer.cornerRadius = 30
        infoContainerView.layer.cornerRadius = 30
        goalContainerView.layer.cornerRadius = 30
        progressBarView.addSubview(circularProgressBarView)
        percentLabel.text = "--%"
        goalLabel.text = "--"
        currentSavingLabel.text = "--"
        circularProgressBarView.setProgress(0.0, animated: false)
    }
    
    private func setupProgressBar() {
        circularProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circularProgressBarView.centerXAnchor.constraint(equalTo: progressBarView.centerXAnchor),
            circularProgressBarView.centerYAnchor.constraint(equalTo: progressBarView.centerYAnchor),
            circularProgressBarView.widthAnchor.constraint(equalTo: progressBarView.widthAnchor, multiplier: 0.8),
            circularProgressBarView.heightAnchor.constraint(equalTo: progressBarView.heightAnchor, multiplier: 0.8)
        ])
    }
    
    private func fetchData() {
        viewModel.fetchGoal { [weak self] result in
            switch result {
            case .success(let goal):
                DispatchQueue.main.async {
                    self?.updateUI(with: goal)
                }
                self?.fetchProgress()
            case .failure(let error):
                print("Goal fetch error:", error.localizedDescription)
            }
        }
    }
    
    private func fetchProgress() {
        viewModel.fetchProgress { [weak self] result in
            switch result {
            case .success(let progressData):
                DispatchQueue.main.async {
                    self?.updateProgressUI(with: progressData)
                }
            case .failure(let error):
                print("Progress fetch error:", error.localizedDescription)
            }
        }
    }
    
    private func updateUI(with goal: Goal) {
        goalLabel.text = goal.amount.formattedWithDot
    }
    
    private func updateProgressUI(with data: ProgressData) {
        let percent = (data.progress * 100).formattedWithDot
        percentLabel.text = "\(percent)%"
        currentSavingLabel.text = data.saving.formattedWithDot
        targetPaceLabel.text = data.targetPace.formattedWithDot
        circularProgressBarView.setProgress(CGFloat(data.progress), animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let editGoalVC = EditGoalViewController()
        editGoalVC.viewModel = viewModel
        editGoalVC.onGoalEditted = { [weak self] updatedGoal in
            self?.updateUI(with: updatedGoal)
            self?.fetchProgress()
        }
        editGoalVC.modalPresentationStyle = .automatic
        present(editGoalVC, animated: true)
    }
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        let monthYearPickerVC = MonthYearPickerViewController()
        
        monthYearPickerVC.onMonthYearChanged = { [weak self] date in
            guard let self = self else { return }
            
            let month = Calendar.current.component(.month, from: date)
            let year = Calendar.current.component(.year, from: date)
            
            self.selectedMonth = month
            self.selectedYear = year
            
            self.viewModel.selectedMonth = month
            self.viewModel.selectedYear = year
            
            self.fetchData()
        }
        monthYearPickerVC.modalPresentationStyle = .overFullScreen
        present(monthYearPickerVC, animated: false)
    }
}

