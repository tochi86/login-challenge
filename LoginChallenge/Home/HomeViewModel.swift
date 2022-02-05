//
//  HomeViewModel.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import SwiftUI
import Entities

@MainActor
final class HomeViewModel: ObservableObject {

    @Published private(set) var state: HomeUiState
    var showAuthenticationErrorAlert: Binding<Bool> {
        Binding(get: { self.state.showAuthenticationErrorAlert },
                set: { self.state.showAuthenticationErrorAlert = $0 })
    }
    var showNetworkErrorAlert: Binding<Bool> {
        Binding(get: { self.state.showNetworkErrorAlert },
                set: { self.state.showNetworkErrorAlert = $0 })
    }
    var showServerErrorAlert: Binding<Bool> {
        Binding(get: { self.state.showServerErrorAlert },
                set: { self.state.showServerErrorAlert = $0 })
    }
    var showSystemErrorAlert: Binding<Bool> {
        Binding(get: { self.state.showSystemErrorAlert },
                set: { self.state.showSystemErrorAlert = $0 })
    }

    private let authRepository: AuthRepository
    private let userRepository: UserRepository

    private let logger: Logger

    init(
        state: HomeUiState = .init(),
        authRepository: AuthRepository = AuthRepositoryImpl(),
        userRepository: UserRepository = UserRepositoryImpl(),
        logger: Logger = LoggerImpl(label: String(reflecting: HomeViewModel.self))
    ) {
        self.state = state
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.logger = logger
    }

    func onViewDidAppear() {
        loadUser()
    }

    func onReloadButtonDidTap() {
        loadUser()
    }

    func onLogoutButtonDidTap() {
        Task {
            state.isLoggingOut = true
            await authRepository.logout()
            state.isLoggingOut = false
            state.dismiss = true
        }
    }

    private func loadUser() {
        Task {
            do {
                state.isReloading = true
                state.user = try await userRepository.currentUser()
                state.isReloading = false
            } catch {
                state.isReloading = false
                logger.info("\(error)")

                switch error {
                case is AuthenticationError:
                    state.showAuthenticationErrorAlert = true
                case is NetworkError:
                    state.showNetworkErrorAlert = true
                case is ServerError:
                    state.showServerErrorAlert = true
                default:
                    state.showSystemErrorAlert = true
                }
            }
        }
    }
}
