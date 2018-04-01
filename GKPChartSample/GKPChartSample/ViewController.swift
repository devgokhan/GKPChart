//
//  ViewController.swift
//  GKPChartSample
//
//  Created by Gokhan on 1.04.2018.
//  Copyright © 2018 Gokhan Alp. All rights reserved.
//

import UIKit
import GKPChart

class ViewController: UIViewController {

   
    @IBOutlet weak var chartView: GKPPieChartView!
    @IBOutlet weak var barChartView: GKPBarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        var pieChartValues = [GKPPieChartValues]()
        
        let value1 = GKPPieChartValues()
        value1.value = 30.0
        value1.bodyColor = UIColor.purple
        pieChartValues.append(value1)
        
        let value2 = GKPPieChartValues()
        value2.value = 65.0
        value2.bodyColor = UIColor.blue
        pieChartValues.append(value2)
        
        let value3 = GKPPieChartValues()
        value3.value = 25.0
        value3.bodyColor = UIColor.green
        pieChartValues.append(value3)
        
        let value4 = GKPPieChartValues()
        value4.value = 42.0
        value4.bodyColor = UIColor.cyan
        pieChartValues.append(value4)
        
        
        chartView.setPieChartValues(pieChartValues: pieChartValues)
        chartView.setChartType(isHoledPie: true, pieChartMaxDegree: 360.0)
        chartView.setAnimation(animationDuration: 5.0)
        chartView.setChartSizes(chartBodyRadius: nil, chartBodyWidth: nil, distanceDegreeBetweenItems: 1.0, startingCornerWidth: nil, endingCornerWidth: nil)
        chartView.drawPieChart()
        
        
        let barChartValues = GKPBarChartValues()
        var columnGroup = [GKPBarChartColumnGroup]()
        
        
        // -- COLUMN GROUP 1
        let columnGroup1Item = GKPBarChartColumnGroup()
        columnGroup.append(columnGroup1Item)
        
        var columnsForColumnGroup1 = [GKPBarChartColumn]()
        
        
        // COLUMN 1
        let column1ColumnGroup1 = GKPBarChartColumn()
        var rowsForColumn1OfColumnGroup1 = [GKPBarChartBarItemModel]()
        
        let row1Column1OfColumnGroup1 = GKPBarChartBarItemModel()
        row1Column1OfColumnGroup1.value = 30.0
        row1Column1OfColumnGroup1.bodyColor = UIColor.red
        rowsForColumn1OfColumnGroup1.append(row1Column1OfColumnGroup1)
        
        let row2Column1OfColumnGroup1 = GKPBarChartBarItemModel()
        row2Column1OfColumnGroup1.value = 40.0
        row2Column1OfColumnGroup1.bodyColor = UIColor.orange
        rowsForColumn1OfColumnGroup1.append(row2Column1OfColumnGroup1)
        
        column1ColumnGroup1.rowItems = rowsForColumn1OfColumnGroup1
        columnsForColumnGroup1.append(column1ColumnGroup1)
        
        // COLUMN 2
        let column2ColumnGroup1 = GKPBarChartColumn()
        var rowsForColumn2OfColumnGroup1 = [GKPBarChartBarItemModel]()
        let row1Column2OfColumnGroup1 = GKPBarChartBarItemModel()
        row1Column2OfColumnGroup1.value = 35.0
        row1Column2OfColumnGroup1.bodyColor = UIColor.blue
        rowsForColumn2OfColumnGroup1.append(row1Column2OfColumnGroup1)
        
        column2ColumnGroup1.rowItems = rowsForColumn2OfColumnGroup1
        columnsForColumnGroup1.append(column2ColumnGroup1)
        
        // COLUMN 3
        let column3ForColumnGroup1 = GKPBarChartColumn()
        var rowsForColumn3OfColumnGroup1 = [GKPBarChartBarItemModel]()
        let row1Column3OfColumnGroup1 = GKPBarChartBarItemModel()
        row1Column3OfColumnGroup1.value = 60.0
        row1Column3OfColumnGroup1.bodyColor = UIColor.green
        rowsForColumn3OfColumnGroup1.append(row1Column3OfColumnGroup1)
        
        column3ForColumnGroup1.rowItems = rowsForColumn3OfColumnGroup1
        columnsForColumnGroup1.append(column3ForColumnGroup1)
        // -- COLUMN GROUP 1
        
        // SETTING COLUMN ITEMS AND GROUP
        columnGroup1Item.columnItems = columnsForColumnGroup1
        
        // NEW GROUPS
        columnGroup.append(GKPBarChartColumnGroup( columnItems: [GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 13.0, bodyColor: UIColor.cyan), GKPBarChartBarItemModel(value: 13.0, bodyColor: UIColor.purple)]) ]) )
        columnGroup.append(GKPBarChartColumnGroup( columnItems: [GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 22.0, bodyColor: UIColor.green)]) ]) )
        columnGroup.append(GKPBarChartColumnGroup( columnItems: [GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 18.0, bodyColor: UIColor.blue)]), GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 32.0, bodyColor: UIColor.red)]) ]  ) )
        columnGroup.append(GKPBarChartColumnGroup( columnItems: [GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 28.0, bodyColor: UIColor.orange)]) ]) )
        
        columnGroup.append(GKPBarChartColumnGroup( columnItems: [GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 18.0, bodyColor: UIColor.blue)]),
                                                              GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 70.0, bodyColor: UIColor.red)]),
                                                              GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 55.0, bodyColor: UIColor.green)]),
                                                              GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 43.0, bodyColor: UIColor.orange)]),
                                                              GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 29.0, bodyColor: UIColor.purple)]),
                                                              GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 60.0, bodyColor: UIColor.cyan)]),
                                                              GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 55.0, bodyColor: UIColor.black)]),
                                                              GKPBarChartColumn(rowItems: [GKPBarChartBarItemModel(value: 42.0, bodyColor: UIColor.magenta)])
            ]))
        
        
        barChartValues.columnGroup = columnGroup
        
        barChartView.setBarChartValues(barChartValues: barChartValues)
        barChartView.setAnimation(animationDuration: 5.0)
        barChartView.drawBarChart()
        
    }
}

