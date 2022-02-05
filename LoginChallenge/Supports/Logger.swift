//
//  Logger.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/05.
//

import Logging

protocol Logger: AnyObject {
    func info(_ message: String)
}

final class LoggerImpl: Logger {

    private let logger: Logging.Logger

    init(label: String) {
        logger = .init(label: label)
    }

    func info(_ message: String) {
        logger.info(.init(stringLiteral: message))
    }
}
