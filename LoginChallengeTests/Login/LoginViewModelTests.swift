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

    func test_ログイン失敗時にエラーアラートを表示する() async throws {
        viewModel.onInputFieldValueChanged(id: "a", password: "a")
        XCTAssertNil(viewModel.state.showErrorAlert)

        authRepository.loginHandler = { (_, _) in
            throw GeneralError(message: "")
        }
        await viewModel.onLoginButtonDidTap()

        XCTAssertEqual(viewModel.state.showErrorAlert, .system)
    }
}
