//
//  GKPBarChartValues.swift
//  GKPChart
//
//  Created by Gokhan on 1.04.2018.
//  Copyright © 2018 Gokhan Alp. All rights reserved.
//

import UIKit

public class GKPBarChartValues: NSObject {
    private var _columnGroup : [GKPBarChartColumnGroup] = []
    
    public var columnGroup: [GKPBarChartColumnGroup] {
        set { self._columnGroup = newValue }
        get { return self._columnGroup }
    }

}
