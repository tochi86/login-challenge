//
//  Resolver.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/14.
//

import Foundation

class Resolver {
    static var instance = Resolver()
    static func reset() { instance = Resolver() }

    private lazy var _authRepository = AuthRepositoryImpl()
    func authRepository() -> AuthRepository { _authRepository }

    private lazy var _userRepository = UserRepositoryImpl()
    func userRepository() -> UserRepository { _userRepository }
}
