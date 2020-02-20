//
//  FCMNotificator.swift
//  Alamofire
//
//  Created by Dmitry Lernatovich on 20.02.2020.
//

import UIKit

/// Protocol which provide the fcm functional
@objc public protocol FCMNotificator: AnyObject {
    /// Method which provide the on recieved updates
    @objc func fcmRecievedUpdate();
    /// Method which provide the sending of the recieving model
    /// FOR RECIEVING MESSAGE USE: self.fcmUnpackMessage(from: notification)
    /// - Parameter model: instance of the {@link FCMModel}
    @objc func fcmRecieveMessage(notification: Notification);
    /// Method which provide the sending of the readed model
    /// FOR RECIEVING MESSAGE USE: self.fcmUnpackMessage(from: notification)
    /// - Parameter model: instance of the {@link FCMModel}
    @objc func fcmReadMessage(notification: Notification);
}

// FCMNotificator
/// Extension which provide the subscribe for notification
public extension FCMNotificator {
    /// Method which provide the subscribe for the notifications
    func fcmSubscribe() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(fcmRecievedUpdate),
                         name: FCMConstants.notificationUpdate, object: nil);
        NotificationCenter.default
            .addObserver(self, selector: #selector(fcmRecieveMessage(notification:)),
                     name: FCMConstants.notificationRecieved, object: nil);
        NotificationCenter.default
            .addObserver(self, selector: #selector(fcmReadMessage(notification:)),
                 name: FCMConstants.notificationReaded, object: nil);
        
    }
    /// Method which provide the unsubscribe from notifications
    func fcmUnsubscribe() {
        for notification in FCMConstants.allNotifications {
            NotificationCenter.default
                .removeObserver(self, name: notification, object: nil);
        }
    }
}

/// Retrieve message extension
public extension FCMNotificator {
    /// Method which provide the unpack message from notification
    /// - Parameter notification: instance of the {@link Notification}
    func fcmUnpackMessage(from notification: Notification) -> FCMModel? {
        if let info = notification.userInfo {
            return info[FCMConstants.notificationMessageKey] as? FCMModel;
        }
        return nil;
    }
}
