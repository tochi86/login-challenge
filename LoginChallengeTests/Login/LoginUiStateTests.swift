//
//  LoginUiStateTests.swift
//  LoginChallengeTests
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import XCTest
@testable import LoginChallenge

class LoginUiStateTests: XCTestCase {

    var state: LoginUiState!

    override func setUpWithError() throws {
        state = .init()
    }

    func test_ローディング中はIDとパスワード入力欄が無効化される() throws {
        state.isLoading = false
        XCTAssertTrue(state.isIdFieldEnalbed)
        XCTAssertTrue(state.isPasswordFieldEnabled)

        state.isLoading = true
        XCTAssertFalse(state.isIdFieldEnalbed)
        XCTAssertFalse(state.isPasswordFieldEnabled)
    }

    func test_IDとパスワードが両方入力されるとログインボタンが有効化される() throws {
        state.id = ""
        state.password = ""
        XCTAssertFalse(state.isLoginButtonEnabled)

        state.id = "a"
        state.password = ""
        XCTAssertFalse(state.isLoginButtonEnabled)

        state.id = ""
        state.password = "a"
        XCTAssertFalse(state.isLoginButtonEnabled)

        state.id = "a"
        state.password = "a"
        XCTAssertTrue(state.isLoginButtonEnabled)
    }

    func test_ローディング中はログインボタンが無効化される() throws {
        state.id = "a"
        state.password = "a"
        state.isLoading = false
        XCTAssertTrue(state.isLoginButtonEnabled)

        state.isLoading = true
        XCTAssertFalse(state.isLoginButtonEnabled)
    }
}
