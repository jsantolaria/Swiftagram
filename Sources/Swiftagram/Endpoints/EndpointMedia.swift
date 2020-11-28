//
//  EndpointMedia.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 14/03/2020.
//

import Foundation

import ComposableRequest

public extension Endpoint {
    /// A module-like `enum` holding reference to `media` `Endpoint`s. Requires authentication.
    enum Media {
        /// The base endpoint.
        private static let base = Endpoint.version1.media.appendingDefaultHeader()

        /// A media matching `identifier`'s info.
        ///
        /// - parameter identifier: A `String` holding reference to a valid media identifier.
        public static func summary(for identifier: String) -> Results<Swiftagram.Media.Collection> {
            base.path(appending: identifier)
                .info
                .finalize()
        }

        /// The permalinkg for the media matching `identifier`.
        ///
        /// - parameter identifier: A `String` holding reference to a valid media identifier.
        public static func permalink(for identifier: String) -> Results<Wrapper> {
            base.path(appending: identifier)
                .permalink
                .finalize()
        }
    }
}

public extension Endpoint.Media {
    /// A module-like `enum` holding reference to `media` `Endpoint`s reguarding posts. Requires authentication.
    enum Posts {
        /// A list of all users liking the media matching `identifier`.
        ///
        /// - parameters:
        ///     - identifier: A `String` holding reference to a valid post media identifier.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func likers(for identifier: String, startingAt page: String? = nil) -> Endpoint.Results<Swiftagram.User.Collection> {
            // TODO: Add back pagination.
            base.path(appending: identifier)
                .likers
                .finalize()
        }

        /// A list of all comments the media matching `identifier`.
        ///
        /// - parameters:
        ///     - identifier: A `String` holding reference to a valid post media identifier.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func comments(for identifier: String, startingAt page: String? = nil) -> Endpoint.Results<Comment.Collection> {
            // TODO: Add back pagination.
            base.path(appending: identifier)
                .comments
                .finalize()
        }

        /// Save the media metching `identifier`.
        ///
        /// - parameter identifier: A `String` holding reference to a valid media identifier.
        public static func save(_ identifier: String) -> Endpoint.Results<Status> {
            base.path(appending: identifier)
                .path(appending: "save/")
                .method(.post)
                .finalize()
        }

        /// Unsave the media metching `identifier`.
        ///
        /// - parameter identifier: A `String` holding reference to a valid media identifier.
        public static func unsave(_ identifier: String) -> Endpoint.Results<Status> {
            base.path(appending: identifier)
                .path(appending: "unsave/")
                .method(.post)
                .finalize()
        }

        /// Like the comment matching `identifier`.
        ///
        /// - parameter identifier: A `String` holding reference to a valid comment identfiier.
        public static func like(comment identifier: String) -> Endpoint.Results<Status> {
            base.path(appending: identifier)
                .path(appending: "comment_like/")
                .method(.post)
                .finalize()
        }

        /// Unlike the comment matching `identifier`.
        ///
        /// - parameter identifier: A `String` holding reference to a valid comment identfiier.
        public static func unlike(comment identifier: String) -> Endpoint.Results<Status> {
            base.path(appending: identifier)
                .path(appending: "comment_unlike/")
                .method(.post)
                .finalize()
        }

        /// Liked media.
        ///
        /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func liked(startingAt page: String? = nil) -> Endpoint.Results<Swiftagram.Media.Collection> {
            // TODO: Add back pagination.
            Endpoint.version1.feed
                .appendingDefaultHeader()
                .liked
                .finalize()
        }

        /// All saved media.
        ///
        /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func saved(startingAt page: String? = nil) -> Endpoint.Results<Swiftagram.Media.Collection> {
            // TODO: Add back pagination.
            Endpoint.version1.feed
                .appendingDefaultHeader()
                .saved
                .header(appending: "false", forKey: "include_igtv_preview")
                .finalize()
        }

        /// All archived media.
        ///
        /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func archived(startingAt page: String? = nil) -> Endpoint.Results<Swiftagram.Media.Collection> {
            // TODO: Add back pagination.
            Endpoint.version1.feed
                .path(appending: "only_me_feed/")
                .appendingDefaultHeader()
                .finalize()
        }

        /// All posts for user matching `identifier`.
        ///
        /// - parameters:
        ///     - identifier: A `String` holding reference to a valid user identifier.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func owned(by identifier: String, startingAt page: String? = nil) -> Endpoint.Results<Swiftagram.Media.Collection> {
            // TODO: Add back pagination.
            Endpoint.version1.feed
                .user
                .path(appending: identifier)
                .appendingDefaultHeader()
                .finalize()
        }

        /// All posts a user matching `identifier` is tagged in.
        ///
        /// - parameters
        ///     - identifier: A `String` holding reference to a valid user identifier.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func including(_ identifier: String, startingAt page: String? = nil) -> Endpoint.Results<Swiftagram.Media.Collection> {
            // TODO: Add back pagination.
            Endpoint.version1.usertags
                .path(appending: identifier)
                .feed
                .appendingDefaultHeader()
                .finalize()
        }

        /// All media matching `tag`.
        ///
        /// - parameters:
        ///     - tag: A `String` holding reference to a valid _#tag_.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func tagged(with tag: String, startingAt page: String? = nil) -> Endpoint.Results<Swiftagram.Media.Collection> {
            // TODO: Add back pagination.
            Endpoint.version1.feed
                .tag
                .path(appending: tag)
                .appendingDefaultHeader()
                .finalize()
        }

        /// Timeline.
        ///
        /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func timeline(startingAt page: String? = nil) -> Endpoint.Results<Wrapper> {
            // TODO: Add back pagination.
            Endpoint.version1.feed
                .appendingDefaultHeader()
                .path(appending: "timeline/")
                .finalize {
                    $0.header(appending: ["X-Ads-Opt-Out": "0",
                                          "X-Google-AD-ID": $2.client.device.adIdentifier.uuidString,
                                          "X-DEVICE-ID": $2.client.device.identifier.uuidString,
                                          "X-FB": "1"])
                        .body(appending: ["is_prefetch": "0",
                                          "feed_view_info": "",
                                          "seen_posts": "",
                                          "phone_id": $2.client.device.phoneIdentifier.uuidString,
                                          "is_pull_to_refresh": "0",
                                          "battery_level": "72",
                                          "timezone_offset": "43200",
                                          "_csrftoken": $2["csrftoken"]!,
                                          "client_session_id": $2["sessionid"]!,
                                          "device_id": $2.client.device.identifier.uuidString,
                                          "_uuid": $2.client.device.identifier.uuidString,
                                          "is_charging": "0",
                                          "is_async_ads_in_headload_enabled": "0",
                                          "rti_delivery_backend": "0",
                                          "is_async_ads_double_request": "0",
                                          "will_sound_on": "0",
                                          "is_async_ads_rti": "0"])
                }
        }
    }
}

public extension Endpoint.Media {
    /// A module-like `enum` holding reference to `media` `Endpoint`s reguarding stories. Requires authentication.
    enum Stories {
        /// Stories tray.
        public static let followed: Endpoint.Results<TrayItem.Collection> = Endpoint.version1.feed
            .reels_tray
            .appendingDefaultHeader()
            .finalize()
        
        /// Return the highlights tray for a specific user.
        ///
        /// - parameter identifier: A `String` holding reference to a valid user identifier.
        /// - warning: This method will be removed in `4.2.0`.
        public static func highlights(for identifier: String) -> Endpoint.Results<TrayItem.Collection> {
            Endpoint.version1.highlights
                .path(appending: identifier)
                .highlights_tray
                .appendingDefaultHeader()
                .finalize {
                    $0.query(["supported_capabilities_new": try? SupportedCapabilities
                                .default
                                .map { ["name": $0.key, "value": $0.value] }
                                .wrapped
                                .jsonRepresentation(),
                            "phone_id": $2.client.device.phoneIdentifier.uuidString,
                            "battery_level": "72",
                            "is_charging": "0",
                            "will_sound_on": "0"])
                }
        }

        /// A list of all viewers for the story matching `identifier`.
        ///
        /// - parameters:
        ///     - identifier: A `String` holding reference to a valid post media identifier.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func viewers(for identifier: String, startingAt page: String? = nil) -> Endpoint.Results<Swiftagram.User.Collection> {
            // TODO: Add back pagination.
            base.path(appending: identifier)
                .path(appending: "list_reel_media_viewer")
                .finalize()
        }

        /// Archived stories.
        ///
        /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func archived(startingAt page: String? = nil) -> Endpoint.Results<TrayItem.Collection> {
            // TODO: Add back pagination.
            Endpoint.version1
                .archive
                .reel
                .day_shells
                .appendingDefaultHeader()
                .finalize()
        }

        /// All available stories for user matching `identifier`.
        ///
        /// - parameter identifier: A `String` holding reference to a valid user identifier.
        public static func owned(by identifier: String) -> Endpoint.Results<TrayItem.Unit> {
            Endpoint.version1.feed
                .user
                .path(appending: identifier)
                .reel_media
                .appendingDefaultHeader()
                .finalize()
        }

        /// All available stories for user matching `identifiers`.
        /// 
        /// - parameters identifiers: A `Collection` of `String`s holding reference to valud user identifiers.
        public static func owned<C: Collection>(by identifiers: C) -> Endpoint.Results<TrayItem.Dictionary> where C.Element == String {
            try! Endpoint.version1.feed
                .path(appending: "reels_media/")
                .appendingDefaultHeader()
                .body(["user_ids": try? Array(identifiers).wrapped.jsonRepresentation()])
                .finalize()
        }
    }
}
