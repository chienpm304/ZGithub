//
//  SyncUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//  
//

import Foundation

public protocol SyncUseCase {
    associatedtype Input
    associatedtype Output

    func execute(input: Input) -> Output
}
