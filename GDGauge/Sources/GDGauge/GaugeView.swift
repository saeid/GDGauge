//
//  GaugeView.swift
//
//  Created by Saeid Basirnia on 18.04.2018.
//  Copyright © 2018 Saeid. All rights reserved.
//

import UIKit

public final class GaugeView: UIView {
    // MARK: - Private properties
    private var containerShape: CAShapeLayer!
    private var handleShape: CAShapeLayer!
    private var displayLink: CADisplayLink?
    private var absStartTime: CFAbsoluteTime?
    private var innerIndicatorsShapes: [CAShapeLayer] = []
    private var outerIndicatorsShapes: [CAShapeLayer] = []
    
    // MARK: - Container properties
    private var containerBorderWidth: CGFloat!
    private var showContainerBorder = true
    private var fullCircleContainerBorder = false
    private var containerColor: UIColor!
    private var handleColor: UIColor!
    private var indicatorsFont: UIFont!
    private var indicatorsColor: UIColor!
    private var indicatorsValuesColor: UIColor!
    private var options: [GaugeOptions]!

    // MARK: - Unit properties
    private var unitImage: UIImage?
    private var unitImageTintColor: UIColor!
    private var unitTitle: String?
    private var unitTitleFont: UIFont!
    
    // MARK: - Other properties
    private var startDegree: CGFloat!
    private var endDegree: CGFloat!
    private var sectionsGapValue: CGFloat!
    private var minValue: CGFloat!
    private var maxValue: CGFloat!
    private var currentValue: CGFloat!

    // MARK: Dependencies
    private var calculations: Calculations!

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     Returns current value of the gauge
     */
    public var value: CGFloat {
        currentValue
    }

    // MARK: - Setup and build Gauge View
    /**

     Setup gauge values.

     - Parameters:
         - startDegree: Starting position in degrees. 0 is bottom center in coordinate system moving clockwise
         - endDegree: Ending position in degrees
         - sectionGap: Gap between each section in the container
         - minValue: Minimum value of the gauge. This will be the `startDegree` value
         - maxValue: Maximum value of the gauge. This will be the `endDegree` value

     */
    public func setupGuage(
        startDegree: CGFloat,
        endDegree: CGFloat,
        sectionGap: CGFloat,
        minValue: CGFloat,
        maxValue: CGFloat,
        currentValue: CGFloat = 0.0
    ) -> Self {
        self.startDegree = startDegree
        self.endDegree = endDegree
        self.sectionsGapValue = sectionGap
        self.minValue = minValue
        self.maxValue = maxValue
        self.currentValue = currentValue

        self.calculations = .init(
            minValue: minValue,
            maxValue: maxValue,
            sectionsGapValue: sectionGap,
            startDegree: startDegree,
            endDegree: endDegree
        )

        return self
    }

    /**

     Setup gauge container UI.

     - Parameters:
         - width: Thickness of the container
         - color: Color of the container
         - handleColor: Color of the handle
         - shouldShowContainerBorder: Show/hide the container. If set to `false` only indicators will be shown.
         - shouldShowFullCircle: Fill the gap between start and end of the gauge
         - indicatorsColor: Color of indicators
         - indicatorsValuesColor: Color of indicator texts
         - indicatorsFont: Font of indicator texts
     - Warning: 'shouldShowContainerBorder' and 'shouldShowFullCircle' will be deprecated in next versions. Please update to use 'GaugeOptions' instead.

     */
    public func setupContainer(
        width: CGFloat = 10,
        color: UIColor = DefaultUI.Container.color,
        handleColor: UIColor = DefaultUI.Container.handleColor,
        shouldShowContainerBorder: Bool = true,
        shouldShowFullCircle: Bool = false,
        indicatorsColor: UIColor = DefaultUI.Container.indicatorsColor,
        indicatorsValuesColor: UIColor = DefaultUI.Container.indicatorValuesColor,
        indicatorsFont: UIFont = DefaultUI.Container.indicatorsFont
    ) -> Self {
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

     Setup gauge container UI.

     - Parameters:
         - width: Thickness of the container
         - color: Color of the container
         - handleColor: Color of the handle
         - options: *Default is .showContainerBorder*
            - **shouldShowContainerBorder**: Show/hide the container. If not set, only indicators will be shown.

            - **shouldShowFullCircle**: Fill the gap between start and end of the gauge.

         - indicatorsColor: Color of indicators
         - indicatorsValuesColor: Color of indicator texts
         - indicatorsFont: Font of indicator texts

     */

    public func setupContainer(
        width: CGFloat = 10,
        color: UIColor = DefaultUI.Container.color,
        handleColor: UIColor = DefaultUI.Container.handleColor,
        options: [GaugeOptions] = [.showContainerBorder],
        indicatorsColor: UIColor = DefaultUI.Container.indicatorsColor,
        indicatorsValuesColor: UIColor = DefaultUI.Container.indicatorValuesColor,
        indicatorsFont: UIFont = DefaultUI.Container.indicatorsFont
    ) -> Self {
        self.containerBorderWidth = width
        self.options = options
        self.indicatorsFont = indicatorsFont
        self.containerColor = color
        self.handleColor = handleColor
        self.indicatorsValuesColor = indicatorsValuesColor
        self.indicatorsColor = indicatorsColor
        return self
    }

    /**

     Setup unit icon for gauge view.
     - Parameters:
         - image: Unit image
         - tintColor: Unit image tint color
     - Warning: If this is set, unit text will be ignored.

     */
    public func setupUnitImage(
        image: UIImage,
        tintColor: UIColor = DefaultUI.Unit.imageTint
    ) -> Self {
        self.unitImage = image
        self.unitImageTintColor = tintColor
        return self
    }

    /**

     Setup gauge view unit title.
     - Parameters:
         - title: Text for the unit
         - font: Font used for the text
     - Warning: If unit type is set to *image mode* this will be ignored.

     */
    public func setupUnitTitle(
        title: String,
        font: UIFont = DefaultUI.Unit.font
    ) -> Self {
        self.unitTitle = title
        self.unitTitleFont = font
        return self
    }

    /// Configure and build the view
    public func buildGauge() {
        if showContainerBorder || options.contains(.showContainerBorder) {
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
        currentValue = value
    }
    
    @objc private func updateHandle(_ sender: CADisplayLink) {
        let newPositionAngle = calculations
            .getNewPosition(currentValue)
            .radian
        let leftAngle = calculations
            .getNewPosition(currentValue, diff: 90)
            .radian
        let rightAngle = calculations
            .getNewPosition(currentValue, diff: -90)
            .radian
        
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
        let targetRad = angle.radian
        let newX = midx - 20 * cos(targetRad)
        let newY = midy - 20 * sin(targetRad)
        
        handlePath.addQuadCurve(to: leftPoint, controlPoint: CGPoint(x: newX, y: newY))
        handlePath.addLine(to: endPoint)
        handlePath.addLine(to: rightPoint)
        
        handleShape.path = handlePath.cgPath
    }
    
    // MARK: - Draw Gauge
    private func drawContainerShape() {
        let startDegree: CGFloat = 360.0 - calculations.calculatedEndDegree
        let endDegree: CGFloat = 360.0 - calculations.calculatedStartDegree
        
        containerShape = CAShapeLayer()
        containerShape.fillColor = nil
        containerShape.strokeColor = containerColor.cgColor
        containerShape.lineWidth = containerBorderWidth
        
        var containerPath: CGPath!
        if fullCircleContainerBorder || options.contains(.fullCircleContainerBorder) {
            containerPath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                         radius: (frame.width / 3), startAngle: 0.0,
                                         endAngle: CGFloat(Double.pi * 2),
                                         clockwise: false).cgPath
        } else {
            containerPath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                         radius: (frame.width / 3),
                                         startAngle: startDegree.radian,
                                         endAngle: endDegree.radian, clockwise: false).cgPath
        }
        containerShape?.path = containerPath
        layer.addSublayer(containerShape)
    }
    
    private func drawHandleShape() {
        handleShape = CAShapeLayer()
        handleShape.fillColor = handleColor.cgColor
        
        let baseDegree = calculations
            .getNewPosition(currentValue)
            .radian
        let leftAngle = calculations
            .getNewPosition(currentValue, diff: 90)
            .radian

        let rightAngle = calculations
            .getNewPosition(currentValue, diff: -90)
            .radian

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
        let targetRad = angle.radian
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
    
    private func drawIndicators() {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        addInnerIndicators(centerPoint: center)
        addOuterIndicators(centerPoint: center)
        addTextLabels(centerPoint: center)
        addUnitIndicator(centerPoint: center)
    }
    
    private func addInnerIndicators(centerPoint: CGPoint) {
        for i in 0...calculations.totalSeparationPoints {
            let indicatorLayer = CAShapeLayer()
            indicatorLayer.frame = bounds
            
            let indicWidth = CGFloat(3)
            let indicLength = CGFloat(8)
            
            let startValue = (frame.width / 3) * 0.95
            let endValue = startValue + indicLength
            let baseAngle = calculations
                .calculateDegree(for: CGFloat(i))
                .radian
            
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
    
    private func addOuterIndicators(centerPoint: CGPoint) {
        for i in 0...calculations.totalSeparationPoints * 10 {
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
            let baseAngle = calculations
                .calculateDegree(for: CGFloat(CGFloat(i) / 10))
                .radian
            
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
    
    private func addTextLabels(centerPoint: CGPoint) {
        for i in 0...calculations.totalSeparationPoints {
            let endValue = (frame.width / 3) * 1.03
            
            let baseRad = calculations
                .calculateDegree(for: CGFloat(i))
                .radian
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
    
    private func addUnitIndicator(centerPoint: CGPoint) {
        if unitImage == nil {
            addTextUnitType(point: centerPoint)
        } else {
            addImageUnitType(point: centerPoint)
        }
    }
    
    private func addTextUnitType(point: CGPoint) {
        let unitTextLayer = CATextLayer()
        unitTextLayer.font = unitTitleFont
        unitTextLayer.fontSize = unitTitleFont.pointSize
        let size = textSize(for: unitTitle, font: unitTitleFont)
        let unitStrRect = CGRect(
            x: point.x - (size.width / 2),
            y: point.y + 45,
            width: size.width,
            height: size.height
        )
        
        unitTextLayer.contentsScale = UIScreen.main.scale
        unitTextLayer.frame = unitStrRect
        unitTextLayer.string = unitTitle
        unitTextLayer.foregroundColor = indicatorsValuesColor.cgColor
        
        layer.addSublayer(unitTextLayer)
    }
    
    private func addImageUnitType(point: CGPoint) {
        guard unitTitle != nil else {
            return
        }
        let imgSize = CGSize(
            width: DefaultUI.Unit.imageSize,
            height: DefaultUI.Unit.imageSize
        )
        let unitRect = CGRect(
            x: point.x - (imgSize.width / 2),
            y: point.y + 45,
            width: imgSize.width,
            height: imgSize.height
        )
        
        let imgLayer = CALayer()
        let myImage = unitImage!.maskWithColor(color: unitImageTintColor)!.cgImage
        imgLayer.frame = unitRect
        imgLayer.contents = myImage
        imgLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        layer.addSublayer(imgLayer)
    }
}

/// MARK: - Font Size Calculations
extension GaugeView {
    private func textSize(for string: String?, font: UIFont) -> CGSize {
        let attribute = [NSAttributedString.Key.font: font]
        return string?.size(withAttributes: attribute) ?? .zero
    }
}
