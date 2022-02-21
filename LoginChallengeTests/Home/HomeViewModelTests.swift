//
//  HomeViewModelTests.swift
//  LoginChallengeTests
//
//  Created by Toshiya Kobayashi on 2022/02/06.
//

import XCTest
import Entities
@testable import LoginChallenge

class HomeViewModelTests: XCTestCase {

    class ResolverMock: Resolver {
        let authRepositoryMock = AuthRepositoryMock()
        override func authRepository() -> AuthRepository { authRepositoryMock }

        let userRepositoryMock = UserRepositoryMock()
        override func userRepository() -> UserRepository { userRepositoryMock }
    }

    var viewModel: HomeViewModel!
    var resolver: ResolverMock!

    override func setUpWithError() throws {
        resolver = ResolverMock()
        Resolver.instance = resolver
        viewModel = HomeViewModel()

        resolver.userRepositoryMock.currentUserHandler = { self.dummyUser }
    }

    override func tearDownWithError() throws {
        Resolver.reset()
    }

    func test_ユーザー情報読み込み中はリロード中フラグが立つ() async throws {
        let result = try await publishedValues(of: viewModel.$state.map(\.isReloading).removeDuplicates()) {
            await viewModel.onViewDidAppear()
        }

        XCTAssertEqual(result, [false, true, false])
        XCTAssertEqual(viewModel.state.user, dummyUser)
    }

    func test_画面表示時に読み込み失敗した後にリロードできる() async throws {
        resolver.userRepositoryMock.currentUserHandler = { throw GeneralError(message: "") }
        let result1 = try await publishedValues(of: viewModel.$state.map(\.isReloading).removeDuplicates()) {
            await viewModel.onViewDidAppear()
        }

        XCTAssertEqual(result1, [false, true, false])
        XCTAssertNil(viewModel.state.user)
        XCTAssertEqual(viewModel.state.showErrorAlert, .system)

        // アラートを閉じる
        viewModel.showSystemErrorAlert.wrappedValue = false
        XCTAssertNil(viewModel.state.showErrorAlert)

        resolver.userRepositoryMock.currentUserHandler = { self.dummyUser }
        let result2 = try await publishedValues(of: viewModel.$state.map(\.isReloading).removeDuplicates()) {
            await viewModel.onReloadButtonDidTap()
        }

        XCTAssertEqual(result2, [false, true, false])
        XCTAssertEqual(viewModel.state.user, dummyUser)
    }

    func test_ログアウト完了するとホーム画面を閉じる() async throws {
        XCTAssertFalse(viewModel.state.dismiss)

        let result = try await publishedValues(of: viewModel.$state.map(\.isLoggingOut).removeDuplicates()) {
            await viewModel.onLogoutButtonDidTap()
        }

        XCTAssertEqual(result, [false, true, false])
        XCTAssertTrue(viewModel.state.dismiss)
    }

    func test_リロードボタンが無効の時はリロード処理を行わない() async throws {
        viewModel = HomeViewModel(state: HomeUiState(isReloading: true))
        XCTAssertFalse(viewModel.state.isReloadButtonEnabled)

        resolver.userRepositoryMock.currentUserHandler = {
            XCTFail()
            fatalError()
        }

        let result = try await publishedValues(of: viewModel.$state.map(\.isReloading).removeDuplicates()) {
            await viewModel.onReloadButtonDidTap()
        }

        XCTAssertEqual(result, [true])
    }

    func test_ログアウトボタンが無効の時はログアウト処理を行わない() async throws {
        viewModel = HomeViewModel(state: HomeUiState(isLoggingOut: true))
        XCTAssertFalse(viewModel.state.isLogoutButtonEnabled)

        resolver.authRepositoryMock.logoutHandler = { XCTFail() }

        let result = try await publishedValues(of: viewModel.$state.map(\.isLoggingOut).removeDuplicates()) {
            await viewModel.onLogoutButtonDidTap()
        }

        XCTAssertEqual(result, [true])
    }

    private var dummyUser: User {
        return User(id: User.ID(rawValue: "a"), name: "a", introduction: "a")
    }
}
