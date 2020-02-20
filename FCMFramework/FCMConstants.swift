//
//  FCMConstants.swift
//  Alamofire
//
//  Created by Dmitry Lernatovich on 20.02.2020.
//

import UIKit

// ================================================================================================================
// MARK: - Constants
// ================================================================================================================
/// Constants structure
struct FCMConstants {
    // Notifications
    /// Instance of the {@link Notification.Name}
    static var notificationUpdate: Notification.Name { return "42cekbn9o2x8mvyd2528zym5xoamcevugtjmvz6j".name }
    /// Instance of the {@link Notification.Name}
    static var notificationRecieved: Notification.Name { return "8kkwpxtzd86h94yqpkv5x6ut75q478vcvxtpv5ao".name }
    /// Instance of the {@link Notification.Name}
    static var notificationReaded: Notification.Name { return "g4buut6cncbgxkpu6he3qme366xgpe8w2bmsm9hz".name }
    /// {@link String} value of the message key
    static var notificationMessageKey: String { return "wjdomge4kye33p65n2i6yinfj9p63e36kvm35y3f" }
    /// Array of the notifications
    static var allNotifications: [Notification.Name] { return [notificationUpdate, notificationRecieved, notificationReaded] }
    /// Message id key
    static var messageIdKey: String { return "gcm.message_id" }
    /// Auth options
    static var authOptions: UNAuthorizationOptions { return [.alert, .badge, .sound] }
    /// Alert options
    static var alertOptions: UNNotificationPresentationOptions { return [.alert, .badge, .sound] }
}
