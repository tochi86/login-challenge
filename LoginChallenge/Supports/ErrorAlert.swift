//
//  ErrorAlert.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import Foundation
import Entities

enum ErrorAlert {
    case login
    case network
    case server
    case system
    case authentication

    init(error: Error) {
        switch error {
        case is LoginError:
            self = .login
        case is NetworkError:
            self = .network
        case is ServerError:
            self = .server
        case is AuthenticationError:
            self = .authentication
        default:
            self = .system
        }
    }

    var title: String {
        switch self {
        case .login:
            return "ログインエラー"
        case .network:
            return "ネットワークエラー"
        case .server:
            return "サーバーエラー"
        case .system:
            return "システムエラー"
        case .authentication:
            return "認証エラー"
        }
    }

    var message: String {
        switch self {
        case .login:
            return "IDまたはパスワードが正しくありません。"
        case .network:
            return "通信に失敗しました。ネットワークの状態を確認して下さい。"
        case .server:
            return "しばらくしてからもう一度お試し下さい。"
        case .system:
            return "エラーが発生しました。"
        case .authentication:
            return "再度ログインして下さい。"
        }
    }

    var buttonTitle: String {
        switch self {
        case .login:
            return "閉じる"
        case .network:
            return "閉じる"
        case .server:
            return "閉じる"
        case .system:
            return "閉じる"
        case .authentication:
            return "OK"
        }
    }
}
