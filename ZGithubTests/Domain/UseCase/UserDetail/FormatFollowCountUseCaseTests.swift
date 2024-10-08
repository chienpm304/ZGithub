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

    private var useCase: DefaultFormatFollowCountUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        useCase = DefaultFormatFollowCountUseCase()
    }

    override func tearDownWithError() throws {
        useCase = nil
        try super.tearDownWithError()
    }

    func test_execute_givenSingleDigit_expectExactValue() {
        XCTAssertEqual(useCase.execute(count: 0), "0")
        XCTAssertEqual(useCase.execute(count: 5), "5")
        XCTAssertEqual(useCase.execute(count: 9), "9")
    }

    func test_execute_givenTwoDigits_expectRoundedToNearestTen() {
        XCTAssertEqual(useCase.execute(count: 10), "10+")
        XCTAssertEqual(useCase.execute(count: 23), "20+")
        XCTAssertEqual(useCase.execute(count: 99), "90+")
    }

    func test_execute_givenThreeDigits_expectRoundedToNearestHundred() {
        XCTAssertEqual(useCase.execute(count: 100), "100+")
        XCTAssertEqual(useCase.execute(count: 233), "200+")
        XCTAssertEqual(useCase.execute(count: 999), "900+")
    }

    func test_execute_givenThousands_expectRoundedToNearestThousand() {
        XCTAssertEqual(useCase.execute(count: 1000), "1k+")
        XCTAssertEqual(useCase.execute(count: 12345), "12k+")
        XCTAssertEqual(useCase.execute(count: 987654), "987k+")
    }

    func test_execute_givenMillions_expectRoundedToNearestMillion() {
        XCTAssertEqual(useCase.execute(count: 1_000_000), "1m+")
        XCTAssertEqual(useCase.execute(count: 9_234_567), "9m+")
        XCTAssertEqual(useCase.execute(count: 12_345_678), "12m+")
        XCTAssertEqual(useCase.execute(count: 122_345_678), "122m+")
        XCTAssertEqual(useCase.execute(count: 1_122_345_678), "1122m+")
    }

    func test_execute_givenNegativeValue_expectNA() {
        XCTAssertEqual(useCase.execute(count: -1), "N/A")
        XCTAssertEqual(useCase.execute(count: -999), "N/A")
    }
}
