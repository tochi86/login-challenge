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
        Binding(get: { self.state.showErrorAlert == .authentication },
                set: { self.state.showErrorAlert = $0 ? .authentication : nil })
    }
    var showNetworkErrorAlert: Binding<Bool> {
        Binding(get: { self.state.showErrorAlert == .network },
                set: { self.state.showErrorAlert = $0 ? .network : nil })
    }
    var showServerErrorAlert: Binding<Bool> {
        Binding(get: { self.state.showErrorAlert == .server },
                set: { self.state.showErrorAlert = $0 ? .server : nil })
    }
    var showSystemErrorAlert: Binding<Bool> {
        Binding(get: { self.state.showErrorAlert == .system },
                set: { self.state.showErrorAlert = $0 ? .system : nil })
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
                    state.showErrorAlert = .authentication
                case is NetworkError:
                    state.showErrorAlert = .network
                case is ServerError:
                    state.showErrorAlert = .server
                default:
                    state.showErrorAlert = .system
                }
            }
        }
    }
}
