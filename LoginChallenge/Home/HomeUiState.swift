//
//  HomeUiState.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import Foundation
import Entities

struct HomeUiState: UiState {
    var user: User?
    var isReloading: Bool = false
    var isLoggingOut: Bool = false
    var showErrorAlert: ErrorAlert?
    var dismiss: Bool = false

    var nameText: String {
        return user?.name ?? "User Name"
    }

    var idText: String {
        return user?.id.rawValue ?? "@ididid"
    }

    var introductionText: String {
        return user?.introduction ?? "Introduction. Introduction. Introduction. Introduction. Introduction. Introduction."
    }

    var attributedIntroductionText: AttributedString? {
        return try? AttributedString(markdown: introductionText)
    }

    var isReloadButtonEnabled: Bool {
        return !isReloading
    }

    var isLogoutButtonEnabled: Bool {
        return !isLoggingOut
    }

    var shouldShowPlaceholder: Bool {
        return user == nil
    }
}
