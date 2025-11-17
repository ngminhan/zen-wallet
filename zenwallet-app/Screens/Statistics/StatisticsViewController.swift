//
//  StatisticsViewController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 28/10/25.
//

import UIKit
import SwiftUI

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var lineChartContainer: UIView!
    @IBOutlet weak var barChartContainer: UIView!
    @IBOutlet weak var overViewSegment: UISegmentedControl!
    
    private let viewModel = StatisticsViewModel()
    
    private var selectedChartType: ChartType = .income
    
    private var lineHost: UIHostingController<FinancialOverviewChart>?
    private var barHost: UIHostingController<SpendingBreakdownChart>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCharts()
        setupUI()
        reloadAll()
    }
    
    private func setupUI() {
        let normalFont = UIFont(name: "Futura", size: 10)!
        let selectedFont = UIFont(name: "Futura", size: 10)!
        overViewSegment.setTitleTextAttributes([.font: normalFont, .foregroundColor: UIColor.gray], for: .normal)
        overViewSegment.setTitleTextAttributes([.font: selectedFont, .foregroundColor: UIColor.greenSheen], for: .selected)
    }
    
    private func setupCharts() {
        let l = FinancialOverviewChart(data: [], selectedType: selectedChartType)
        let lh = UIHostingController(rootView: l)
        addChild(lh)
        lineChartContainer.addSubview(lh.view)
        lh.view.frame = lineChartContainer.bounds
        lh.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lh.view.backgroundColor = .clear
        lh.didMove(toParent: self)
        lineHost = lh
        
        let b = SpendingBreakdownChart(data: [])
        let bh = UIHostingController(rootView: b)
        addChild(bh)
        barChartContainer.addSubview(bh.view)
        bh.view.frame = barChartContainer.bounds
        bh.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bh.view.backgroundColor = .clear
        bh.didMove(toParent: self)
        barHost = bh
    }
    
    private func reloadChart() {
        let newChart = FinancialOverviewChart(
            data: viewModel.overviewItems,
            selectedType: selectedChartType
        )
        lineHost?.rootView = newChart
    }
    
    private func reloadAll() {
        viewModel.fetchOverview { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.lineHost?.rootView = FinancialOverviewChart(
                    data: self.viewModel.overviewItems,
                    selectedType: self.selectedChartType
                )
                
                self.reloadChart()
            }
        }
        
        viewModel.fetchCategory { [weak self] in
            DispatchQueue.main.async {
                self?.barHost?.rootView = SpendingBreakdownChart(data: self?.viewModel.categoryItems ?? [])
            }
        }
    }
    
    @IBAction func chartTypeSegmentChanged(_ sender: Any) {
        var newType: ChartType
        switch overViewSegment.selectedSegmentIndex {
        case 0:
            newType = .income
        case 1:
            newType = .expense
        case 2:
            newType = .balance
        default:
            newType = .income
        }
        selectedChartType = newType
        reloadChart()
    }
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        let monthYearPickerVC = MonthYearPickerViewController()
        
        monthYearPickerVC.onMonthYearChanged = { [weak self] date in
            guard let self = self else { return }
            
            let month = Calendar.current.component(.month, from: date)
            let year = Calendar.current.component(.year, from: date)
            
            self.viewModel.selectedMonth = month
            self.viewModel.selectedYear = year
            
            self.reloadAll()
        }
        monthYearPickerVC.modalPresentationStyle = .overFullScreen
        present(monthYearPickerVC, animated: false)
    }
}
