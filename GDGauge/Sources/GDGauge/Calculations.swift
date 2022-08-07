//
//  Calculations.swift
//  
//
//  Created by Saeid on 2022-08-07.
//

import UIKit

struct Calculations {
    let minValue: CGFloat
    let maxValue: CGFloat
    let sectionsGapValue: CGFloat
    let startDegree: CGFloat
    let endDegree: CGFloat

    var totalSeparationPoints: Int {
        Int((maxValue - minValue) / sectionsGapValue)
    }

    var calculatedStartDegree: CGFloat {
        270.0 - startDegree
    }

    var calculatedEndDegree: CGFloat {
        return 270.0 - endDegree + 360
    }

    func getNewPosition(_ currentValue: CGFloat, diff: CGFloat = 0) -> CGFloat {
        var filteredCurrentValue = currentValue
        if currentValue > maxValue {
            filteredCurrentValue = maxValue
        }
        if currentValue < minValue {
            filteredCurrentValue = minValue
        }
        let convertedDegree = filteredCurrentValue * (360.0 - (calculatedEndDegree - calculatedStartDegree))
        return (calculatedStartDegree - (convertedDegree / maxValue)) + diff
    }

    func calculateDegree(for point: CGFloat) -> CGFloat {
        guard point != 0 else {
            return calculatedStartDegree
        }
        return point == CGFloat(totalSeparationPoints)
        ? calculatedEndDegree
        : calculatedStartDegree - ((360.0 - (calculatedEndDegree - calculatedStartDegree)) / CGFloat(totalSeparationPoints)) * point
    }
}
