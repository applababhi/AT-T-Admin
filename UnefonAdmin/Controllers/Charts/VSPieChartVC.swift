//
//  VSPieChartVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 11/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit
import Charts

class VSPieChartVC: UIViewController {
    
    @IBOutlet weak var viewPIE:PieChartView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblInarValue:UILabel!
    @IBOutlet weak var lblCisValue:UILabel!
    @IBOutlet weak var btnOverlayRight_iPhone:UIButton!
    @IBOutlet weak var btnRight:UIButton!
    @IBOutlet weak var btnLeft:UIButton!
    
    @IBOutlet weak var c_lblTitle_Ld:NSLayoutConstraint!
    @IBOutlet weak var c_chart_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_chart_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_chart_Tr:NSLayoutConstraint!
    @IBOutlet weak var c_lInar_Tp:NSLayoutConstraint!
    
    var str_innerHolePercentage = ""
    var value_Inar = 0.0
    var value_Cis = 0.0
//    var value_3rd = 0.0
    
    var str_innerHolePercentage_Act = ""
    var str_InarDisplay_Act = ""
    var str_CisDisplay_Act = ""
    var value_Inar_Act = 0.0
    var value_Cis_Act = 0.0
    
    var str_innerHolePercentage_Kpi = ""
    var str_InarDisplay_Kpi = ""
    var str_CisDisplay_Kpi = ""
    var value_Inar_Kpi = 0.0
    var value_Cis_Kpi = 0.0
    
    var str_innerHolePercentage_3rd = ""
    var str_InarDisplay_3rd = ""
    var str_CisDisplay_3rd = ""
    var value_Inar_3rd = 0.0
    var value_Cis_3rd = 0.0
    
    var inarDataEntry = PieChartDataEntry(value: 0)
    var cisDataEntry = PieChartDataEntry(value: 0)
//    var thirdDataEntry = PieChartDataEntry(value: 0)
    
    var arr_PieCharts = [PieChartDataEntry]()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPad
        {
            btnOverlayRight_iPhone.isHidden = true
            lblTitle.font = UIFont(name: CustomFont.semiBold, size: 18)
            lblInarValue.font = UIFont(name: CustomFont.semiBold, size: 18)
            lblCisValue.font = UIFont(name: CustomFont.semiBold, size: 19)
            
            c_chart_Wd.constant = 186
            c_chart_Ht.constant = 186
            c_chart_Tr.constant = 35
        }
        else
        {
            btnOverlayRight_iPhone.isHidden = false
            lblTitle.font = UIFont(name: CustomFont.semiBold, size: 13)
            lblInarValue.font = UIFont(name: CustomFont.semiBold, size: 14)
            lblCisValue.font = UIFont(name: CustomFont.semiBold, size: 14)
            c_lblTitle_Ld.constant = 5
            c_chart_Wd.constant = 80
            c_chart_Ht.constant = 80
            c_chart_Tr.constant = 5
            c_lInar_Tp.constant = 35
        }
        
        btnOverlayRight_iPhone.isHidden = true
   //     btnRight.isHidden = true
   //     btnLeft.isHidden = true
        
        btnLeftClick(btn: UIButton())
    }
    
    func updatePieChartData() {
        
        viewPIE.rotationEnabled = true
        viewPIE.holeRadiusPercent = 0.61  // to increase inner circle size
        viewPIE.highlightPerTapEnabled = false // as size is full, so on tap it go out of frame
        viewPIE.setExtraOffsets(left: -15, top: -15, right: -15, bottom: -15) // to increase frame to fit complete view
        viewPIE.legend.enabled = false
        viewPIE.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        viewPIE.backgroundColor = .white
        
        var attrString: NSMutableAttributedString?
        attrString = NSMutableAttributedString(string: str_innerHolePercentage)
        
        if isPad
        {
            attrString?.setAttributes([
                NSAttributedString.Key.foregroundColor: UIColor(named: "customBlue")!,
                NSAttributedString.Key.font: UIFont(name: CustomFont.semiBold, size: 22)!
                ], range: NSMakeRange(0, attrString!.length))
        }
        else
        {
            attrString?.setAttributes([
                NSAttributedString.Key.foregroundColor: UIColor(named: "customBlue")!,
                NSAttributedString.Key.font: UIFont(name: CustomFont.semiBold, size: 12)!
                ], range: NSMakeRange(0, attrString!.length))
        }
        
        viewPIE.centerAttributedText =  attrString
        
        inarDataEntry.value = value_Inar
        cisDataEntry.value = value_Cis
       // thirdDataEntry.value = value_3rd
        
        arr_PieCharts = [inarDataEntry, cisDataEntry]
        
        let chartDataSet = PieChartDataSet(entries: arr_PieCharts, label: "")
        chartDataSet.drawValuesEnabled = false // to hide labels on each slice
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(named:"customBlue"), UIColor.darkGray]
        chartDataSet.colors = colors as! [NSUIColor]
        
        viewPIE.data = chartData
    }
    
    override func viewDidLayoutSubviews() {
        if isPad
        {
            if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
            {
                c_lblTitle_Ld.constant = 35
            }
            else
            {
                // landscape
                c_lblTitle_Ld.constant = 5
            }
        }
    }
    
    @IBAction func btnLeftClick(btn:UIButton)
    {
        currentIndex = currentIndex - 1
        
        if isPad
        {
            lblTitle.font = UIFont(name: CustomFont.semiBold, size: 18)
        }
        else
        {
            lblTitle.font = UIFont(name: CustomFont.semiBold, size: 13)
        }
        
        if currentIndex <= 0
        {
            currentIndex = 0
            lblTitle.text = "Activaciones Unefon"
            lblInarValue.text = str_InarDisplay_Act
            lblCisValue.text = str_CisDisplay_Act
            
            str_innerHolePercentage = str_innerHolePercentage_Act
            
            print(value_Inar_Act)
            print(value_Cis_Act)
            
            value_Inar = value_Inar_Act
            value_Cis = value_Cis_Act
            
            updatePieChartData()
        }
        else if currentIndex == 1
        {
            lblTitle.text = "Activaciones AT&T"
            lblInarValue.text = str_InarDisplay_Kpi
            lblCisValue.text = str_CisDisplay_Kpi
            
            str_innerHolePercentage = str_innerHolePercentage_Kpi
            value_Inar = value_Inar_Kpi
            value_Cis = value_Cis_Kpi
            
            updatePieChartData()
        }
    }
    
    @IBAction func btnRightClick(btn:UIButton)
    {
        currentIndex = currentIndex + 1
        
        if isPad
        {
            lblTitle.font = UIFont(name: CustomFont.semiBold, size: 18)
        }
        else
        {
            lblTitle.font = UIFont(name: CustomFont.semiBold, size: 13)
        }
        
        if currentIndex >= 2
        {
            currentIndex = 2
            lblTitle.text = "Activaciones PREPAGO"
            
            if isPad
            {
                lblTitle.font = UIFont(name: CustomFont.semiBold, size: 16)
            }
            else
            {
                lblTitle.font = UIFont(name: CustomFont.semiBold, size: 12)
            }
            
            lblInarValue.text = str_InarDisplay_3rd
            lblCisValue.text = str_CisDisplay_3rd
            
            str_innerHolePercentage = str_innerHolePercentage_3rd
            value_Inar = value_Inar_3rd
            value_Cis = value_Cis_3rd
            
            updatePieChartData()
        }
        else if currentIndex == 1
        {
            lblTitle.text = "Activaciones AT&T"
            lblInarValue.text = str_InarDisplay_Kpi
            lblCisValue.text = str_CisDisplay_Kpi
            
            str_innerHolePercentage = str_innerHolePercentage_Kpi
            value_Inar = value_Inar_Kpi
            value_Cis = value_Cis_Kpi
            
            updatePieChartData()
        }
    }
}
