//
//  EndpointFriendship.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 08/03/2020.
//

import Foundation

import ComposableRequest

public extension Endpoint {
    /// A module-like `enum` holding reference to `friendships` `Endpoint`s. Requires authentication.
    enum Friendship {
        /// The base endpoint.
        private static let base = Endpoint.version1.friendships.appendingDefaultHeader()

        /// A list of users followed by the user matching `identifier`.
        ///
        /// - parameters:
        ///     - identifier: A `String` holding reference to a valid user identifier.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        /// - note: This is equal to the user's **following**.
        public static func followed(by identifier: String, startingAt page: String? = nil) -> Results<Swiftagram.User.Collection> {
            // TODO: Add back pagination.
            base.path(appending: identifier)
                .following
                .finalize()
        }

        /// A list of users following the user matching `identifier`.
        ///
        /// - parameters:
        ///     - identifier: A `String` holding reference to a valid user identifier.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        /// - note: This is equal to the user's **followers**.
        public static func following(_ identifier: String, startingAt page: String? = nil) -> Results<Swiftagram.User.Collection> {
            // TODO: Add back pagination.
            base.path(appending: identifier)
                .followers
                .finalize()
        }

        /// The current friendship status between the authenticated user and the one matching `identifier`.
        ///
        /// - parameter identifier: A `String` holding reference to a valid user identifier.
        public static func summary(for identifier: String) -> Results<Swiftagram.Friendship> {
            base.show
                .path(appending: identifier)
                .finalize()
        }

        /// The current friendship status between the authenticated user and all users matching `identifiers`.
        ///
        /// - parameter identifiers: A collection of `String`s hoding reference to valid user identifiers.
        public static func summary<C: Collection>(for identifiers: C) -> Results<Swiftagram.Friendship.Dictionary> where C.Element == String {
            base.path(appending: "show_many/")
                .finalize {
                    $0.body(["user_ids": identifiers.joined(separator: ","),
                             "_csrftoken": $2["csrftoken"]!,
                             "_uuid": $2.client.device.identifier.uuidString])
                }
        }

        /// A list of users who requested to follow you, without having been processed yet.
        /// 
        /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func pendingRequests(startingAt page: String? = nil) -> Results<Swiftagram.User.Collection> {
            // TODO: Add back pagination.
            base.pending.finalize()
        }
    }
}
