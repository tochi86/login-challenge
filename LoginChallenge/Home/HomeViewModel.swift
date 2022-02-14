//
//  HomeViewModel.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import SwiftUI

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

    init(
        state: HomeUiState = .init(),
        authRepository: AuthRepository = DIContainer.default.authRepository(),
        userRepository: UserRepository = DIContainer.default.userRepository()
    ) {
        self.state = state
        self.authRepository = authRepository
        self.userRepository = userRepository
    }

    func onViewDidAppear() async {
        await loadUser()
    }

    func onReloadButtonDidTap() async {
        guard state.isReloadButtonEnabled else { return }
        await loadUser()
    }

    func onLogoutButtonDidTap() async {
        guard state.isLogoutButtonEnabled else { return }
        state.isLoggingOut = true
        await authRepository.logout()
        state.isLoggingOut = false
        state.dismiss = true
    }

    private func loadUser() async {
        do {
            state.isReloading = true
            state.user = try await userRepository.currentUser()
            state.isReloading = false
        } catch {
            logger.info("\(error)")
            state.isReloading = false
            state.showErrorAlert = ErrorAlert(error: error)
        }
    }
}
