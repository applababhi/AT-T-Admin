//
//  ACTCombineChart2VC.swift
//  UnefonAdmin
//
//  Created by Abhishek Visa on 18/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit
import Charts

class ACTCombineChart2VC: UIViewController, ChartViewDelegate {
    
    @IBOutlet var chartView: CombinedChartView!
    
    var arr_Xaxis:[String] = []
    var arr_forBar:[Int] = []
    var arr_forLine:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.delegate = self
        
        chartView.initialize()
        
        chartView.chartDescription.enabled = false
        
        chartView.drawBarShadowEnabled = false
        chartView.highlightFullBarEnabled = false
        
        chartView.drawOrder = [DrawOrder.line.rawValue, DrawOrder.bar.rawValue]
        
        chartView.legend.enabled = false
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false // disable lines
        
        //        chartView.extraBottomOffset = 8 // chart was cutting, initially, so set its offset to fit in frame
        chartView.animate(xAxisDuration: 1, yAxisDuration: 1.6, easingOption: .easeInCubic)
        
        // set xaxis labels
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.granularityEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.labelTextColor = UIColor.black
        xAxis.wordWrapEnabled = true
        xAxis.labelFont = UIFont(name: CustomFont.regular, size: 13.0)!
        // below 2 lines will print xaxis string
        xAxis.setLabelCount(arr_Xaxis.count, force: false)
        xAxis.valueFormatter = IndexAxisValueFormatter(values: arr_Xaxis)

        
        chartView.rightAxis.axisMinimum = 0 // to bring bar chart bottom alligned to xaxis
        
        self.setChartData()
    }
    
    func setChartData()
    {
        var yValsBar = [BarChartDataEntry]()
        var yValsLine = [ChartDataEntry]()
        
        for i in 0..<arr_Xaxis.count
        {
            yValsBar.append(BarChartDataEntry(x: Double(i), y: Double(arr_forBar[i])))
            yValsLine.append(ChartDataEntry(x: Double(i), y: Double(arr_forLine[i])))
        }
        
        let barDataSet = BarChartDataSet(entries: yValsBar, label: "")
        barDataSet.setColor(UIColor(named: "customBlue")!)
        barDataSet.drawValuesEnabled = true
        barDataSet.axisDependency = .right // to bring bar chart bottom alligned to xaxis
        let barChartData = BarChartData()
//        barChartData.addDataSet(barDataSet)
        barChartData.dataSets = [barDataSet]
        
//        // below lines of code hide decimal from top label yaxis, bar chart
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .none
//        formatter.maximumFractionDigits = 0
//        formatter.multiplier = 1.0
//        barChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
  
        barChartData.setValueFont(UIFont.systemFont(ofSize: 12.0))
        barChartData.setValueFormatter(LargeValueFormatter())

        // set line graph properties
        let lineDataSet = LineChartDataSet(entries: yValsLine, label: "")
        lineDataSet.drawValuesEnabled = false
        lineDataSet.lineWidth = 0.3
        lineDataSet.drawFilledEnabled = true // to show area
        lineDataSet.fillAlpha = 1
        lineDataSet.setColor(UIColor.black)  // line color
        lineDataSet.setCircleColor(UIColor.clear)
        lineDataSet.circleRadius = 0  // to hide points as circle on line, we set it to zero
        lineDataSet.circleHoleRadius = 0
        lineDataSet.fillColor = UIColor.lightGray
        lineDataSet.mode = .horizontalBezier
        
        let lineChartData = LineChartData()
//        lineChartData.addDataSet(lineDataSet)
        lineChartData.dataSets = [lineDataSet]
        
        let combinedChartData = CombinedChartData()
        
        combinedChartData.lineData = lineChartData
        combinedChartData.barData = barChartData
        combinedChartData.setValueFont(UIFont(name: CustomFont.regular, size: 15)!)
        
        // below lines of code, shrink the graph from left and right starting ending point
        let xAxisPadding = 0.45
        chartView.xAxis.axisMinimum = -xAxisPadding
        chartView.xAxis.axisMaximum = combinedChartData.xMax + xAxisPadding
        
        chartView.data = combinedChartData;
        
        chartView.setVisibleXRangeMaximum(3)  // to show just 3 bars at a time
    }
    
}
