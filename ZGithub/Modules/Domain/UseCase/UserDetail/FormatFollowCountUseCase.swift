//
//  FormatFollowCountUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//  
//

import Foundation

struct FormatFollowCountUseCase: SyncUseCase {
    typealias Input = Int
    typealias Output = String

    func execute(input: Input) -> Output {
        roundedCount(input)
    }

    /// Rounds down the given count to the nearest significant unit (tens, hundreds, thousands, or millions) and appends a "+".
    ///
    /// - Parameter count: The integer value to be formatted.
    /// - Returns: A formatted string representing the rounded down value:
    ///     - `0` to `9`: Returns the exact number as a string (e.g., `7` → `"7"`).
    ///     - `10` to `99`: Rounds down to the nearest 10 and appends `"+"` (e.g., `23` → `"20+"`).
    ///     - `100` to `999`: Rounds down to the nearest 100 and appends `"+"` (e.g., `233` → `"200+"`).
    ///     - `1000` to `999999`: Divides the number by 1000, rounds down to the nearest thousand, and appends `"k+"`
    ///       (e.g., `1200` → `"1k+"`, `12345` → `"12k+"`).
    ///     - `1000000` and above: Divides the number by 1,000,000, rounds down to the nearest million, and appends `"m+"`
    ///       (e.g., `1200000` → `"1m+"`, `12345678` → `"12m+"`).
    private func roundedCount(_ count: Int) -> String {
        guard count >= 0 else { return "N/A" }
        switch count {
        case 0..<10:
            return "\(count)"
        case 10..<100:
            return "\(count - count % 10)+"
        case 100..<1000:
            return "\(count - count % 100)+"
        case 1000..<1_000_000:
            return "\(count / 1000)k+"
       default:
            return "\(count / 1_000_000)m+"
        }
    }
}
