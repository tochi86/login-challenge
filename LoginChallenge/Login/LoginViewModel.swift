//
//  LoginViewModel.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/01/22.
//

import Foundation
import Combine
import Entities
import Logging

@MainActor
final class LoginViewModel: ObservableObject {

    @Published private(set) var state: LoginUiState

    private let authRepository: AuthRepository

    // String(reflecting:) はモジュール名付きの型名を取得するため。
    private let logger: Logger = .init(label: String(reflecting: LoginViewModel.self))

    init(
        state: LoginUiState = .init(),
        authRepository: AuthRepository = AuthRepositoryImpl()
    ) {
        self.state = state
        self.authRepository = authRepository
    }

    func onInputFieldValueChanged(id: String, password: String) {
        state.id = id
        state.password = password
    }

    func onLoginButtonDidTap() {
        Task {
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
                    state.showErrorAlert = .init(title: "ログインエラー",
                                                 message: "IDまたはパスワードが正しくありません。")
                case is NetworkError:
                    state.showErrorAlert = .init(title: "ネットワークエラー",
                                                 message: "通信に失敗しました。ネットワークの状態を確認して下さい。")
                case is ServerError:
                    state.showErrorAlert = .init(title: "サーバーエラー",
                                                 message: "しばらくしてからもう一度お試し下さい。")
                default:
                    state.showErrorAlert = .init(title: "システムエラー",
                                                 message: "エラーが発生しました。")
                }
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
