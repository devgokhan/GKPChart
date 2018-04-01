//
//  GKPPieChartView.swift
//  GKPChart
//
//  Created by Gokhan on 1.04.2018.
//  Copyright © 2018 Gokhan Alp. All rights reserved.
//

import UIKit

@objc protocol DeletableImageViewDelegate {
    
}

var delegate: DeletableImageViewDelegate?

public enum PieChartAnimationType {
    case AllSlienceTogetherAnim
    case SeperatedSlienceAnim
    case SeperatedSlienceSoftAnim
}

public class GKPPieChartView: GKPChartViewBase {
    
    private var chartDrawed = false
    
    private var pieChartValues = [GKPPieChartValues]()
    
    private var maxDegree : CGFloat = 360.0
    private var isHolePie = false
    
    private var bodyRadius : CGFloat = 80.0
    private var pieLineBodyWidth : CGFloat = 60.0
    private var pieLineStartWidth : CGFloat = 10.0
    private var pieLineEndWidth : CGFloat = 10.0
    private var pieItemDistanceDegree : CGFloat = 1.0
    
    private var animationDuration : CGFloat = 0.0
    private var pieChartAnimationType = PieChartAnimationType.AllSlienceTogetherAnim // AllSlienceTogetherAnim SeperatedSlienceSoftAnim
    
    private var bodyShapeLayers = [CAShapeLayer] ()
    private var startingShapeLayers = [CAShapeLayer] ()
    private var endingShapeLayers = [CAShapeLayer] ()
    private var slienceAngleDistances = [CGFloat] ()
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setChartType(isHoledPie : Bool, pieChartMaxDegree: CGFloat)
    {
        self.isHolePie = isHoledPie
        self.maxDegree = pieChartMaxDegree
    }
    
    public func setChartSizes(chartBodyRadius : CGFloat?, chartBodyWidth: CGFloat?, distanceDegreeBetweenItems : CGFloat?, startingCornerWidth : CGFloat?, endingCornerWidth : CGFloat?)
    {
        if(chartBodyRadius != nil)
        {
            self.bodyRadius = chartBodyRadius!
        }
        if(chartBodyWidth != nil)
        {
            self.pieLineBodyWidth = chartBodyWidth!
        }
        if(distanceDegreeBetweenItems != nil)
        {
            self.pieItemDistanceDegree = distanceDegreeBetweenItems!
        }
        if(startingCornerWidth != nil)
        {
            self.pieLineStartWidth = startingCornerWidth!
        }
        if(endingCornerWidth != nil)
        {
            self.pieLineEndWidth = endingCornerWidth!
        }
    }
    
    public func setPieChartValues(pieChartValues: [GKPPieChartValues])
    {
        self.pieChartValues = pieChartValues
    }
    
    public func setAnimation(animationDuration: CGFloat)
    {
        self.animationDuration = animationDuration
    }
    
    public func drawPieChart()
    {
        if(chartDrawed != true)
        {
            if(pieChartValues.count > 0)
            {
                let total = pieChartValues.map{ $0.value }.reduce(0, +)
                
                self.bodyShapeLayers.removeAll()
                self.startingShapeLayers.removeAll()
                self.endingShapeLayers.removeAll()
                self.slienceAngleDistances.removeAll()
                
                print("total: ", total)
                var startAngle : CGFloat = 0.0
                var index = 0
                for var item in pieChartValues
                {
                    let chartDegreeValue = item.value
                    let chartBodyColor = item.bodyColor
                    startAngle = startAngle + pieItemDistanceDegree
                    let endAngle : CGFloat = maxDegree*(chartDegreeValue)/total + startAngle - pieItemDistanceDegree
                    let endValue : CGFloat = getChartAngle(endAngle)
                    let startValue : CGFloat = getChartAngle(startAngle)
                    let angleDistance : CGFloat = fabs(endAngle - startAngle)
                    self.slienceAngleDistances.append(angleDistance)
                    print("startAngle:", startAngle, " startValue:", startValue, " chartDegree:", chartDegreeValue, " endAngle:", endAngle, " endValue:", endValue, " index:", index, " angleDistance:", angleDistance )
                    var chartColor = UIColor.black
                    if(chartBodyColor != nil)
                    {
                        chartColor = chartBodyColor!
                    }
                    drawChartItem(startAngle:startValue, endAngle:endValue, index: index, chartBodyColor: chartColor)
                    startAngle = endAngle
                    index += 1
                    
                }
                animateAllSlices(shapeLayers: self.bodyShapeLayers,index: 0)
                animateAllSlices(shapeLayers: self.endingShapeLayers,index: 0)
                animateAllSlices(shapeLayers: self.startingShapeLayers,index: 0)
                chartDrawed = true
            }
        }
        else
        {
            print("Chart has already been drawn")
        }
    }
    
    
    
    private func drawChartItem(startAngle : CGFloat, endAngle : CGFloat, index : Int, chartBodyColor : UIColor)
    {
        let referedView = super.chartView!
        referedView.updateConstraints()
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        print(referedView.bounds)
        let clockwise = true
        let center =  CGPoint(x:((referedView.frame.width) / 2.0), y:((referedView.frame.height) / 2.0))
        
        print("Center: ", center)
        
        let pathBody = UIBezierPath(arcCenter: center, radius: self.bodyRadius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        let bodyShapeLayer = CAShapeLayer()
        if (isHolePie)
        {
            bodyShapeLayer.fillColor = UIColor.clear.cgColor
            bodyShapeLayer.strokeColor = chartBodyColor.cgColor
        }
        else
        {
            pathBody.addLine(to: self.center)
            bodyShapeLayer.fillColor = chartBodyColor.cgColor
            bodyShapeLayer.strokeColor = UIColor.clear.cgColor
            self.pieLineBodyWidth = 0.0
        }
        
        bodyShapeLayer.lineWidth = self.pieLineBodyWidth
        bodyShapeLayer.path = pathBody.cgPath
        //animateSlice(shapeLayer: bodyShapeLayer, referedView: referedView, radius: bodyRadius, center: center, clockwise: clockwise, startAngle: startAngle, endAngle: endAngle)
        self.bodyShapeLayers.append(bodyShapeLayer)
        bodyShapeLayer.isHidden = true
        referedView.layer.insertSublayer(bodyShapeLayer, above: nil)
        
        if(isHolePie && pieLineStartWidth != 0.0)
        {
            
            let startingRadius: CGFloat = bodyRadius - self.pieLineBodyWidth/2
            let pathStarting = UIBezierPath(arcCenter: center, radius: startingRadius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
            let startingShapeLayer = CAShapeLayer()
            startingShapeLayer.path = pathStarting.cgPath
            startingShapeLayer.fillColor = UIColor.clear.cgColor
            startingShapeLayer.strokeColor = UIColor.orange.cgColor
            startingShapeLayer.lineWidth = self.pieLineStartWidth
            self.startingShapeLayers.append(startingShapeLayer)
            //animateSlice(shapeLayer: startingShapeLayer, referedView: referedView, radius: startingRadius, center: center,  clockwise: clockwise, startAngle: startAngle, endAngle: endAngle)
            startingShapeLayer.isHidden = true
            referedView.layer.insertSublayer(startingShapeLayer, below: bodyShapeLayer)
        }
        
        if(pieLineEndWidth != 0.0)
        {
            let endingRadius: CGFloat = bodyRadius + self.pieLineBodyWidth/2
            let pathEnding = UIBezierPath(arcCenter: center, radius: endingRadius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
            let endingShapeLayer = CAShapeLayer()
            endingShapeLayer.path = pathEnding.cgPath
            endingShapeLayer.fillColor = UIColor.clear.cgColor
            endingShapeLayer.strokeColor = UIColor.red.cgColor
            endingShapeLayer.lineWidth =  self.pieLineEndWidth
            //animateSlice(shapeLayer: endingShapeLayer, referedView: referedView, radius: endingRadius, center: center, clockwise: clockwise, startAngle: startAngle, endAngle: endAngle)
            self.endingShapeLayers.append(endingShapeLayer)
            endingShapeLayer.isHidden = true
            referedView.layer.insertSublayer(endingShapeLayer, below: bodyShapeLayer)
        }
    }
    
    private func animateAllSlices(shapeLayers:[CAShapeLayer], index:Int)
    {
        if(shapeLayers.count > 0 && index < shapeLayers.count && index >= 0)
        {
            if(self.pieChartAnimationType == PieChartAnimationType.AllSlienceTogetherAnim)
            {
                print("starting animation ", index)
                let shapeLayer = shapeLayers[index]
                
                CATransaction.begin()
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                //let animationTime : CGFloat = ((maxDegree/self.slienceAngleDistances[index])*self.animationDuration)/CGFloat.init(shapeLayers.count)
                let animationTime : CGFloat = (self.slienceAngleDistances[index]*self.animationDuration)/maxDegree
                print("animation duration:", animationTime)
                animation.duration = CFTimeInterval(animationTime)
                
                animation.fromValue = 0.0
                animation.toValue = 1.0
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                
                shapeLayer.strokeEnd = 1.0
                
                CATransaction.setCompletionBlock {
                    print("end animation ", index)
                    self.animateAllSlices(shapeLayers: shapeLayers, index: index+1)
                }
                
                shapeLayer.add(animation, forKey: "animateCircle")
                shapeLayer.isHidden = false
                CATransaction.commit()
            }
            else
            {
                for var item in shapeLayers
                {
                    animateSlice(shapeLayer: item)
                    item.isHidden = false
                    
                }
            }
            
            
        }
    }
    
    private func animateSlice(shapeLayer:CAShapeLayer)
    {
        if(self.animationDuration > 0.0)
        {
            if (self.pieChartAnimationType == PieChartAnimationType.SeperatedSlienceAnim )
            {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration = CFTimeInterval(self.animationDuration)
                
                animation.fromValue = 0.0
                animation.toValue = 1.0
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // kCAMediaTimingFunctionLinear
                
                // animation.fillMode = kCAFillModeForwards
                //animation.isRemovedOnCompletion = false
                
                shapeLayer.add(animation, forKey: "strokeAnim")  // animateCircle
            }
            else if (self.pieChartAnimationType == PieChartAnimationType.SeperatedSlienceSoftAnim )
            {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration = CFTimeInterval(self.animationDuration)
                animation.fromValue = 0.0
                animation.toValue = 1.0
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                shapeLayer.add(animation, forKey: "animateCircle")
            }
            else // Default : AllSlienceTogetherAnim
            {
                CATransaction.begin()
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration = CFTimeInterval(self.animationDuration)
                //let pathBody = UIBezierPath(arcCenter: center, radius: radius, startAngle: getChartAngle(0.0), endAngle: getChartAngle(1.0), clockwise: clockwise)
                
                animation.fromValue = 0.0
                animation.toValue = 1.0
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                
                // animation.fillMode = kCAFillModeForwards
                //animation.isRemovedOnCompletion = false
                shapeLayer.strokeEnd = 1.0
                
                CATransaction.setCompletionBlock {
                    print("end animation")
                }
                
                shapeLayer.add(animation, forKey: "animateCircle")
                CATransaction.commit()
            }
            
        }
    }
    
    
    // MARK: - Utils
    
    private func getChartAngle(_ angle: CGFloat) -> CGFloat
    {
        return (CGFloat(M_PI)*fabs(angle + 180.0))/180.0
    }
    
}
