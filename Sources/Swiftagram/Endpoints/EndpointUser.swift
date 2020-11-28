//
//  EndpointUser.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 08/03/2020.
//

import Foundation

import ComposableRequest

public extension Endpoint {
    /// A module-like `enum` holding reference to `users` `Endpoint`s. Requires authentication.
    enum User {
        /// The base endpoint.
        private static let base = Endpoint.version1.users.appendingDefaultHeader()

        /// A list of all profiles blocked by the user.
        public static let blocked: Results<Wrapper> = base.blocked_list.finalize()

        /// A user matching `identifier`'s info.
        /// 
        /// - parameter identifier: A `String` holding reference to a valid user identifier.
        public static func summary(for identifier: String) -> Results<Swiftagram.User.Unit> {
            base.path(appending: identifier)
                .info
                .finalize()
        }

        /// All user matching `query`.
        ///
        /// - parameters:
        ///     - query: A `String` holding reference to a valid user query.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func all(matching query: String, startingAt page: String? = nil) -> Results<Swiftagram.User.Collection> {
            // TODO: Add back pagination.
            base.search
                .query(appending: query, forKey: "q")
                .finalize()
        }
    }
}
