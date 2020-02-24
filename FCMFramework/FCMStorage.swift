//
//  Created by Dmitry Lernatovich on 14.02.2020.
//  Copyright © 2020 Dmitry Lernatovich. All rights reserved.
//

import UIKit

// ================================================================================================================
// MARK: - Protocol
// ================================================================================================================
/// Protocol which provide the FCM storage
public protocol FCMStorage: AnyObject { }

// ================================================================================================================
// MARK: - Variables
// ================================================================================================================
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

// ================================================================================================================
// MARK: - Clear
// ================================================================================================================
/// Extension which provide the clearing of the cached notifications
public extension FCMStorage {
    /// Method which provide the clearing of the cached notifications
    /// - Parameter notify: if it need notification
    func fcmClear(notify: Bool = true) { FCMInternalStorage.shared.clear(notify: notify) }
}

// ================================================================================================================
// MARK: - Update
// ================================================================================================================
/// Extension which provide the update of the reade state
public extension FCMStorage {
    /// Method which provide the modify readed state for the message
    /// - Parameters:
    ///   - id: {@link String} value of the ID
    ///   - isReaded: {@link Bool} value if it readed
    ///   - notify: if it need notification
    func fcmUpdate(withId id: String?, andReaded isReaded: Bool, notify: Bool = true) {
        FCMInternalStorage.shared.updateReadedState(withId: id, andState: isReaded, notify: notify);
    }
    
    /// Method which provide the updating models
    /// - Parameters:
    ///   - model: instance of the {@link FCMModel}
    ///   - notify: if it need notification
    func fcmUpdate(model: FCMModel?, notify: Bool = true) {
        FCMInternalStorage.shared.update(model: model, notify: notify);
    }
}

// ================================================================================================================
// MARK: - Tags
// ================================================================================================================
/// Notifications with tags performing
public extension FCMStorage {
    /// Method which provide the get all notifications with tags
    /// - Parameter tags: array of tags
    func fcmNotifications(tags: [String]?, needUntagged: Bool = false) -> [FCMModel] {
        return FCMInternalStorage.shared.search(by: tags, needUntagged: needUntagged);
    }
    /// Method which provide the get all notifications with tags
    /// - Parameter tags: array of tags
    func fcmReadedNotifications(tags: [String]?, needUntagged: Bool = false) -> [FCMModel] {
        return fcmNotifications(tags: tags, needUntagged: needUntagged).filter({$0.isReaded == true});
    }
    /// Method which provide the get all notifications with tags
    /// - Parameter tags: array of tags
    func fcmUnreadedNotifications(tags: [String]?, needUntagged: Bool = false) -> [FCMModel] {
        return fcmNotifications(tags: tags, needUntagged: needUntagged).filter({$0.isReaded == false});
    }
    /// Method which provide the get all notifications with tags
    /// - Parameter tags: array of tags
    func fcmAllCount(tags: [String]?, needUntagged: Bool = false) -> Int {
        return fcmNotifications(tags: tags, needUntagged: needUntagged).count;
    }
    /// Method which provide the get all notifications with tags
    /// - Parameter tags: array of tags
    func fcmReadedCount(tags: [String]?, needUntagged: Bool = false) -> Int {
        return fcmReadedNotifications(tags: tags, needUntagged: needUntagged).count;
    }
    /// Method which provide the get all notifications with tags
    /// - Parameter tags: array of tags
    func fcmUnreadedCount(tags: [String]?, needUntagged: Bool = false) -> Int {
        return fcmUnreadedNotifications(tags: tags, needUntagged: needUntagged).count;
    }
    /// Method which provide the remove models by tags
    /// - Parameter tags: array of the tags
    func fcmRemove(by tags: [String]?) -> [FCMModel] {
        return FCMInternalStorage.shared.remove(by: tags);
    }
}

// ================================================================================================================
// MARK: - Tags managements
// ================================================================================================================
public extension FCMStorage {
    /// Method which provide the adding of the tags
    /// - Parameter tags: array of the tags
    func fcmAdd(tags: [String]?) { FCMInternalStorage.shared.add(tags: tags) }
    /// Method which provide the removing tags
    /// - Parameter tags: array of the tags
    func fcmRemove(tags: [String]?) { FCMInternalStorage.shared.remove(tags: tags) }
    /// Method which provide the clearing tags
    func fcmClearTags() { FCMInternalStorage.shared.clearTags() }
}
