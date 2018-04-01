//
//  GKPBarChartView.swift
//  GKPChart
//
//  Created by Gokhan on 1.04.2018.
//  Copyright © 2018 Gokhan Alp. All rights reserved.
//

import UIKit

public class GKPBarChartView: GKPChartViewBase {
    
    private var barChartValues = GKPBarChartValues()
    private var columnWidthMarginRatio : CGFloat = 0.90//0.90
    private var columnGroupMargin : CGFloat = 5.0//1.0
    private var chartXLeftRightMargin : CGFloat = 10.0//1.0
    private var chartTopMargin : CGFloat = 20.0
    private var chartBottomMargin : CGFloat = 0.0
    private var animationDuration : CGFloat = 0.0
    
    private var chartShapeLayers = [CAShapeLayer]()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setBarChartValues(barChartValues: GKPBarChartValues)
    {
        self.barChartValues = barChartValues
    }
    
    public func setAnimation(animationDuration: CGFloat)
    {
        self.animationDuration = animationDuration
    }
    
    public func drawBarChart()
    {
        //columnXMargin = super.chartView.frame.width * 0.10
        print ("chartView Frame Width:", super.chartView.frame.width)
        let columnGroupCount = self.barChartValues.columnGroup.count
        let columnGroupWidth = (super.chartView.frame.width - chartXLeftRightMargin*2) / CGFloat.init(columnGroupCount)
        let rowMaxHeight = super.chartView.frame.height - chartTopMargin  - chartBottomMargin
        let rowMaxValue =  barChartValues.columnGroup.map{ $0.columnItems.map{$0.rowItems.map{$0.value}.reduce(0, +)}.max()! }.max()!
        
        var firstColumnGroupFactor : CGFloat = 0.0
        
        var columnGroupIndex = -1
        
        print("rowMaxValue: ", rowMaxValue)
        print("columnGroupCount: ", columnGroupCount)
        
        print("ColumnGroupWidth: ", columnGroupWidth)
        
        chartShapeLayers.removeAll()
        
        if(columnGroupCount > 0)
        {
            for var columnGroup in self.barChartValues.columnGroup
            {
                columnGroupIndex += 1
                let columnCount = columnGroup.columnItems.count
                //let columnWidth = (columnGroupWidth * columnWidthMarginRatio - columnGroupMargin*2) / CGFloat.init(columnCount)
                print("ColumnCount(group:",columnGroupIndex ,"): ", columnCount)
                
                let columnWidthRatioDiff = ((1.0 - columnWidthMarginRatio))/2
                
                let columnGroupBeginX = (CGFloat.init(columnGroupIndex) * columnGroupWidth)
                let columnGroupEndX = columnGroupBeginX + columnGroupWidth
                //let columnGroupContentBeginX = columnGroupBeginX + (columnGroupBeginX * columnWidthRatioDiff)
                //let columnGroupContentEndX = columnGroupEndX - (columnGroupEndX * columnWidthRatioDiff)
                let columnGroupContentBeginX = columnGroupBeginX + columnGroupMargin
                let columnGroupContentEndX = columnGroupEndX - columnGroupMargin
                
                let columnWidth = (columnGroupContentEndX - columnGroupContentBeginX) / CGFloat.init(columnCount)
                print("ColumnWidth(group:",columnGroupIndex ,"): ", columnWidth)
                
                print("column Group BeginX(group:",columnGroupIndex ,"): ", columnGroupBeginX, " columnGroupEndX:", columnGroupEndX)
                print("column Group Content BeginX(group:",columnGroupIndex ,"): ", columnGroupContentBeginX, " columnGroupContentEndX:", columnGroupContentEndX )
                
                if(columnCount > 0)
                {
                    var columnIndex : Int = -1
                    for var column in columnGroup.columnItems
                    {
                        columnIndex += 1
                        let rowCount = column.rowItems.count
                        var latestRowYPosition : CGFloat = 0.0
                        for i : Int in 0 ..< rowCount
                        {
                            let row = column.rowItems[i]
                            let rowYBegin = latestRowYPosition
                            let rowYHeight = (row.value * rowMaxHeight) / rowMaxValue
                            let rowYEnd = rowYBegin + rowYHeight
                            latestRowYPosition = rowYEnd
                            //let rowXBegin = (CGFloat.init(columnGroupIndex) * columnWidth) + (CGFloat.init(columnIndex) * (columnWidth + columnWidth/CGFloat.init(columnCount) )) + chartXLeftRightMargin + (CGFloat.init(columnGroupIndex)*columnGroupMargin)
                            let rowXBegin = columnGroupContentBeginX + (CGFloat.init(columnIndex) * columnWidth ) + columnWidth*columnWidthRatioDiff + chartXLeftRightMargin  // - columnWidth*columnWidthRatioDiff
                            let rowXWidth = columnWidth - columnWidth*columnWidthRatioDiff///CGFloat.init(columnCount)
                            //--let rowXWidth = columnGroupContentEndX/CGFloat.init(columnCount)
                            //*let rowXEnd = rowXBegin + rowXWidth
                            
                            let shapeLayer = drawBar(posXBegin: rowXBegin, width: rowXWidth, posYBegin: rowYBegin, height: rowYHeight, color: row.bodyColor)
                            chartShapeLayers.append(shapeLayer)
                        }
                    }
                }
                
            }
        }
    }
    
    private func drawBar(posXBegin: CGFloat, width: CGFloat, posYBegin: CGFloat, height: CGFloat, color: UIColor?) -> CAShapeLayer
    {
        let referedView = super.chartView!
        print("Drawing ChartBar Xbegin:", posXBegin," width:", width,"- Ybegin:", posYBegin," height:", height)
        //let pathBody = UIBezierPath(rect: CGRect(x: posXBegin, y:  posYBegin , width: width, height: height))
        let pathBody = UIBezierPath(rect: CGRect(x: posXBegin, y: referedView.frame.height - (height + posYBegin) , width: width, height: height))
        let bodyShapeLayer = CAShapeLayer()
        bodyShapeLayer.path = pathBody.cgPath
        var bodyColor = UIColor.black
        if(color != nil)
        {
            bodyColor = color!
        }
        bodyShapeLayer.fillColor = bodyColor.cgColor
        animateColumn(shapeLayer: bodyShapeLayer, referedView: referedView)
        referedView.layer.insertSublayer(bodyShapeLayer, below: nil)
        
        return bodyShapeLayer
    }
    
    
    private func animateColumn(shapeLayer:CAShapeLayer, referedView: UIView)
    {
        if(self.animationDuration > 0.0)
        {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = CFTimeInterval(self.animationDuration)
            
            let pathBody = UIBezierPath(rect: CGRect(x: (shapeLayer.path?.currentPoint.x)!, y: referedView.frame.height/*(shapeLayer.path?.currentPoint.y)! + (shapeLayer.path?.boundingBox.size.height)!*/ , width: (shapeLayer.path?.boundingBox.size.width)! , height:  0.0))
            
            animation.fromValue = pathBody.cgPath
            animation.toValue = shapeLayer.path
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            
            shapeLayer.add(animation, forKey: nil)
        }
    }
    
}
