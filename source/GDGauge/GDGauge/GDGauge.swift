//
//  GDGaugeView.swift
//
//  Created by Saeid Basirnia on 18.04.2018.
//  Copyright © 2018 Saeid. All rights reserved.
//

import UIKit

public final class GDGaugeView: UIView {
    fileprivate var baseCircleShape: CAShapeLayer!
    fileprivate var handleShape: CAShapeLayer!
    fileprivate var startDegree: CGFloat = 225.0
    fileprivate var endDegree: CGFloat = 315.0
    fileprivate var displayLink: CADisplayLink?
    fileprivate var absStartTime: CFAbsoluteTime?
    fileprivate var baseWidth: CGFloat = 10.0
    
    public var min: CGFloat = 0.0
    public var max: CGFloat = 100.0
    public var currentValue: CGFloat = 0
    public var points: Int = 16
    public var baseColor: UIColor = UIColor(red: 0 / 255, green: 72 / 255, blue: 67 / 255, alpha: 1)
    public var handleColor: UIColor = UIColor(red: 0 / 255, green: 98 / 255, blue: 91 / 255, alpha: 1)
    public var sepratorColor: UIColor = UIColor(red: 0 / 255, green: 174 / 255, blue: 162 / 255, alpha: 1)
    public var textColor: UIColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
    public var unitText: String = "MB/S"
    public var unitTextFont: UIFont = UIFont.systemFont(ofSize: 12)
    public var textFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setupView(){
        backgroundColor = UIColor.clear
        drawBaseCircle()
        drawHandle()
        drawPoints()
    }
    
    private func drawBaseCircle(){
        baseCircleShape = CAShapeLayer()
        baseCircleShape.fillColor = nil
        baseCircleShape.strokeColor = baseColor.cgColor
        baseCircleShape.lineWidth = baseWidth
        baseCircleShape.path = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: (frame.width / 3), startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        
        layer.addSublayer(baseCircleShape)
    }
    
    private func drawHandle(){
        handleShape = CAShapeLayer()
        handleShape.fillColor = handleColor.cgColor
        
        let baseRad = degreeToRadian(degree: finalValue)
        let leftAngle = degreeToRadian(degree: 90 + finalValue)
        let rightAngle = degreeToRadian(degree: -90 + finalValue)
        
        let startVal = frame.width / 4
        let length = CGFloat(5)
        let endVal = startVal + length
        let centerPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let endPoint = CGPoint(x: cos(-baseRad) * endVal + centerPoint.x, y: sin(-baseRad) * endVal + centerPoint.y)
        let rightPoint = CGPoint(x: cos(-leftAngle) * CGFloat(15) + centerPoint.x, y: sin(-leftAngle) * CGFloat(15) + centerPoint.y)
        let leftPoint = CGPoint(x: cos(-rightAngle) * CGFloat(15) + centerPoint.x, y: sin(-rightAngle) * CGFloat(15) + centerPoint.y)
        
        let handlePath = UIBezierPath()
        handlePath.move(to: rightPoint)
        
        let midx = rightPoint.x + ((leftPoint.x - rightPoint.x) / 2)
        let midy = rightPoint.y + ((leftPoint.y - rightPoint.y) / 2)
        let diffx = midx - rightPoint.x
        let diffy = midy - rightPoint.y
        let angle = (atan2(diffy, diffx) * CGFloat((180 / Double.pi))) - 90
        let targetRad = degreeToRadian(degree: angle)
        let newX = midx - 20 * cos(targetRad)
        let newY = midy - 20 * sin(targetRad)
        
        handlePath.addQuadCurve(to: leftPoint, controlPoint: CGPoint(x: newX, y: newY))
        handlePath.addLine(to: endPoint)
        handlePath.addLine(to: rightPoint)
        
        handleShape.path = handlePath.cgPath
        handleShape.anchorPoint = centerPoint
        handleShape.path = handlePath.cgPath
        layer.addSublayer(handleShape)
        
        absStartTime = CFAbsoluteTimeGetCurrent()
        displayLink = CADisplayLink(target: self, selector: #selector(updateHandle(_:)))
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    @objc func updateHandle(_ sender: CADisplayLink){
        let baseRad = degreeToRadian(degree: finalValue)
        let leftAngle = degreeToRadian(degree: 90 + finalValue)
        let rightAngle = degreeToRadian(degree: -90 + finalValue)
        
        let startVal = frame.width / 4
        let length = CGFloat(5)
        let endVal = startVal + length
        let centerPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let endPoint = CGPoint(x: cos(-baseRad) * endVal + centerPoint.x, y: sin(-baseRad) * endVal + centerPoint.y)
        let rightPoint = CGPoint(x: cos(-leftAngle) * CGFloat(15) + centerPoint.x, y: sin(-leftAngle) * CGFloat(15) + centerPoint.y)
        let leftPoint = CGPoint(x: cos(-rightAngle) * CGFloat(15) + centerPoint.x, y: sin(-rightAngle) * CGFloat(15) + centerPoint.y)
        
        let handlePath = UIBezierPath()
        handlePath.move(to: rightPoint)
        
        let midx = rightPoint.x + ((leftPoint.x - rightPoint.x) / 2)
        let midy = rightPoint.y + ((leftPoint.y - rightPoint.y) / 2)
        let diffx = midx - rightPoint.x
        let diffy = midy - rightPoint.y
        let angle = (atan2(diffy, diffx) * CGFloat((180 / Double.pi))) - 90
        let targetRad = degreeToRadian(degree: angle)
        let newX = midx - 20 * cos(targetRad)
        let newY = midy - 20 * sin(targetRad)
        
        handlePath.addQuadCurve(to: leftPoint, controlPoint: CGPoint(x: newX, y: newY))
        handlePath.addLine(to: endPoint)
        handlePath.addLine(to: rightPoint)
        
        handleShape.path = handlePath.cgPath
    }
    
    private func drawPoints(){
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        addFirstIndicators(centerPoint: center)
        addSecondIndicators(centerPoint: center)
        addTexts(centerPoint: center)
    }
    
    private func addFirstIndicators(centerPoint: CGPoint){
        for i in 0...points{
            let indicatorLayer = CAShapeLayer()
            indicatorLayer.frame = bounds
            
            let indicWidth = CGFloat(3)
            let indicLength = CGFloat(8)
            
            let startVal = (frame.width / 3) * 0.95
            let endRad = startVal + indicLength
            let baseAngle = degreeToRadian(degree: calcDegrees(point: CGFloat(i)))
            
            let startPoint = CGPoint(x: cos(-baseAngle) * startVal + centerPoint.x, y: sin(-baseAngle) * startVal + centerPoint.y)
            let endPoint = CGPoint(x: cos(-baseAngle) * endRad+centerPoint.x, y: sin(-baseAngle) * endRad + centerPoint.y)
            
            let indicatorPath = UIBezierPath()
            indicatorPath.move(to: startPoint)
            indicatorPath.addLine(to: endPoint)
            
            indicatorLayer.path = indicatorPath.cgPath
            indicatorLayer.fillColor = UIColor.clear.cgColor
            indicatorLayer.strokeColor = sepratorColor.cgColor
            indicatorLayer.lineWidth = indicWidth
            
            baseCircleShape.addSublayer(indicatorLayer)
        }
    }
    
    private func addSecondIndicators(centerPoint: CGPoint){
        for i in 0...points * 10{
            let indicatorLayer = CAShapeLayer()
            indicatorLayer.frame = bounds
            
            let indicWidth = CGFloat(1)
            let indicLength = CGFloat(2)
            
            var startVal = (frame.width / 3) * 0.88
            var endRad = startVal + indicLength
            
            if (CGFloat(i) / 10).truncatingRemainder(dividingBy: 1) == 0.5{
                startVal = (frame.width / 3) * 0.84
                endRad = (startVal + indicLength) + 10
            }
            let baseAngle = degreeToRadian(degree: calcDegrees(point: CGFloat(CGFloat(i) / 10)))
            
            let startPoint = CGPoint(x: cos(-baseAngle) * startVal + centerPoint.x, y: sin(-baseAngle) * startVal + centerPoint.y)
            let endPoint = CGPoint(x: cos(-baseAngle) * endRad+centerPoint.x, y: sin(-baseAngle) * endRad + centerPoint.y)
            
            let indicatorPath = UIBezierPath()
            indicatorPath.move(to: startPoint)
            indicatorPath.addLine(to: endPoint)
            
            indicatorLayer.path = indicatorPath.cgPath
            indicatorLayer.fillColor = UIColor.clear.cgColor
            indicatorLayer.strokeColor = sepratorColor.cgColor
            indicatorLayer.lineWidth = indicWidth
            
            baseCircleShape.addSublayer(indicatorLayer)
        }
    }
    
    private func addTexts(centerPoint: CGPoint){
        for i in 0...points{
            let endValue = (frame.width / 3) * 1.03
            
            let baseRad = degreeToRadian(degree: calcDegrees(point: CGFloat(i)))
            let endPoint = CGPoint(x: cos(-baseRad) * endValue+centerPoint.x, y: sin(-baseRad) * endValue + centerPoint.y)
            
            let indicValue = Int(CGFloat(i) * (max - min) / CGFloat(points)) + Int(min)
            let indicValueStr : String = String(indicValue)
            let size: CGSize = textSize(str: indicValueStr, font: textFont)
            
            let xOffset = abs(cos(baseRad)) * size.width * 0.5
            let yOffset = abs(sin(baseRad)) * size.height * 0.5
            let textPadding = CGFloat(5.0)
            let textOffset = sqrt(xOffset * xOffset + yOffset * yOffset) + textPadding
            let textCenter = CGPoint(x: cos(-baseRad) * textOffset + endPoint.x, y: sin(-baseRad) * textOffset + endPoint.y)
            let textRect = CGRect(x: textCenter.x - size.width * 0.5, y: textCenter.y - size.height * 0.5, width: size.width, height: size.height)
            
            let textLayer = CATextLayer()
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.frame = textRect
            textLayer.string = indicValueStr
            textLayer.font = unitTextFont
            textLayer.fontSize = unitTextFont.pointSize
            textLayer.foregroundColor = textColor.cgColor
            baseCircleShape.addSublayer(textLayer)
        }
        
        let unitTextLayer = CATextLayer()
        
        unitTextLayer.font = unitTextFont
        unitTextLayer.fontSize = unitTextFont.pointSize
        let size = textSize(str: unitText, font: unitTextFont)
        
        let unitStrRect = CGRect(x: centerPoint.x - (size.width / 2), y: centerPoint.y + 45, width: size.width, height: size.height)
        
        unitTextLayer.contentsScale = UIScreen.main.scale
        unitTextLayer.frame = unitStrRect
        unitTextLayer.string = unitText
        unitTextLayer.foregroundColor = textColor.cgColor
        baseCircleShape.addSublayer(unitTextLayer)
    }
}

///MARK: - calcs
extension GDGaugeView{
    fileprivate var finalValue: CGFloat{
        if currentValue > max{
            currentValue = max
        }
        return startDegree - (currentValue * (360.0 - (endDegree - startDegree))) / max
    }
    
    fileprivate func textSize(str: String, font: UIFont) -> CGSize{
        let attrib = [NSAttributedStringKey.font: font]
        return str.size(withAttributes: attrib)
    }
    
    fileprivate func calcDegrees(point: CGFloat) -> CGFloat{
        if point == 0{
            return startDegree
        }else if point == CGFloat(points){
            return endDegree
        }else{
            return startDegree - ((360.0 - (endDegree - startDegree)) / CGFloat(points)) * CGFloat(point)
        }
    }
    
    fileprivate func degreeToRadian(degree: CGFloat) -> CGFloat{
        return CGFloat(degree * CGFloat(Double.pi / 180.0))
    }
}
