//
//  ChartCell.swift
//  ExameniOS
//
//  Created by Josue Hernandezon 09/11/21.
//

import UIKit
import Charts

class ChartCell: UITableViewCell, ChartViewDelegate {
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var chartView: PieChartView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  
  func setupChart(chartData: [ChartDatum]){
    let legend = chartView.legend
    legend.horizontalAlignment = .center
    legend.verticalAlignment = .bottom
    legend.orientation = .vertical
    legend.xEntrySpace = 0
    legend.yEntrySpace = 0
    legend.yOffset = 0
    
    let pieChart = PieChartView()
    pieChart.chartDescription?.text = ""
    pieChart.legend.enabled = false
    pieChart.holeRadiusPercent = 0.3
    pieChart.translatesAutoresizingMaskIntoConstraints = false
    pieChart.transparentCircleColor = UIColor.clear
    pieChart.usePercentValuesEnabled = true
    pieChart.entryLabelColor = UIColor.black

    var dataEntries = [PieChartDataEntry]()
    for item in chartData {
      let entry = PieChartDataEntry(value: Double(item.percetnage),
                                    label: item.text)
      entry.label = item.text
      entry.value = Double(item.percetnage)
      dataEntries.append(entry)
    }
    let chartData = PieChartData(dataSet: dataSet(dataEntries: dataEntries))
    let defaultValueFormatter = DefaultValueFormatter(formatter: formatter())
    chartData.setValueFormatter(defaultValueFormatter)
    chartData.setValueFont(.systemFont(ofSize: 11, weight: .medium))
    chartView.data = chartData
    chartView.highlightValues(nil)
  }
  
  func dataSet(dataEntries: [PieChartDataEntry]) -> PieChartDataSet {
    let dataSet = PieChartDataSet(entries: dataEntries, label: "")
    dataSet.colors = ChartColorTemplates.material()
    dataSet.sliceSpace = 2
    dataSet.selectionShift = 0
    dataSet.valueTextColor = .black
    return dataSet
  }
  func formatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 0
    formatter.multiplier = 1.0
    formatter.percentSymbol = " %"
    return formatter
  }
  func bindWithQuestion(question: Question) {
    questionLabel.text = question.text
    setupChart(chartData: question.chartData)
  }
    
  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    print(entry)
  }
  
}
