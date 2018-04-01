//
//  GKPPieChartValues.swift
//  GKPChart
//
//  Created by Gokhan on 1.04.2018.
//  Copyright © 2018 Gokhan Alp. All rights reserved.
//

import UIKit

public class GKPPieChartValues: NSObject {
  
    private var _value : CGFloat = 0.0
    private var _bodyColor : UIColor?
    private var _startingColor : UIColor?
    private var _endingColor : UIColor?
    
    
    public var value: CGFloat {
        set { self._value = newValue }
        get { return self._value }
    }
    
    public var bodyColor: UIColor? {
        set { self._bodyColor = newValue }
        get { return self._bodyColor }
    }
    
    public var startingColor: UIColor? {
        set { self._startingColor = newValue }
        get { return self._startingColor }
    }
    
    public var endingColor: UIColor? {
        set { self._endingColor = newValue }
        get { return self._endingColor }
    }
}
