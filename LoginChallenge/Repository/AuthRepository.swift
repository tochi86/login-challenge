//
//  AuthRepository.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import Foundation
import APIServices

protocol AuthRepository: AnyObject {
    func login(id: String, password: String) async throws
    func logout() async
}

final class AuthRepositoryImpl: AuthRepository {
    func login(id: String, password: String) async throws {
        try await AuthService.logInWith(id: id, password: password)
    }

    func logout() async {
        await AuthService.logOut()
    }
}
