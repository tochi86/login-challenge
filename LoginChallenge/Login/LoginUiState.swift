//
//  LoginUiState.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/01/22.
//

import Foundation

struct LoginUiState: Equatable {
    var id: String = ""
    var password: String = ""
    var isLoading: Bool = false

    var showHomeView: Bool = false
    var showErrorAlert: ErrorMessage?

    var isIdFieldEnalbed: Bool {
        return !isLoading
    }

    var isPasswordFieldEnabled: Bool {
        return !isLoading
    }

    var isLoginButtonEnabled: Bool {
        return !isLoading && !id.isEmpty && !password.isEmpty
    }
}

struct ErrorMessage: Equatable {
    let title: String
    let message: String
}
