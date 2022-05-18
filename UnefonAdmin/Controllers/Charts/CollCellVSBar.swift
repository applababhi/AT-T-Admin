//
//  CollCellVSBar.swift
//  UnefonAdmin
//
//  Created by Abhishek Visa on 12/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit
import Charts

class CollCellVSBar: UICollectionViewCell {
    @IBOutlet weak var viewBar:BarChartView!
    @IBOutlet weak var lblWeekName:UILabel!
    @IBOutlet weak var lblWeekRange:UILabel!
    
    func showBarChart(dictEachCell:[String : Any])
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
        var dict3ToPas: [String : Any] = [:]
        var dict4ToPas: [String : Any] = [:]

        // Create 4 Bars
        
        if let doubleCisV:Double = dictEachCell["unefon_inar_sales_counter"] as? Double
        {
             dict1ToPas = ["value":doubleCisV]
        }
        if let doubleInarV:Double = dictEachCell["att_inar_sales_counter"] as? Double
        {
            dict2ToPas = ["value":doubleInarV]
        }
        if let doubleCisV:Double = dictEachCell["general_inar_sales_counter"] as? Double
        {
             dict3ToPas = ["value":doubleCisV]
        }
        if let doubleInarV:Double = dictEachCell["general_inar_kpi"] as? Double
        {
            dict4ToPas = ["value":doubleInarV]
        }
        
        if let intCisV:Int = dictEachCell["unefon_inar_sales_counter"] as? Int
        {
            dict1ToPas = ["value":intCisV]
        }
        if let intInarV:Int = dictEachCell["att_inar_sales_counter"] as? Int
        {
            dict2ToPas = ["value":intInarV]
        }
        if let intCisV:Int = dictEachCell["general_inar_sales_counter"] as? Int
        {
            dict3ToPas = ["value":intCisV]
        }
        if let intInarV:Int = dictEachCell["general_inar_kpi"] as? Int
        {
            dict4ToPas = ["value":intInarV]
        }
        
        //Array of the each Bar in a Each Cell
        let dataPoints = [dict1ToPas, dict2ToPas, dict3ToPas, dict4ToPas]
        
        var values = [BarChartDataEntry]()
        
        for index in 0..<dataPoints.count
        {
            let xValue = Double(index)
            let yValue = Double(dataPoints[index]["value"] as! Int)
            
            let barChartDataEntry = BarChartDataEntry(x: xValue, y: yValue, data: "" as AnyObject)
            values.append(barChartDataEntry)
        }
        
        let barChartDataSet = BarChartDataSet(entries: values, label: "ATNT")
        barChartDataSet.colors = [UIColor(named: "Yellow"), UIColor(named: "customBlue"), UIColor(named: "Gray Base"), UIColor.darkGray] as! [NSUIColor]
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.setValueFont(UIFont.systemFont(ofSize: 12.0))
        barChartData.setValueFormatter(LargeValueFormatter()) // This ll do MAGIC, convert the big Int value to 10k, 10m....
        barChartData.barWidth = Double(0.7) // **default**: 0.85
        self.viewBar.data = barChartData
    }
}
