//
//  FormatFollowCountUseCaseTests.swift
//  ZGithubTests
//
//  Created by Chien Pham on 7/10/24.
//
//

import XCTest
@testable import ZGithub

final class FormatFollowCountUseCaseTests: XCTestCase {

    var useCase: FormatFollowCountUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        useCase = FormatFollowCountUseCase()
    }

    override func tearDownWithError() throws {
        useCase = nil
        try super.tearDownWithError()
    }

    func testExecute_WithSingleDigit_ReturnsExactValue() {
        XCTAssertEqual(useCase.execute(input: 0), "0")
        XCTAssertEqual(useCase.execute(input: 5), "5")
        XCTAssertEqual(useCase.execute(input: 9), "9")
    }

    func testExecute_WithTwoDigits_ReturnsRoundedToNearestTen() {
        XCTAssertEqual(useCase.execute(input: 10), "10+")
        XCTAssertEqual(useCase.execute(input: 23), "20+")
        XCTAssertEqual(useCase.execute(input: 99), "90+")
    }

    func testExecute_WithThreeDigits_ReturnsRoundedToNearestHundred() {
        XCTAssertEqual(useCase.execute(input: 100), "100+")
        XCTAssertEqual(useCase.execute(input: 233), "200+")
        XCTAssertEqual(useCase.execute(input: 999), "900+")
    }

    func testExecute_WithThousands_ReturnsRoundedToNearestThousand() {
        XCTAssertEqual(useCase.execute(input: 1000), "1k+")
        XCTAssertEqual(useCase.execute(input: 12345), "12k+")
        XCTAssertEqual(useCase.execute(input: 987654), "987k+")
    }

    func testExecute_WithMillions_ReturnsRoundedToNearestMillion() {
        XCTAssertEqual(useCase.execute(input: 1_000_000), "1m+")
        XCTAssertEqual(useCase.execute(input: 9_234_567), "9m+")
        XCTAssertEqual(useCase.execute(input: 12_345_678), "12m+")
        XCTAssertEqual(useCase.execute(input: 122_345_678), "122m+")
        XCTAssertEqual(useCase.execute(input: 1_122_345_678), "1122m+")
    }

    func testExecute_WithNegativeValue_ReturnsNA() {
        XCTAssertEqual(useCase.execute(input: -1), "N/A")
        XCTAssertEqual(useCase.execute(input: -999), "N/A")
    }
}
