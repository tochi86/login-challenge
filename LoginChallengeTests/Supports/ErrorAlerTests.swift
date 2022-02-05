//
//  ErrorAlerTests.swift
//  LoginChallengeTests
//
//  Created by Toshiya Kobayashi on 2022/02/06.
//

import XCTest
import Entities
@testable import LoginChallenge

class ErrorAlerTests: XCTestCase {

    func test_ログインエラー() throws {
        let error = LoginError()
        XCTAssertEqual(ErrorAlert(error: error), .login)
    }

    func test_ネットワークエラー() throws {
        let error = NetworkError(cause: GeneralError(message: "Timeout."))
        XCTAssertEqual(ErrorAlert(error: error), .network)
    }

    func test_サーバーエラー() throws {
        let error = ServerError.internal(cause: GeneralError(message: "Rate limit exceeded."))
        XCTAssertEqual(ErrorAlert(error: error), .server)
    }

    func test_システムエラー() throws {
        let error = GeneralError(message: "System error.")
        XCTAssertEqual(ErrorAlert(error: error), .system)
    }

    func test_認証エラー() throws {
        let error = AuthenticationError()
        XCTAssertEqual(ErrorAlert(error: error), .authentication)
    }
}
