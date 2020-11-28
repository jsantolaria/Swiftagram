//
//  EndpointDirect.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 08/03/2020.
//

import Foundation

import ComposableRequest

public extension Endpoint {
    /// A module-like `enum` holding reference to `direct_v2` `Endpoint`s. Requires authentication.
    enum Direct {
        /// The base endpoint.
        private static let base = Endpoint.version1.direct_v2.appendingDefaultHeader()

        /// All threads.
        ///
        /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func inbox(startingAt page: String? = nil) -> Results<Conversation.Collection> {
            // TODO: Add back pagination.
            base.inbox
                .query(appending: ["visual_message_return_type": "unseen",
                                   "direction": page.flatMap { _ in "older" },
                                   "thread_message_limit": "10",
                                   "persistent_badging": "true",
                                   "limit": "20"])
                .finalize()
        }

        /// All pending threads.
        ///
        /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func pendingInbox(startingAt page: String? = nil) -> Results<Conversation.Collection> {
            // TODO: Add back pagination.
            base.path(appending: "pending_inbox")
                .query(["visual_message_return_type": "unseen",
                        "direction": page.flatMap { _ in "older" },
                        "thread_message_limit": "10",
                        "persistent_badging": "true",
                        "limit": "20"])
                .finalize()
        }

        /// Top ranked recipients matching `query`.
        ///
        /// - parameter query: An optional `String`.
        public static func recipients(matching query: String? = nil) -> Results<Recipient.Collection> {
            // TODO: Add back pagination.
            base.path(appending: "ranked_recipients/")
                .header(["mode": "raven",
                         "query": query ?? "",
                         "show_threads": "true"])
                .finalize()
        }

        /// A thread matching `identifier`.
        /// 
        /// - parameters:
        ///     - identifier: A `String` holding reference to a valid thread identifier.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func conversation(matching identifier: String,
                                        startingAt page: String? = nil) -> Results<Conversation.Unit> {
            // TODO: Add back pagination.
            base.threads
                .path(appending: identifier)
                .query(["visual_message_return_type": "unseen",
                        "direction": "older",
                        "limit": "20"])
                .finalize()
        }

        /// Get user presence.
        public static let presence: Results<Wrapper> = base.path(appending: "get_presence/").finalize()
    }
}
