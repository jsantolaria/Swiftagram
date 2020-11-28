//
//  EndpointFriendship.swift
//  SwiftagramCrypto
//
//  Created by Stefano Bertagno on 08/03/2020.
//

import Foundation

import ComposableRequest
import Swiftagram

public extension Endpoint.Friendship {
    /// The base endpoint.
    private static let base = Endpoint.version1.friendships.appendingDefaultHeader()

    /// Perform an action involving the user matching `identifier`.
    ///
    /// - parameters:
    ///     - transformation: A `KeyPath` defining the endpoint path.
    ///     - identifier: A `String` holding reference to a valid user identifier.
    /// - note: **SwiftagramCrypto** only.
    private static func edit(_ keyPath: KeyPath<Request, Request>, _ identifier: String) -> Endpoint.Results<Status> {
        base[keyPath: keyPath]
            .path(appending: identifier)
            .path(appending: "/")
            .finalize {
                $0.signing(body: ["_csrftoken": $2["csrftoken"],
                                  "user_id": identifier,
                                  "radio_type": "wifi-none",
                                  "_uid": $2.label,
                                  "device_id": $2.client.device.instagramIdentifier,
                                  "_uuid": $2.client.device.identifier.uuidString])
        }
    }

    /// Follow (or send a follow request) the user matching `identifier`.
    ///
    /// - parameter identifier: A `String` holding reference to a valid user identifier.
    /// - note: **SwiftagramCrypto** only.
    static func follow(_ identifier: String) -> Endpoint.Results<Status> {
        edit(\.create, identifier)
    }

    /// Unfollow the user matching `identifier`.
    ///
    /// - parameter identifier: A `String` holding reference to a valid user identifier.
    /// - note: **SwiftagramCrypto** only.
    static func unfollow(_ identifier: String) -> Endpoint.Results<Status> {
        edit(\.destroy, identifier)
    }

    /// Remove a user following you, matching the `identifier`. Said user will stop following you.
    ///
    /// - parameter identifier: A `String` holding reference to a valid user identifier.
    /// - note: **SwiftagramCrypto** only.
    static func remove(follower identifier: String) -> Endpoint.Results<Status> {
        edit(\.remove_follower, identifier)
    }

    /// Accept a follow request from the user matching `identifier`.
    ///
    /// - parameter identifier: A `String` holding reference to a valid user identifier.
    /// - note: **SwiftagramCrypto** only.
    static func acceptRequest(from identifier: String) -> Endpoint.Results<Status> {
        edit(\.approve, identifier)
    }

    /// Reject a follow request from the user matching `identifier`.
    ///
    /// - parameter identifier: A `String` holding reference to a valid user identifier.
    /// - note: **SwiftagramCrypto** only.
    static func rejectRequest(from identifier: String) -> Endpoint.Results<Status> {
        edit(\.reject, identifier)
    }

    /// Block the user matching `identifier`.
    ///
    /// - parameter identifier: A `String` holding reference to a valid user identifier.
    /// - note: **SwiftagramCrypto** only.
    static func block(_ identifier: String) -> Endpoint.Results<Status> {
        edit(\.block, identifier)
    }

    /// Unblock the user matching `identifier`.
    ///
    /// - parameter identifier: A `String` holding reference to a valid user identifier.
    /// - note: **SwiftagramCrypto** only.
    static func unblock(_ identifier: String) -> Endpoint.Results<Status> {
        edit(\.unblock, identifier)
    }
}
