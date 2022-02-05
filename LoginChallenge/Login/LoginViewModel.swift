//
//  LoginViewModel.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/01/22.
//

import Foundation
import Combine
import Entities

@MainActor
final class LoginViewModel: ObservableObject {

    @Published private(set) var state: LoginUiState

    private let authRepository: AuthRepository

    private let logger: Logger

    init(
        state: LoginUiState = .init(),
        authRepository: AuthRepository = AuthRepositoryImpl(),
        logger: Logger = LoggerImpl(label: String(reflecting: LoginViewModel.self))
    ) {
        self.state = state
        self.authRepository = authRepository
        self.logger = logger
    }

    func onInputFieldValueChanged(id: String, password: String) {
        state.id = id
        state.password = password
    }

    func onLoginButtonDidTap() async {
        do {
            state.isLoading = true
            try await authRepository.login(id: state.id, password: state.password)
            state.isLoading = false
            state.showHomeView = true
        } catch {
            state.isLoading = false
            logger.info("\(error)")

            switch error {
            case is LoginError:
                state.showErrorAlert = .login
            case is NetworkError:
                state.showErrorAlert = .network
            case is ServerError:
                state.showErrorAlert = .server
            default:
                state.showErrorAlert = .system
            }
        }
    }

    func onErrorAlertDidShow() {
        state.showErrorAlert = nil
    }

    func onHomeViewDidShow() {
        state.showHomeView = false
    }
}
