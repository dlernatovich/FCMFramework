//
//  Created by Dmitry Lernatovich on 14.02.2020.
//  Copyright © 2020 Dmitry Lernatovich. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

// ================================================================================================================
// MARK: - FCMProtocol
// ================================================================================================================
/// Protocol which provide the FCM protocols
public protocol FCMProtocol: AnyObject {
    /// Channels array
    var channels: [String] { get }
}

// ================================================================================================================
// MARK: - Initialize functional
// ================================================================================================================
/// Extension which provide the
public extension FCMProtocol {
    /// Method which provide the initialize of the {@link FirebaseApp}
    /// USE IN THE: application(_ application: UIApplication, didFinishLaunchingWithOptions...)
    func fcmInitialize(messagingDelegate: MessagingDelegate,
                       notificationDelegate: UNUserNotificationCenterDelegate) {
        FirebaseApp.configure();
        Messaging.messaging().delegate = messagingDelegate;
        UNUserNotificationCenter.current().delegate = notificationDelegate;
        UNUserNotificationCenter.current()
            .requestAuthorization(options: FCMConstants.authOptions) { [weak self]
                granted, error in
                debugPrint(with: "apnsRegister -> Permission granted: \(granted)");
                guard granted else { return }
                self?.apnsPermissionGranted();
        }
    }
    
    /// Method which provide the action when the apns permission granted
    private func apnsPermissionGranted() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            debugPrint(with: "apnsSettings -> Notification settings: \(settings)");
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
        }
    }
    
}

// ================================================================================================================
// MARK: - Registering for notifications
// ================================================================================================================
/// Extension which provide the performing action when the application was registered for the remote notification
public extension FCMProtocol {
    
    /// Method which provide the action when the user registered for the remote notification
    /// - Parameter token: token {@link Data}
    func fcmRegisteredForNotifications(with token: Data) {
        debugPrint(with: "fcmRegisteredForNotifications() -> \(token.apnsString ?? "")");
        FCMInternalStorage.shared.token = token.apnsString;
        Messaging.messaging().apnsToken = token;
        self.fcmSubscribeOnChannels(channels: self.channels);
    }
    
    /// Method which provide the action when the user registered fails for the remote notification
    /// - Parameter error: instance of the {@link Error}
    func fcmRegisteredFailForNotifications(with error: Error?) {
        debugPrint(with: "fcmRegisteredFailForNotifications() -> \(error?.localizedDescription ?? "")");
        FCMInternalStorage.shared.token = nil;
    }
}

// ================================================================================================================
// MARK: - fcmSubscribeOnChannels
// ================================================================================================================
/// Protocol which provide to subscribe for the channels
extension FCMProtocol {
    
    /// Method which provide the subscribe on channels
    func fcmSubscribeOnChannels(channels: [String]) {
        FCMDispatch.enter();
        fcmSubscribe(channels: channels);
        FCMDispatch.leave();
    }
}

// ================================================================================================================
// MARK: - Notification methods
// ================================================================================================================
/// Extension which provide the action when the notification was recieved
public extension FCMProtocol {
    
    /// Method which provide the action when the message was recieved
    /// - Parameters:
    ///   - center: instance of the {@link UNUserNotificationCenter}
    ///   - notification: instance of the {@link UNNotification}
    ///   - completionHandler: completition handler
    func fcmUserNotificationCenter(_ center: UNUserNotificationCenter,
                                   willPresent notification: UNNotification,
                                   withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo;
        if let messageID = userInfo[FCMConstants.messageIdKey] as? String {
            debugPrint(with: "Message ID: \(messageID)");
        }
        debugPrint(with: "\(userInfo)");
        completionHandler([FCMConstants.alertOptions]);
        self.fcmFetch(with: userInfo,
                      withDate: notification.date,
                      withId: notification.request.identifier);
    }
    
    /// Method which provide the action when the user recieve of the notification
    /// - Parameters:
    ///   - center: instance of the {@link UNUserNotificationCenter}
    ///   - response: instance of the {@link UNNotificationResponse}
    ///   - completionHandler: completition handler
    func fcmUserNotificationCenter(_ center: UNUserNotificationCenter,
                                   didReceive response: UNNotificationResponse,
                                   withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo;
        if let messageID = userInfo[FCMConstants.messageIdKey] as? String {
            print("Message ID: \(messageID)");
        }
        debugPrint(with: "\(userInfo)");
        completionHandler();
        self.fcmFetch(with: userInfo,
                      withDate: response.notification.date,
                      withId: response.notification.request.identifier,
                      readed: true,
                      forced: true);
    }
    
}

// ================================================================================================================
// MARK: - FCM Messaging for override
// ================================================================================================================
/// Extension which provide the recieving of the Messaging
public extension FCMProtocol {
    /// Method which provide the recieving of the registration tokken for the firebase messaging
    /// - Parameters:
    ///   - messaging: instance of the {@link Messaging}
    ///   - fcmToken: {@link String} value of the registration tokken
    func fcmMessaging(_ messaging: Messaging,
                      didReceiveRegistrationToken fcmToken: String) {
        FCMInternalStorage.shared.fcmToken = fcmToken;
        debugPrint(with: "Firebase registration token: \(fcmToken)")
    }
    
    /// Method which provide the action when the user recieve of the remote message
    /// - Parameters:
    ///   - messaging: instance of the {@link Messaging}
    ///   - remoteMessage: instance of the {@link MessagingRemoteMessage}
    func fcmMessaging(_ messaging: Messaging,
                      didReceive remoteMessage: MessagingRemoteMessage) {
        debugPrint(with: "Received data message: \(remoteMessage.appData)");
    }
}

// ================================================================================================================
// MARK: - Fetch
// ================================================================================================================
/// Extension which provide the fetching functionality
public extension FCMProtocol {
    
    /// Method which provide the fetching of the messages
    /// - Parameter userInfo: user info dictionary
    func fcmFetch(with userInfo: [AnyHashable: Any]? = nil,
                  withDate date: Date? = nil,
                  withId id: String? = nil,
                  readed: Bool = false,
                  forced: Bool = false) {
        guard let userInfo = userInfo else {
            self.fcmCenterFetch();
            return;
        }
        self.fcmInfoFetch(with: userInfo,
                          withDate: date,
                          withId: id,
                          readed: readed,
                          forced: forced);
    }
    
    /// Method which provide the fetching from the notification center
    private func fcmCenterFetch() {
        FCMDispatch.enter();
        UNUserNotificationCenter.current().getDeliveredNotifications
            { [weak self] (notifications) in
                self?.fcmCenterFetch(notifications: notifications);
        }
    }
    
    /// Method which provide the finish fetching of the notifications
    /// - Parameter notifications: array of the {@link UNNotification}
    private func fcmCenterFetch(notifications: [UNNotification]) {
        var models: [FCMModel] = [];
        for notification in notifications {
            let userInfo = notification.request.content.userInfo;
            let object = FCMModel(id: notification.request.identifier,
                                  date: notification.date,
                                  title: userInfo.title ?? "",
                                  body: userInfo.body ?? "",
                                  isReaded: false,
                                  tags: FCMInternalStorage.shared.tags);
            models.append(object);
            
        }
        FCMInternalStorage.shared.insert(models: models);
        FCMDispatch.leave();
    }
    
    /// Method which provide the fetching from the user info
    /// - Parameters:
    ///   - userInfo: user info dictionary
    ///   - date: instance of the {@link Date}
    ///   - id: {@link String} value of the message ID
    ///   - readed: if it readed
    ///   - forced: if it needed to force override
    private func fcmInfoFetch(with userInfo: [AnyHashable: Any],
                              withDate date: Date? = nil,
                              withId id: String? = nil,
                              readed: Bool = false,
                              forced: Bool = false) {
        FCMDispatch.enter();
        if let date = date,
            let id = id {
            let object = FCMModel(id: id,
                                  date: date,
                                  title: userInfo.title ?? "",
                                  body: userInfo.body ?? "",
                                  isReaded: readed,
                                  tags: FCMInternalStorage.shared.tags);
            FCMInternalStorage.shared.insert(models: [object], forced: forced);
        }
        FCMDispatch.leave();
    }
    
}
