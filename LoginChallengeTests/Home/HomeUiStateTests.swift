//
//  HomeUiStateTests.swift
//  LoginChallengeTests
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import XCTest
import Entities
@testable import LoginChallenge

class HomeUiStateTests: XCTestCase {

    var state: HomeUiState!

    override func setUpWithError() throws {
        state = HomeUiState()
    }

    func test_リロード中はリロードボタンが無効化される() throws {
        state.isReloading = false
        XCTAssertTrue(state.isReloadButtonEnabled)

        state.isReloading = true
        XCTAssertFalse(state.isReloadButtonEnabled)
    }

    func test_ログアウト処理中はログアウトボタンが無効化される() throws {
        state.isLoggingOut = false
        XCTAssertTrue(state.isLogoutButtonEnabled)

        state.isLoggingOut = true
        XCTAssertFalse(state.isLogoutButtonEnabled)
    }

    func test_ユーザー情報が読み込まれるまではプレースホルダーを表示する() throws {
        state.user = nil
        XCTAssertTrue(state.shouldShowPlaceholder)

        state.user = User(id: User.ID(rawValue: "a"), name: "a", introduction: "a")
        XCTAssertFalse(state.shouldShowPlaceholder)
    }
}
