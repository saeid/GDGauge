//
//  CalculationsTests.swift
//  
//
//  Created by Saeid on 2022-08-07.
//

import XCTest
@testable import GDGauge

final class CalculationsTests: XCTestCase {

    private var sut: Calculations!

    override func setUp() {
        super.setUp()
        sut = Calculations(
            minValue: 0.0,
            maxValue: 200.0,
            sectionsGapValue: 10.0,
            startDegree: 0.0,
            endDegree: 135.0
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_totalSeparationPoints() {
        let result = sut.totalSeparationPoints

        XCTAssertEqual(result, 20)
    }

    func test_calculatedStartDegree() {
        let result = sut.calculatedStartDegree

        XCTAssertEqual(result, 270.0)
    }

    func test_calculatedEndDegree() {
        let result = sut.calculatedEndDegree

        XCTAssertEqual(result, 495.0)
    }

    func test_getNewPosition_whenInputIsInRange_shouldReturnComputedDegree() {
        let resultFor10 = sut.getNewPosition(10.0)

        XCTAssertEqual(resultFor10, 263.25)

        let resultFor35 = sut.getNewPosition(35.0)

        XCTAssertEqual(resultFor35, 246.375)

        let resultFor10WithDiff90 = sut.getNewPosition(10.0, diff: 90)

        XCTAssertEqual(resultFor10WithDiff90, 353.25)

        let resultFor10WithDiffMinus90 = sut.getNewPosition(10.0, diff: -90)

        XCTAssertEqual(resultFor10WithDiffMinus90, 173.25)
    }

    func test_getNewPosition_whenInputIsBiggerThanMaxValue__shouldReturnEndDegree() {
        let result = sut.getNewPosition(250)

        XCTAssertEqual(result, 135.0)
    }

    func test_getNewPosition_whenInputSmallerThanMinValue_shouldReturnStartDegree() {
        let result = sut.getNewPosition(-20)

        XCTAssertEqual(result, 270.0)
    }

    func test_calculateDegree_whenInputIsZero() {
        let result = sut.calculateDegree(for: 0)

        XCTAssertEqual(result, 270.0)
    }

    func test_calculateDegree_whenInputIsGreaterThanZero() {
        let result = sut.calculateDegree(for: 55)

        XCTAssertEqual(result, -101.25)
    }
}
