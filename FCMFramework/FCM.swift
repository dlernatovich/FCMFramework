//
//  FCM.swift
//  FCMWorkbook
//
//  Created by Dmitry Lernatovich on 14.02.2020.
//  Copyright © 2020 Dmitry Lernatovich. All rights reserved.
//

import UIKit

// ================================================================================================================
// MARK: - Functions
// ================================================================================================================

/// Method which provide the debug printing
/// - Parameter message: {@link String} value of the message
func debugPrint(with message: String) {
    #if DEBUG
    print(message);
    #endif
}

/// Method which provide the sending of the notification when items is updating
func fcmSendUpdate() {
    NotificationCenter.default
        .post(name: FCMConstants.notificationUpdate, object: nil, userInfo: nil);
}

/// Method which provide the sending of the recieving model
/// - Parameter model: instance of the {@link FCMModel}
func fcmSendRecieveNotification(model: FCMModel) {
    let userInfo: [AnyHashable: Any] = [FCMConstants.notificationMessageKey: model];
    NotificationCenter.default
        .post(name: FCMConstants.notificationRecieved, object: nil, userInfo: userInfo);
}

/// Method which provide the sending of the recieving model
/// - Parameter model: instance of the {@link FCMModel}
func fcmSendReadNotification(model: FCMModel) {
    let userInfo: [AnyHashable: Any] = [FCMConstants.notificationMessageKey: model];
    NotificationCenter.default
        .post(name: FCMConstants.notificationReaded, object: nil, userInfo: userInfo);
}

// ================================================================================================================
// MARK: - HOW TO (FCMProtocol)
// ================================================================================================================

/*
 /// Current application
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
     
     /// Instance of the {@link UIWindow}
     var window: UIWindow?
     /// Instance of the {@link DispatchGroup}
     var dispatch: DispatchGroup = DispatchGroup();
     /// Array of the channels
     var channels: [String] { return ["da_info_test_ios"] }
     
     /// Method which provide the action when the application started
     /// - Parameters:
     ///   - application: instance of the {@link UIApplication}
     ///   - launchOptions: dict of the launch options
     func application(_ application: UIApplication,
                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         self.fcmInitialize(messagingDelegate: self, notificationDelegate: self);
         return true
     }
     
 }

 /// Extension which provide the FCMProtocol functionality
 extension AppDelegate: FCMProtocol, MessagingDelegate, UNUserNotificationCenterDelegate {
     
     /// Method which provide the action when the user open the application
     /// - Parameter application: instance of the {@link UIApplication}
     func applicationWillEnterForeground(_ application: UIApplication) {
         self.fcmFetch();
     }
     
     /// Method which provide the register for the remote notificattions
     /// - Parameters:
     ///   - application: instance of the {@link UIApplication}
     ///   - deviceToken: {@link Data} of the device token
     func application(_ application: UIApplication,
                      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         self.fcmRegisteredForNotifications(with: deviceToken);
     }
     
     /// Method which provide the action when the fail of the registration for the remote notification
     /// - Parameters:
     ///   - application: instance of the {@link UIApplication}
     ///   - error: {@link Error} descritpion
     func application(_ application: UIApplication,
                      didFailToRegisterForRemoteNotificationsWithError error: Error) {
         self.fcmRegisteredFailForNotifications(with: error);
     }
     
     /// Method which provide the action when the message was recieved
     /// - Parameters:
     ///   - center: instance of the {@link UNUserNotificationCenter}
     ///   - notification: instance of the {@link UNNotification}
     ///   - completionHandler: completition handler
     func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         self.fcmUserNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler);
     }
     
     
     /// Method which provide the action when the user recieve of the notification
     /// - Parameters:
     ///   - center: instance of the {@link UNUserNotificationCenter}
     ///   - response: instance of the {@link UNNotificationResponse}
     ///   - completionHandler: completition handler
     func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 didReceive response: UNNotificationResponse,
                                 withCompletionHandler completionHandler: @escaping () -> Void) {
         self.fcmUserNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler);
     }
     
     /// Method which provide the recieving of the registration tokken for the firebase messaging
     /// - Parameters:
     ///   - messaging: instance of the {@link Messaging}
     ///   - fcmToken: {@link String} value of the registration tokken
     func messaging(_ messaging: Messaging,
                    didReceiveRegistrationToken fcmToken: String) {
         self.fcmMessaging(messaging, didReceiveRegistrationToken: fcmToken);
     }
     
     /// Method which provide the action when the user recieve of the remote message
     /// - Parameters:
     ///   - messaging: instance of the {@link Messaging}
     ///   - remoteMessage: instance of the {@link MessagingRemoteMessage}
     func messaging(_ messaging: Messaging,
                    didReceive remoteMessage: MessagingRemoteMessage) {
         self.fcmMessaging(messaging, didReceive: remoteMessage);
     }
 }
 */



// ================================================================================================================
// MARK: - HOW TO (FCMNotificator)
// ================================================================================================================
/*
 import UIKit

 class ViewController: UIViewController {
     
     /// Method which provide the action when the controller created
     override func viewDidLoad() {
         super.viewDidLoad();
         self.fcmSubscribe();
     }
     
     /// Deinit method
     deinit { self.fcmUnsubscribe() }

 }

 /// Extension for the {@link FCMNotificator}
 extension ViewController: FCMNotificator, FCMStorage {
     /// Method which provide the on recieved updates
     func fcmRecievedUpdate() {
         print("ViewController -> fcmRecievedUpdate");
     }
     
     /// Method which provide the sending of the recieving model
     /// FOR RECIEVING MESSAGE USE: self.fcmUnpackMessage(from: notification)
     /// - Parameter model: instance of the {@link FCMModel}
     func fcmRecieveMessage(notification: Notification) {
         print("ViewController -> fcmRecieveMessage \(self.fcmUnpackMessage(from: notification))");
     }
     
     /// Method which provide the action when the notification was readed
     /// FOR RECIEVING MESSAGE USE: self.fcmUnpackMessage(from: notification)
     /// - Parameter notification: instance of the {@link Notification}
     func fcmReadMessage(notification: Notification) {
         print("ViewController -> fcmReadMessage \(self.fcmUnpackMessage(from: notification))");
     }
 }
 */
