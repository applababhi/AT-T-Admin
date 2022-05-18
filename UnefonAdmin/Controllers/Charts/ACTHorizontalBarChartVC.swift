//
//  ACTHorizontalBarChartVC.swift
//  UnefonAdmin
//
//  Created by Abhishek Visa on 18/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit
import Charts

class ACTHorizontalBarChartVC: UIViewController, ChartViewDelegate {

    @IBOutlet var chartView: HorizontalBarChartView!
    
    var arr_Yaxis:[String] = []
    var arr_forBar:[Int] = []
    var k_Helper_Arr_Number = 0
    var colorBar:UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        chartView.delegate = self
        
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        
        self.chartView.legend.enabled = false
        self.chartView.isUserInteractionEnabled = false
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false

        self.chartView.xAxis.labelCount = arr_Yaxis.count
        self.chartView.xAxis.labelFont = UIFont(name: CustomFont.regular, size: 12)!
        chartView.xAxis.drawAxisLineEnabled = true;
        chartView.xAxis.drawGridLinesEnabled = false;
        
       // chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: arr_Yaxis)
        let formatter = ChartStringFormatter()
        formatter.arrYValues = arr_Yaxis
        chartView.xAxis.valueFormatter = formatter as! AxisValueFormatter
        
        self.chartView.xAxis.labelPosition = .bottom
        self.chartView.xAxis.enabled = true

        chartView.animate(yAxisDuration: 1.1)
        
        chartView.leftAxis.axisMinimum = 0 // this will attach bar with vertical line
        
        setChart(dataPoints: arr_Yaxis, values: arr_forBar)
        
        chartView.extraRightOffset = 30 // it ll help in showing whole value on right side without cut
    }
    
    
    func setChart(dataPoints: [String], values: [Int]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEnt = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEnt)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.valueFont = UIFont(name: CustomFont.semiBold, size: 15)!
        chartDataSet.colors = [colorBar]
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setValueFont(UIFont.systemFont(ofSize: 12.0))
        chartData.setValueFormatter(LargeValueFormatter())

        chartView.data = chartData
        
    }
    
}


class ChartStringFormatter: NSObject, AxisValueFormatter {
    
    var arrYValues: [String]! =  []
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: arrYValues[Int(value)])
    }
}
