//
//  LoginViewModelTests.swift
//  LoginChallengeTests
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import XCTest
import Entities
@testable import LoginChallenge

@MainActor
class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!

    var authRepository: AuthRepositoryMock!
    var logger: LoggerMock!

    @MainActor override func setUpWithError() throws {
        authRepository = .init()
        logger = .init()
        viewModel = .init(authRepository: authRepository, logger: logger)
    }

    func test_ログイン処理中はローディング中状態になりログイン完了後は非ローディング状態になる() async throws {
        viewModel.onInputFieldValueChanged(id: "a", password: "a")

        let result = try await publishedValues(of: viewModel.$state.map(\.isLoading).removeDuplicates()) {
            await viewModel.onLoginButtonDidTap()
        }

        XCTAssertEqual(result, [false, true, false])
    }

    func test_ログイン完了するとホーム画面に遷移する() async throws {
        viewModel.onInputFieldValueChanged(id: "a", password: "a")
        XCTAssertFalse(viewModel.state.showHomeView)

        await viewModel.onLoginButtonDidTap()

        XCTAssertTrue(viewModel.state.showHomeView)
    }

    func test_ログイン失敗時にログインエラーを表示する() async throws {
        viewModel.onInputFieldValueChanged(id: "a", password: "a")
        XCTAssertNil(viewModel.state.showErrorAlert)

        authRepository.loginHandler = { (_, _) in
            throw LoginError()
        }
        await viewModel.onLoginButtonDidTap()

        XCTAssertEqual(viewModel.state.showErrorAlert, .login)
    }

    func test_ログイン失敗時にネットワークエラーを表示する() async throws {
        viewModel.onInputFieldValueChanged(id: "a", password: "a")
        XCTAssertNil(viewModel.state.showErrorAlert)

        authRepository.loginHandler = { (_, _) in
            throw NetworkError(cause: GeneralError(message: "Timeout."))
        }
        await viewModel.onLoginButtonDidTap()

        XCTAssertEqual(viewModel.state.showErrorAlert, .network)
    }

    func test_ログイン失敗時にサーバーエラーを表示する() async throws {
        viewModel.onInputFieldValueChanged(id: "a", password: "a")
        XCTAssertNil(viewModel.state.showErrorAlert)

        authRepository.loginHandler = { (_, _) in
            throw ServerError.internal(cause: GeneralError(message: "Rate limit exceeded."))
        }
        await viewModel.onLoginButtonDidTap()

        XCTAssertEqual(viewModel.state.showErrorAlert, .server)
    }

    func test_ログイン失敗時にシステムエラーを表示する() async throws {
        viewModel.onInputFieldValueChanged(id: "a", password: "a")
        XCTAssertNil(viewModel.state.showErrorAlert)

        authRepository.loginHandler = { (_, _) in
            throw GeneralError(message: "System error.")
        }
        await viewModel.onLoginButtonDidTap()

        XCTAssertEqual(viewModel.state.showErrorAlert, .system)
    }
}
