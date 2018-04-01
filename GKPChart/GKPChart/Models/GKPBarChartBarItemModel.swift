//
//  GKPBarChartBarItemModel.swift
//  GKPChart
//
//  Created by Gokhan on 1.04.2018.
//  Copyright © 2018 Gokhan Alp. All rights reserved.
//

import UIKit

public class GKPBarChartBarItemModel: NSObject {
    private var _value : CGFloat = 0.0
    private var _bodyColor : UIColor?
    
    
    public var value: CGFloat {
        set { self._value = newValue }
        get { return self._value }
    }
    
    public var bodyColor: UIColor? {
        set { self._bodyColor = newValue }
        get { return self._bodyColor }
    }
    
    public override init() {
        super.init()
    }
    
    public init(value: CGFloat, bodyColor: UIColor?) {
        super.init()
        self._value = value
        self._bodyColor = bodyColor
    }
    
}
