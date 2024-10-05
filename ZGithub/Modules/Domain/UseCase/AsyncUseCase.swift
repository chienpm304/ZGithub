//
//  AsyncUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

public protocol AsyncUseCase {
    associatedtype Input
    associatedtype Output

    func execute(input: Input) async throws -> Output
}
