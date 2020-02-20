//
//  FCMStorage.swift
//  Alamofire
//
//  Created by Dmitry Lernatovich on 20.02.2020.
//

import UIKit

/// Protocol which provide the FCM storage
public protocol FCMStorage: AnyObject { }

// FCMStorage
/// Extension which provide the storage variables
public extension FCMStorage {
    // APNS Token
    /// {@link String} value of the APNS token
    var apnsToken: String? { return FCMInternalStorage.shared.token }
    // FCM Token
    /// {@link String} value of the FCM token
    var fcmToken: String? { return FCMInternalStorage.shared.fcmToken }
    // Arrays
    /// Notifications array
    var fcmNotifications: [FCMModel] { return FCMInternalStorage.shared.models?.array ?? [] }
    /// Readed notifications array
    var fcmReadedNotifications: [FCMModel] { return fcmNotifications.filter({$0.isReaded == true}) }
    /// Unreaded notifications array
    var fcmUnreadedNotifications: [FCMModel] { return fcmNotifications.filter({$0.isReaded == false}) }
    // Count
    /// {@link Int} value of the readed notifications
    var fcmAllCount: Int { return fcmNotifications.count }
    /// {@link Int} value of the readed notifications
    var fcmReadedCount: Int { return fcmReadedNotifications.count }
    /// {@link Int} value of the unreaded notifications
    var fcmUnreadedCount: Int { return fcmUnreadedNotifications.count }
}
