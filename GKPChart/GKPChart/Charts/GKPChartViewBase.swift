//
//  GKPChartViewBase.swift
//  GKPChart
//
//  Created by Gokhan on 1.04.2018.
//  Copyright © 2018 Gokhan Alp. All rights reserved.
//

import UIKit

public class GKPChartViewBase: UIView {
    
    public var chartView : UIView!
    
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        
        chartView = UIView()
        self.chartView.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        self.addSubview(chartView)
        
        self.chartView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.chartView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.chartView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leftConstraint = NSLayoutConstraint(item: self.chartView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: self.chartView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([topConstraint,leftConstraint, bottomConstraint, rightConstraint] )
    }
    
}
