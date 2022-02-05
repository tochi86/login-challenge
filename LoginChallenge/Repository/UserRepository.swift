//
//  UserRepository.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import Foundation
import Entities
import APIServices

protocol UserRepository: AnyObject {
    func currentUser() async throws -> User
}

final class UserRepositoryImpl: UserRepository {
    func currentUser() async throws -> User {
        return try await UserService.currentUser()
    }
}
