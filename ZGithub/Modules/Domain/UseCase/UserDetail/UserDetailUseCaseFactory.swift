//
//  UserDetailUseCaseFactory.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import Foundation

typealias GetCachedUserDetailByUsernameUseCaseFactory = () -> GetCachedUserDetailByUsernameUseCase

typealias FetchUserDetailByUsernameUseCaseFactory = () -> FetchUserDetailByUsernameUseCase

typealias FormatFollowCountUseCaseFactory = () -> FormatFollowCountUseCase
