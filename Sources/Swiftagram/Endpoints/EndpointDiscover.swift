//
//  EndpointExplore.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 14/03/2020.
//

import Foundation

import ComposableRequest

public extension Endpoint {
    /// A module-like `enum` holding reference to `discover` `Endpoint`s. Requires authentication.
    enum Discover {
        /// The base endpoint.
        private static let base = Endpoint.version1.discover.appendingDefaultHeader()

        /// Suggested users.
        ///
        /// - parameter identifier: A `String` holding reference to a valid user identifier.
        public static func users(like identifier: String) -> Results<Swiftagram.User.Collection> {
            base.chaining
                .query(appending: identifier, forKey: "target_id")
                .finalize()
        }
        
        /// The explore feed.
        ///
        /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func explore(startingAt page: String? = nil) -> Results<Wrapper> {
            // TODO: Add back pagination
            base.explore.finalize()
        }

        /// The topical explore feed.
        /// 
        /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func topics(startingAt page: String? = nil) -> Results<Wrapper> {
            // TODO: Add back pagination
            base.topical_explore
                .finalize { $0.query(appending: ["is_prefetch": "true",
                                                 "omit_cover_media": "false",
                                                 "use_sectional_payload": "true",
                                                 "timezone_offset": "43200",
                                                 "session_id": $2["sessionid"]!,
                                                 "include_fixed_destinations": "false"]) }
        }
    }
}
