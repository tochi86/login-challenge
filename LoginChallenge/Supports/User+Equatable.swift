//
//  User+Equatable.swift
//  LoginChallenge
//
//  Created by Toshiya Kobayashi on 2022/02/06.
//

import Entities

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.introduction == rhs.introduction
    }
}
