
//
//  CollCell_ReportMultipleBarChart.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 7/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit
import Charts

class CollCell_ReportMultipleBarChart: UICollectionViewCell {
  
    @IBOutlet weak var viewBar:BarChartView!
    @IBOutlet weak var lblWeekName:UILabel!
    @IBOutlet weak var lblWeekRange:UILabel!
    
    func setChart(dictEachCell:[String : Any])
    {
        self.viewBar.drawBarShadowEnabled = false
        self.viewBar.drawValueAboveBarEnabled = true
        self.viewBar.chartDescription.enabled = false
        self.viewBar.legend.enabled = false
        
        let  xAxis : XAxis = self.viewBar.xAxis;
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.drawLabelsEnabled = false

        self.viewBar.leftAxis.drawLabelsEnabled = false
        self.viewBar.leftAxis.drawGridLinesEnabled = false
        self.viewBar.leftAxis.drawAxisLineEnabled = false
        
        self.viewBar.rightAxis.drawLabelsEnabled = false
        self.viewBar.rightAxis.drawGridLinesEnabled = false
        self.viewBar.rightAxis.drawAxisLineEnabled = false
        
        self.viewBar.animate(xAxisDuration: 1.3, yAxisDuration: 1.3)

        //Bars Data Structure built for each Cell
        var dict1ToPas: [String : Any] = [:]
        var dict2ToPas: [String : Any] = [:]
                
        if let intCisV:Int = dictEachCell["y1"] as? Int
        {
            dict1ToPas = ["value":intCisV]
        }
        if let intInarV:Int = dictEachCell["y2"] as? Int
        {
            dict2ToPas = ["value":intInarV]
        }

        //Array of the each Bar in a Each Cell
        let dataPoints = [dict1ToPas, dict2ToPas]
        
        var values = [BarChartDataEntry]()
        
        for index in 0..<dataPoints.count
        {
            let xValue = Double(index)
            let yValue = Double(dataPoints[index]["value"] as! Int)
            
            let barChartDataEntry = BarChartDataEntry(x: xValue, y: yValue, data: "" as AnyObject)
            values.append(barChartDataEntry)
        }
        
        let barChartDataSet = BarChartDataSet(entries: values, label: "Unefon")
        barChartDataSet.colors = [UIColor.darkGray, UIColor(named: "customBlue")] as! [NSUIColor]
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.setValueFont(UIFont.systemFont(ofSize: 15.0))
        barChartData.barWidth = Double(0.7) // **default**: 0.85
        self.viewBar.data = barChartData

        // below lines of code, shrink the graph from left and right starting ending point
        let xAxisPadding = 0.45
        viewBar.xAxis.axisMinimum = -xAxisPadding
        viewBar.xAxis.axisMaximum = barChartData.xMax + xAxisPadding
    }
}
