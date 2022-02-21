//
//  LoginViewModelTests.swift
//  LoginChallengeTests
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import XCTest
import Entities
@testable import LoginChallenge

class LoginViewModelTests: XCTestCase {

    class ResolverMock: Resolver {
        let authRepositoryMock = AuthRepositoryMock()
        override func authRepository() -> AuthRepository { authRepositoryMock }
    }

    var viewModel: LoginViewModel!
    var resolver: ResolverMock!

    override func setUpWithError() throws {
        resolver = ResolverMock()
        Resolver.instance = resolver
        viewModel = LoginViewModel()
    }

    override func tearDownWithError() throws {
        Resolver.reset()
    }

    func test_ログインボタンが無効の時はログイン処理を行わない() async throws {
        XCTAssertFalse(viewModel.state.isLoginButtonEnabled)

        resolver.authRepositoryMock.loginHandler = { (_, _) in
            XCTFail()
        }

        let result = try await publishedValues(of: viewModel.$state.map(\.isLoading).removeDuplicates()) {
            await viewModel.onLoginButtonDidTap()
        }

        XCTAssertEqual(result, [false])
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

        resolver.authRepositoryMock.loginHandler = { (_, _) in
            throw GeneralError(message: "")
        }
        await viewModel.onLoginButtonDidTap()

        XCTAssertEqual(viewModel.state.showErrorAlert, .system)
    }
}
