//
//  ACTPieChartCollvVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 28/1/20.
//  Copyright © 2020 Shalini Sharma. All rights reserved.
//

import UIKit
import Charts

class ACTPieChartCollvVC: UIViewController {
    
    @IBOutlet weak var viewPIE:PieChartView!

    var arrOfArrayData:[[[String:Any]]] = []
   // var arrData:[[String:Any]] = []
    
  //  var inarDataEntry = PieChartDataEntry(value: 0)
  //  var cisDataEntry = PieChartDataEntry(value: 0)
    
    var arr_PieCharts = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.btnLeftClick(btn: UIButton())
    }
    
    func updatePieChartData(arrData:[[String:Any]]) {
        
        if viewPIE == nil
        {
            return
        }

        viewPIE.clearValues()
        
        viewPIE.drawEntryLabelsEnabled = false // not to show legend label with percentage
        viewPIE.rotationEnabled = true
        viewPIE.holeRadiusPercent = 0.45  // to increase inner circle size
        viewPIE.highlightPerTapEnabled = false // as size is full, so on tap it go out of frame
        viewPIE.setExtraOffsets(left: 100, top: -15, right: -100, bottom: -15) // to increase frame to fit complete view
        viewPIE.legend.enabled = true
        viewPIE.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        viewPIE.backgroundColor = .white
        viewPIE.usePercentValuesEnabled = true
        viewPIE.transparentCircleColor = UIColor.clear
        
        // to set Legend Vertically alligned left bottom
        let l = viewPIE.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .vertical
        l.xEntrySpace = 0
        l.yEntrySpace = 10
        l.font = UIFont(name: CustomFont.regular, size: 16)!
        
        
        var arrColors:[UIColor] = [UIColor(named:"customBlue")!, UIColor.darkGray]
        
        for d in arrData
        {
            let sliceDataEntry = PieChartDataEntry(value: 0)

            if let sales:Int = d["sales"] as? Int
            {
                sliceDataEntry.value = Double(sales)

                if let strLbl:String = d["channel_name"] as? String
                {
                    sliceDataEntry.label = strLbl
                }
            }
            arr_PieCharts.append(sliceDataEntry)
            /*
            if let share:Int = d["share"] as? Int
            {
                
            }
 */
        }
        
        let chartDataSet = PieChartDataSet(entries: arr_PieCharts, label: "")
        
        // to show % and also set offset of Label on slice
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        formatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        chartDataSet.valueTextColor = .black
        chartDataSet.valueFont = .systemFont(ofSize: 16)
        chartDataSet.valueLinePart1OffsetPercentage = 0.8
        chartDataSet.xValuePosition = .outsideSlice
        chartDataSet.yValuePosition = .outsideSlice
        
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.colors = arrColors as! [NSUIColor]
        
        viewPIE.data = chartData
    }
    
    @IBAction func btnLeftClick(btn:UIButton)
    {
        print("Left Click")
        
        if arrOfArrayData.count > 0
        {
            arr_PieCharts = [PieChartDataEntry]()  // To Clear Previous Ploted Chart
            
            updatePieChartData(arrData: arrOfArrayData.first!)
        }
    }
    
    @IBAction func btnRightClick(btn:UIButton)
    {
        print("Right Click")
        
        if arrOfArrayData.count > 0
        {
            arr_PieCharts = [PieChartDataEntry]()  // To Clear Previous Ploted Chart
            
            updatePieChartData(arrData: arrOfArrayData.last!)
        }
    }
}
