//
//  DIContainer.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/14.
//

import Foundation

class DIContainer {
    static var `default` = DIContainer()

    private lazy var _authRepository = AuthRepositoryImpl()
    func authRepository() -> AuthRepository { _authRepository }

    private lazy var _userRepository = UserRepositoryImpl()
    func userRepository() -> UserRepository { _userRepository }
}
