//
//  XCTestCase+Extensions.swift
//  LoginChallengeTests
//
//  Created by Toshiya Kobayashi on 2022/02/06.
//

import XCTest
import Combine

extension XCTestCase {
    func publishedValues<T: Publisher>(
        of publisher: T,
        file: StaticString = #file,
        line: UInt = #line,
        while action: () async throws -> Void
    ) async throws -> [T.Output] {
        var values: [T.Output] = []
        let cancellable = publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { value in values.append(value) }
        )
        try await action()
        cancellable.cancel()
        return values
    }
}
