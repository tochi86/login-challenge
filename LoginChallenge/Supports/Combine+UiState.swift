//
//  Combine+UiState.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/26.
//

import Combine
import Foundation

protocol UiState: Equatable {}

extension Publisher where Self.Failure == Never, Self.Output : UiState {
    func select<T: Equatable>(_ keyPath: KeyPath<Self.Output, T>) -> AnyPublisher<T, Failure> {
        map(keyPath)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
