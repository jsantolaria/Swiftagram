//
//  EndpointLocation.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 14/03/2020.
//

import Foundation

import ComposableRequest

public extension Endpoint {
    /// A module-like `enum` holding reference to `location` `Endpoint`s. Requires authentication.
    enum Location {
        /// Get locations around coordinates.
        ///
        /// - parameters:
        ///     - coordinates: A `CGPoint` with latitude and longitude.
        ///     - query: An optional `String` narrowing down the list. Defaults to `nil`.
        public static func around(coordinates: Swiftagram.Location.Coordinates,
                                  matching query: String? = nil) -> Results<Swiftagram.Location.Collection> {
            Endpoint.version1
                .appendingDefaultHeader()
                .path(appending: "location_search/")
                .query(["rank_token": "",
                        "latitude": "\(coordinates.latitude)",
                        "longitude": "\(coordinates.longitude)",
                        "timestamp": query == nil ? "\(Int(Date().timeIntervalSince1970*1_000))" : nil,
                        "search_query": query])
                .finalize {
                    $0.query(appending: ["_csrftoken": $2["csrftoken"]!,
                                         "_uid": $2.label,
                                         "_uuid": $2.client.device.identifier.uuidString])
                }
        }
        
        /// Get the summary for the location matching `identifier`.
        ///
        /// - parameter identifier: A valid location identifier.
        public static func summary(for identifier: String) -> Results<Swiftagram.Location.Unit> {
            Endpoint.version1
                .locations
                .path(appending: identifier)
                .path(appending: "info/")
                .finalize()
        }
        
        /// Fetch stories currently available at the location matching `identifier`.
        ///
        /// - parameter identifier: A valid location identifier.
        public static func stories(at identifier: String) -> Results<TrayItem.Unit> {
            Endpoint.version1
                .locations
                .path(appending: identifier)
                .path(appending: "story/")
                .finalize()
        }
    }
}
