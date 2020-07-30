//
//  GDGaugeView.swift
//
//  Created by Saeid Basirnia on 18.04.2018.
//  Copyright © 2018 Saeid. All rights reserved.
//

import UIKit

public final class GDGaugeView: UIView {
    // MARK: - Private properties
    fileprivate var containerShape: CAShapeLayer!
    fileprivate var handleShape: CAShapeLayer!
    fileprivate var displayLink: CADisplayLink?
    fileprivate var absStartTime: CFAbsoluteTime?
    fileprivate var innerIndicatorsShapes: [CAShapeLayer] = []
    fileprivate var outerIndicatorsShapes: [CAShapeLayer] = []
    
    @available(swift, obsoleted: 5.0, renamed: "unitImageTintColor")
    public var unitImageTint: UIColor = UIColor.black
    
    @available(swift, obsoleted: 5.0, renamed: "showContainerBorder")
    public var showBorder: Bool = true
    
    @available(swift, obsoleted: 5.0, renamed: "fullCircleContainerBorder")
    public var fullBorder: Bool = false
    
    @available(swift, obsoleted: 5.0, renamed: "sectionsGapValue")
    public var stepValue: CGFloat = 20
    
    @available(swift, obsoleted: 5.0, renamed: "minValue")
    public var min: CGFloat = 0
    
    @available(swift, obsoleted: 5.0, renamed: "maxValue")
    public var max: CGFloat = 220
    
    @available(swift, obsoleted: 5.0, renamed: "containerColor")
    public var baseColor: UIColor = UIColor(red: 0 / 255, green: 72 / 255, blue: 67 / 255, alpha: 1)
    
    @available(swift, obsoleted: 5.0, renamed: "indicatorsColor")
    public var sepratorColor: UIColor = UIColor(red: 0 / 255, green: 174 / 255, blue: 162 / 255, alpha: 1)
    
    @available(swift, obsoleted: 5.0, renamed: "indicatorsValuesColor")
    public var textColor: UIColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
    
    @available(swift, obsoleted: 5.0, renamed: "unitTitle")
    public var unitText: String = "km/h"
    
    @available(swift, obsoleted: 5.0, renamed: "unitTitleFont")
    public var unitTextFont: UIFont = UIFont.systemFont(ofSize: 12)
    
    @available(swift, obsoleted: 5.0, renamed: "indicatorsFont")
    public var textFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    // MARK: - Container properties
    public var containerBorderWidth: CGFloat!
    public var showContainerBorder: Bool!
    public var fullCircleContainerBorder: Bool!
    public var containerColor: UIColor!
    public var handleColor: UIColor!
    public var indicatorsFont: UIFont!
    public var indicatorsColor: UIColor!
    public var indicatorsValuesColor: UIColor!
    
    // MARK: - Unit properties
    public var unitImage: UIImage?
    public var unitImageTintColor: UIColor!
    public var unitTitle: String?
    public var unitTitleFont: UIFont!
    
    // MARK: - Other properties
    public var startDegree: CGFloat!
    public var endDegree: CGFloat!
    public var sectionsGapValue: CGFloat!
    public var minValue: CGFloat!
    public var maxValue: CGFloat!
    public var currentValue: CGFloat!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Container calculations
    fileprivate var totalSeparationPoints: Int {
        return Int((maxValue - minValue) / sectionsGapValue)
    }
    
    fileprivate var calculatedStartDegree: CGFloat {
        return 270.0 - startDegree
    }
    
    fileprivate var calculatedEndDegree: CGFloat {
        return 270.0 - endDegree + 360
    }
    
    /*******************DEPRECATED*********************************/
    @available(*, deprecated, message: "This method is deprecated and will be removed in next updates. Please check README file for full details")
    public func setupView(){
        backgroundColor = UIColor.clear
    
        if currentValue == nil {
            currentValue = 0.0
        }
        if startDegree == nil {
            startDegree = 45
        }
        if endDegree == nil {
            endDegree = 270
        }
        if minValue == nil {
            minValue = 0
        }
        if maxValue == nil {
            maxValue = 100
        }
        if sectionsGapValue == nil {
            sectionsGapValue = 20
        }
        if containerBorderWidth == nil {
            containerBorderWidth = 10
        }
        if containerColor == nil {
            containerColor = UIColor(red: 0 / 255, green: 72 / 255, blue: 67 / 255, alpha: 1)
        }
        if handleColor == nil {
            handleColor = UIColor(red: 0 / 255, green: 98 / 255, blue: 91 / 255, alpha: 1)
        }
        if showContainerBorder == nil {
            showContainerBorder = true
        }
        if fullCircleContainerBorder == nil {
            fullCircleContainerBorder = false
        }
        if indicatorsFont == nil {
            indicatorsFont = UIFont.systemFont(ofSize: 16)
        }
        if indicatorsColor == nil {
            indicatorsColor = UIColor(red: 0 / 255, green: 174 / 255, blue: 162 / 255, alpha: 1)
        }
        if indicatorsValuesColor == nil {
            indicatorsValuesColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        }
        if unitImageTintColor == nil {
            unitImageTintColor = UIColor.black
        }
        if unitTitleFont == nil {
            unitTitleFont = UIFont.systemFont(ofSize: 16)
        }
        
        if showContainerBorder {
            drawContainerShape()
        }
        drawHandleShape()
        drawIndicators()
    }
    /**************************************************************/
    
    // MARK: - Setup and build Gauge View
    /**
     Setup gauge properties and its characteristics
     - Parameters:
         - startDegree: Starting position in degrees. 0 is bottom center in coordinate system moving clockwise
         - endDegree: Ending position in degrees
         - sectionGap: Gap between each section in the container
         - minValue: Minimum value of the gauge. This will be the `startDegree` value
         - maxValue: Maximum value of the gauge. This will be the `endDegree` value
     */
    public func setupGuage(startDegree: CGFloat, endDegree: CGFloat, sectionGap: CGFloat, minValue: CGFloat, maxValue: CGFloat, currentValue: CGFloat = 0.0) -> Self {
        self.startDegree = startDegree
        self.endDegree = endDegree
        self.sectionsGapValue = sectionGap
        self.minValue = minValue
        self.maxValue = maxValue
        self.currentValue = currentValue
        return self
    }
    
    /**
     Setup gauge view container characteristics
     - Parameters:
         - width: Thickness of the container
         - color: Color of the container
         - handleColor: Color of the handle
         - shouldShowContainerBorder: Show/hide the container. If set to `false` only indicators will be shown.
         - shouldShowFullCircle: Fill the gap between start and end of the gauge
         - indicatorsColor: Color of indicators
         - indicatorsValuesColor: Color of indicator texts
         - indicatorsFont: Font of indicator texts
     */
    public func setupContainer(width: CGFloat = 10,
                               color: UIColor = UIColor(red: 0 / 255, green: 72 / 255, blue: 67 / 255, alpha: 1),
                               handleColor: UIColor = UIColor(red: 0 / 255, green: 98 / 255, blue: 91 / 255, alpha: 1),
                               shouldShowContainerBorder: Bool = true,
                               shouldShowFullCircle: Bool = false,
                               indicatorsColor: UIColor = UIColor(red: 0 / 255, green: 174 / 255, blue: 162 / 255, alpha: 1),
                               indicatorsValuesColor: UIColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1),
                               indicatorsFont: UIFont = UIFont.systemFont(ofSize: 16)) -> Self {
        self.containerBorderWidth = width
        self.showContainerBorder = shouldShowContainerBorder
        self.fullCircleContainerBorder = shouldShowFullCircle
        self.indicatorsFont = indicatorsFont
        self.containerColor = color
        self.handleColor = handleColor
        self.indicatorsValuesColor = indicatorsValuesColor
        self.indicatorsColor = indicatorsColor
        return self
    }
    
    /**
     This is to add an image for the unit value. Note if this is set, unit text will be ignored.
     - Parameters:
         - image: Unit image
         - tintColor: Unit image tint color
     */
    public func setupUnitImage(image: UIImage,
                               tintColor: UIColor = UIColor.black) -> Self {
        self.unitImage = image
        self.unitImageTintColor = tintColor
        return self
    }
    
    /**
     This is to add a title for the unit value. Note if unit type is set to *image mode* this will be ignored.
     - Parameters:
         - title: Text for the unit
         - font: Font used for the text
     */
    public func setupUnitTitle(title: String,
                               font: UIFont = UIFont.systemFont(ofSize: 12)) -> Self {
        self.unitTitle = title
        self.unitTitleFont = font
        return self
    }
    
    /// Configure and build the view
    public func buildGauge() {
        if showContainerBorder {
            drawContainerShape()
        }
        drawHandleShape()
        drawIndicators()
    }
    
    // MARK: - Update UI
    /**
     For updating colors if a limit is reached.
     - Parameters:
         - containerColor: New color of container
         - indicatorsColor: New color of indicators
     */
    public func updateColors(containerColor: UIColor, indicatorsColor: UIColor) {
        if containerShape == nil {
            fatalError("Make sure to set `showContainerBorder` to true before using this function")
        }
        UIView.animate(withDuration: 0.4) {
            self.containerShape.strokeColor = containerColor.cgColor
            self.handleShape.fillColor = containerColor.cgColor
            self.innerIndicatorsShapes.forEach({
                $0.strokeColor = indicatorsColor.cgColor
            })
            self.outerIndicatorsShapes.forEach({
                $0.strokeColor = indicatorsColor.cgColor
            })
        }
    }
    
    /// Reset to initial colors if colors are changed with `updateColors`
    public func resetColors() {
        if containerShape == nil {
            fatalError("Make sure to set `showContainerBorder` to true before using this function")
        }
        UIView.animate(withDuration: 0.4) {
            self.containerShape.strokeColor = self.containerColor.cgColor
            self.handleShape.fillColor = self.handleColor.cgColor
            self.innerIndicatorsShapes.forEach({
                $0.strokeColor = self.indicatorsColor.cgColor
            })
            self.outerIndicatorsShapes.forEach({
                $0.strokeColor = self.indicatorsColor.cgColor
            })
        }
    }
    
    /// Update handle value to new value
    public func updateValueTo(_ value: CGFloat) {
        self.currentValue = value
    }
    
    @objc fileprivate func updateHandle(_ sender: CADisplayLink) {
        let newPositionAngle = degreeToRadian(newPositionValue)
        let leftAngle = degreeToRadian(90 + newPositionValue)
        let rightAngle = degreeToRadian(-90 + newPositionValue)
        
        let startVal = frame.width / 4
        let length = CGFloat(5)
        let endVal = startVal + length
        let centerPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let endPoint = CGPoint(x: cos(-newPositionAngle) * endVal + centerPoint.x,
                               y: sin(-newPositionAngle) * endVal + centerPoint.y)
        let rightPoint = CGPoint(x: cos(-leftAngle) * CGFloat(15) + centerPoint.x,
                                 y: sin(-leftAngle) * CGFloat(15) + centerPoint.y)
        let leftPoint = CGPoint(x: cos(-rightAngle) * CGFloat(15) + centerPoint.x,
                                y: sin(-rightAngle) * CGFloat(15) + centerPoint.y)
        
        let handlePath = UIBezierPath()
        handlePath.move(to: rightPoint)
        
        let midx = rightPoint.x + ((leftPoint.x - rightPoint.x) / 2)
        let midy = rightPoint.y + ((leftPoint.y - rightPoint.y) / 2)
        let diffx = midx - rightPoint.x
        let diffy = midy - rightPoint.y
        let angle = (atan2(diffy, diffx) * CGFloat((180 / Double.pi))) - 90
        let targetRad = degreeToRadian(angle)
        let newX = midx - 20 * cos(targetRad)
        let newY = midy - 20 * sin(targetRad)
        
        handlePath.addQuadCurve(to: leftPoint, controlPoint: CGPoint(x: newX, y: newY))
        handlePath.addLine(to: endPoint)
        handlePath.addLine(to: rightPoint)
        
        handleShape.path = handlePath.cgPath
    }
    
    // MARK: - Draw Gauge
    fileprivate func drawContainerShape() {
        let startDegree: CGFloat = 360.0 - calculatedEndDegree
        let endDegree: CGFloat = 360.0 - calculatedStartDegree
        
        containerShape = CAShapeLayer()
        containerShape.fillColor = nil
        containerShape.strokeColor = containerColor.cgColor
        containerShape.lineWidth = containerBorderWidth
        
        var containerPath: CGPath!
        if fullCircleContainerBorder {
            containerPath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                         radius: (frame.width / 3), startAngle: 0.0,
                                         endAngle: CGFloat(Double.pi * 2),
                                         clockwise: false).cgPath
        } else {
            containerPath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                         radius: (frame.width / 3),
                                         startAngle: degreeToRadian(startDegree),
                                         endAngle: degreeToRadian(endDegree), clockwise: false).cgPath
        }
        containerShape?.path = containerPath
        layer.addSublayer(containerShape)
    }
    
    fileprivate func drawHandleShape() {
        handleShape = CAShapeLayer()
        handleShape.fillColor = handleColor.cgColor
        
        let baseDegree = degreeToRadian(newPositionValue)
        let leftAngle = degreeToRadian(90 + newPositionValue)
        let rightAngle = degreeToRadian(-90 + newPositionValue)
        
        let startVal = frame.width / 4
        let length = CGFloat(5)
        let endVal = startVal + length
        let centerPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let endPoint = CGPoint(x: cos(-baseDegree) * endVal + centerPoint.x,
                               y: sin(-baseDegree) * endVal + centerPoint.y)
        let rightPoint = CGPoint(x: cos(-leftAngle) * CGFloat(15) + centerPoint.x,
                                 y: sin(-leftAngle) * CGFloat(15) + centerPoint.y)
        let leftPoint = CGPoint(x: cos(-rightAngle) * CGFloat(15) + centerPoint.x,
                                y: sin(-rightAngle) * CGFloat(15) + centerPoint.y)
        
        let handlePath = UIBezierPath()
        handlePath.move(to: rightPoint)
        
        let midx = rightPoint.x + ((leftPoint.x - rightPoint.x) / 2)
        let midy = rightPoint.y + ((leftPoint.y - rightPoint.y) / 2)
        let diffx = midx - rightPoint.x
        let diffy = midy - rightPoint.y
        let angle = (atan2(diffy, diffx) * CGFloat((180 / Double.pi))) - 90
        let targetRad = degreeToRadian(angle)
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
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    fileprivate func drawIndicators() {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        addInnerIndicators(centerPoint: center)
        addOuterIndicators(centerPoint: center)
        addTextLabels(centerPoint: center)
        addUnitIndicator(centerPoint: center)
    }
    
    fileprivate func addInnerIndicators(centerPoint: CGPoint) {
        for i in 0...totalSeparationPoints {
            let indicatorLayer = CAShapeLayer()
            indicatorLayer.frame = bounds
            
            let indicWidth = CGFloat(3)
            let indicLength = CGFloat(8)
            
            let startValue = (frame.width / 3) * 0.95
            let endValue = startValue + indicLength
            let baseAngle = degreeToRadian(calculateDegree(for: CGFloat(i)))
            
            let startPoint = CGPoint(x: cos(-baseAngle) * startValue + centerPoint.x,
                                     y: sin(-baseAngle) * startValue + centerPoint.y)
            let endPoint = CGPoint(x: cos(-baseAngle) * endValue+centerPoint.x,
                                   y: sin(-baseAngle) * endValue + centerPoint.y)
            
            let indicatorPath = UIBezierPath()
            indicatorPath.move(to: startPoint)
            indicatorPath.addLine(to: endPoint)
            
            indicatorLayer.path = indicatorPath.cgPath
            indicatorLayer.fillColor = UIColor.clear.cgColor
            indicatorLayer.strokeColor = indicatorsColor.cgColor
            indicatorLayer.lineWidth = indicWidth
            
            layer.addSublayer(indicatorLayer)
            innerIndicatorsShapes.append(indicatorLayer)
        }
    }
    
    fileprivate func addOuterIndicators(centerPoint: CGPoint) {
        for i in 0...totalSeparationPoints * 10 {
            let indicatorLayer = CAShapeLayer()
            indicatorLayer.frame = bounds
            
            let indicatorWidth = CGFloat(1)
            let indicatorLength = CGFloat(2)
            
            var startValue = (frame.width / 3) * 0.88
            var endValue = startValue + indicatorLength
            
            if (CGFloat(i) / 10).truncatingRemainder(dividingBy: 1) == 0.5 {
                startValue = (frame.width / 3) * 0.84
                endValue = (startValue + indicatorLength) + 10
            }
            let baseAngle = degreeToRadian(calculateDegree(for: CGFloat(CGFloat(i) / 10)))
            
            let startPoint = CGPoint(x: cos(-baseAngle) * startValue + centerPoint.x,
                                     y: sin(-baseAngle) * startValue + centerPoint.y)
            let endPoint = CGPoint(x: cos(-baseAngle) * endValue+centerPoint.x,
                                   y: sin(-baseAngle) * endValue + centerPoint.y)
            
            let indicatorPath = UIBezierPath()
            indicatorPath.move(to: startPoint)
            indicatorPath.addLine(to: endPoint)
            
            indicatorLayer.path = indicatorPath.cgPath
            indicatorLayer.fillColor = UIColor.clear.cgColor
            indicatorLayer.strokeColor = indicatorsColor.cgColor
            indicatorLayer.lineWidth = indicatorWidth
            
            layer.addSublayer(indicatorLayer)
            outerIndicatorsShapes.append(indicatorLayer)
        }
    }
    
    fileprivate func addTextLabels(centerPoint: CGPoint) {
        for i in 0...totalSeparationPoints {
            let endValue = (frame.width / 3) * 1.03
            
            let baseRad = degreeToRadian(calculateDegree(for: CGFloat(i)))
            let endPoint = CGPoint(x: cos(-baseRad) * endValue + centerPoint.x,
                                   y: sin(-baseRad) * endValue + centerPoint.y)
            
            var indicatorValue: CGFloat = 0
            indicatorValue = sectionsGapValue * CGFloat(i) + minValue
            
            var indicatorStringValue : String = ""
            if indicatorValue.truncatingRemainder(dividingBy: 1) == 0{
                indicatorStringValue = String(Int(indicatorValue))
            } else {
                indicatorStringValue = String(Double(indicatorValue))
            }
            let size: CGSize = textSize(for: indicatorStringValue, font: indicatorsFont)
            
            let xOffset = abs(cos(baseRad)) * size.width * 0.5
            let yOffset = abs(sin(baseRad)) * size.height * 0.5
            let textPadding = CGFloat(5.0)
            let textOffset = sqrt(xOffset * xOffset + yOffset * yOffset) + textPadding
            let textCenter = CGPoint(x: cos(-baseRad) * textOffset + endPoint.x,
                                     y: sin(-baseRad) * textOffset + endPoint.y)
            let textRect = CGRect(x: textCenter.x - size.width * 0.5,
                                  y: textCenter.y - size.height * 0.5,
                                  width: size.width,
                                  height: size.height)
            
            let textLayer = CATextLayer()
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.frame = textRect
            textLayer.string = indicatorStringValue
            textLayer.font = unitTitleFont
            textLayer.fontSize = unitTitleFont.pointSize
            textLayer.foregroundColor = indicatorsValuesColor.cgColor
            
            layer.addSublayer(textLayer)
        }
    }
    
    fileprivate func addUnitIndicator(centerPoint: CGPoint) {
        if unitImage == nil {
            addTextUnitType(point: centerPoint)
        } else {
            addImageUnitType(point: centerPoint)
        }
    }
    
    fileprivate func addTextUnitType(point: CGPoint) {
        let unitTextLayer = CATextLayer()
        unitTextLayer.font = unitTitleFont
        unitTextLayer.fontSize = unitTitleFont.pointSize
        let size = textSize(for: unitTitle, font: unitTitleFont)
        
        let unitStrRect = CGRect(x: point.x - (size.width / 2),
                                 y: point.y + 45,
                                 width: size.width,
                                 height: size.height)
        
        unitTextLayer.contentsScale = UIScreen.main.scale
        unitTextLayer.frame = unitStrRect
        unitTextLayer.string = unitTitle
        unitTextLayer.foregroundColor = indicatorsValuesColor.cgColor
        
        layer.addSublayer(unitTextLayer)
    }
    
    fileprivate func addImageUnitType(point: CGPoint) {
        if unitTitle == nil { return }
        let imgSize = CGSize(width: 20, height: 20)
        let unitRect = CGRect(x: point.x - (imgSize.width / 2), y: point.y + 45, width: imgSize.width, height: imgSize.height)
        
        let imgLayer = CALayer()
        let myImage = unitImage!.maskWithColor(color: unitImageTintColor)!.cgImage
        imgLayer.frame = unitRect
        imgLayer.contents = myImage
        imgLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        layer.addSublayer(imgLayer)
    }
}

/// MARK: - Size Calculations
extension GDGaugeView {
    fileprivate var newPositionValue: CGFloat {
        if currentValue > maxValue {
            currentValue = maxValue
        }
        return calculatedStartDegree - (currentValue * (360.0 - (calculatedEndDegree - calculatedStartDegree))) / maxValue
    }
    
    fileprivate func textSize(for string: String?, font: UIFont) -> CGSize {
        let attribute = [NSAttributedString.Key.font: font]
        return string?.size(withAttributes: attribute) ?? .zero
    }
    
    fileprivate func calculateDegree(for point: CGFloat) -> CGFloat {
        if point == 0 {
            return calculatedStartDegree
        } else if point == CGFloat(totalSeparationPoints) {
            return calculatedEndDegree
        } else {
            return calculatedStartDegree - ((360.0 - (calculatedEndDegree - calculatedStartDegree)) / CGFloat(totalSeparationPoints)) * point
        }
    }
    
    fileprivate func degreeToRadian(_ degree: CGFloat) -> CGFloat {
        return CGFloat(degree * CGFloat(Double.pi / 180.0))
    }
}

extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {
        guard let maskImage = cgImage else {
            fatalError("Can not get image data")
        }
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            fatalError("Can not create the context")
        }
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
}
