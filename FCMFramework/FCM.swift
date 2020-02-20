//
//  FCM.swift
//  FCMWorkbook
//
//  Created by Dmitry Lernatovich on 14.02.2020.
//  Copyright © 2020 Dmitry Lernatovich. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

// ================================================================================================================
// MARK: - Functions
// ================================================================================================================

/// Method which provide the debug printing
/// - Parameter message: {@link String} value of the message
private func debugPrint(with message: String) {
    #if DEBUG
    print(message);
    #endif
}

/// Method which provide the sending of the notification when items is updating
private func fcmSendUpdate() {
    NotificationCenter.default
        .post(name: FCMConstants.notificationUpdate, object: nil, userInfo: nil);
}

/// Method which provide the sending of the recieving model
/// - Parameter model: instance of the {@link FCMModel}
private func fcmSendRecieveNotification(model: FCMModel) {
    let userInfo: [AnyHashable: Any] = [FCMConstants.notificationMessageKey: model];
    NotificationCenter.default
        .post(name: FCMConstants.notificationRecieved, object: nil, userInfo: userInfo);
}

/// Method which provide the sending of the recieving model
/// - Parameter model: instance of the {@link FCMModel}
private func fcmSendReadNotification(model: FCMModel) {
    let userInfo: [AnyHashable: Any] = [FCMConstants.notificationMessageKey: model];
    NotificationCenter.default
        .post(name: FCMConstants.notificationReaded, object: nil, userInfo: userInfo);
}

// ================================================================================================================
// MARK: - Extensions
// ================================================================================================================
// String
/// Extension which provide convert string to name
private extension String {
    /// Notification name
    var name: Notification.Name { return Notification.Name(rawValue: self) }
}

/// Extension which provide the convert data to the apns formatted string
private extension Data {
    /// {@link String} value of the pans token
    var apnsString: String? {
        let format: String = "%02.2hhx";
        let tokenParts = self.map { data in String(format: format, data) }
        return tokenParts.joined();
    }
}

/// Extension which provide the getting title, body and other thing
private extension Dictionary {
    /// Alert dict varibale
    private var alert: [AnyHashable: Any]? {
        let userInfo = self as [AnyHashable: Any];
        if let data = userInfo["aps"] as? [AnyHashable: Any],
            let alert = data["alert"] as? [AnyHashable: Any]  {
            return alert;
        }
        return nil;
    }
    /// {@link String} value of the title
    var title: String? {
        if let alert = self.alert {
            return alert["title"] as? String;
        }
        return nil;
    }
    /// {@link String} value of the title
    var body: String? {
        if let alert = self.alert {
            return alert["body"] as? String;
        }
        return nil;
    }
}

// ================================================================================================================
// MARK: - Constants
// ================================================================================================================
/// Constants structure
private struct FCMConstants {
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

// ================================================================================================================
// MARK: - Property wrappers
// ================================================================================================================
// Date wrapper
/// Positive wrapper
@propertyWrapper
struct DateValue: Codable, Hashable {
    /// Number value
    private var value: TimeInterval;
    /// Wrapped value
    var wrappedValue: Date {
        get { return Date(timeIntervalSince1970: value) }
        set { value = newValue.timeIntervalSince1970 }
    }
    /// Constructor for the wrapper
    /// - Parameter initialValue: initial value
    init(wrappedValue initialValue: Date) {
        self.value = initialValue.timeIntervalSince1970;
    }
}

// Storable object value
/// Positive wrapper
@propertyWrapper
struct StorableObjectValue<T: Codable>: Codable {
    /// Number value
    private var key: String;
    /// Wrapped value
    var wrappedValue: T? {
        get {
            let defaults = UserDefaults.standard;
            if let data = defaults.object(forKey: key) as? Data {
                let decoder = JSONDecoder();
                if let object = try? decoder.decode(T.self, from: data) {
                    return object;
                }
            }
            return nil;
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key);
                return;
            }
            let encoder = JSONEncoder();
            if let encoded = try? encoder.encode(newValue) {
                let defaults = UserDefaults.standard;
                defaults.set(encoded, forKey: key);
            }
        }
    }
    /// Constructor for the wrapper
    /// - Parameter initialValue: initial value
    init(_ key: String) {
        self.key = key;
    }
}

// Storable string value
/// Positive wrapper
@propertyWrapper
struct StorableStringValue: Codable {
    /// Key value
    var key: String;
    /// Wrapped value
    var wrappedValue: String? {
        get { return UserDefaults.standard.object(forKey: key) as? String }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: key);
                return;
            }
            UserDefaults.standard.set(newValue, forKey: key);
        }
    }
    /// Constructor for the wrapper
    /// - Parameter initialValue: initial value
    init(_ key: String) {
        self.key = key;
    }
}

// ================================================================================================================
// MARK: - Structs
// ================================================================================================================
// FCMModel
/// Struct which provide the FCM model container
public struct FCMModel: Codable, Hashable {
    /// {@link String} value of the id
    var id: String;
    /// {@link Date} value of the creating/recieving notification
    @DateValue var date: Date;
    /// {@link String} value of the title
    var title: String;
    /// {@link String} value of the body
    var body: String;
    /// {@link Bool} value if it readed
    var isReaded: Bool;
    /// Method which provide the compare functionality
    /// - Parameters:
    ///   - lhs: instance of the {@link FCMModel}
    ///   - rhs: instance of the {@link FCMModel}s
    public static func == (lhs: FCMModel, rhs: FCMModel) -> Bool { return lhs.id == rhs.id }
}

// FCMModelContainer
/// Container for the {@link FCMModel}
private struct FCMModelContainer: Codable {
    /// Set of the {@link FCMModel}
    var items: Set<FCMModel>;
    /// Array of the {@link FCMModel}
    var array: [FCMModel] {
        return Array(items).sorted { (lhs, rhs) -> Bool in
            return lhs.date.compare(rhs.date) == .orderedAscending;
        }
    }
    /// Default constructor
    init() { self.items = Set<FCMModel>() }
}

// FCMInternalStorage
/// Struct which provide the fcm storage
private struct FCMInternalStorage: Codable {
    /// Shared variable
    static var shared: FCMInternalStorage = FCMInternalStorage();
    /// {@link String} value of the tokken
    @StorableStringValue("vrzaiqsduribowvznje75a2rf6wb36xbk9jq5y6r") var token: String?;
    /// {@link String} value of the fcm token
    @StorableStringValue("k3sf4vek3cxvv6rdothq9egwqxp2a9qo6zyork9v") var fcmToken: String?;
    /// Instance of the {@link FCMModelContainer}
    @StorableObjectValue<FCMModelContainer>("nyd6wqoe8jeovsqxrxbm4cadn88c5r5dscag7wav") var models: FCMModelContainer?;
    /// Default constructor
    private init() { if models == nil { models = FCMModelContainer() } }
}

// ================================================================================================================
// MARK: - Protocols
// ================================================================================================================
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

/// Protocol which provide the FCM storage
public protocol FCMStorage: AnyObject { }

/// Protocol which provide the FCM protocols
public protocol FCMProtocol: AnyObject {
    /// Instance of the {@link DispatchGroup}
    var dispatch: DispatchGroup { get }
    /// Channels array
    var channels: [String] { get }
}

// ================================================================================================================
// MARK: - Structures extensions
// ================================================================================================================
// FCMInternalStorage
/// Extension which provide the insertion functionality
extension FCMInternalStorage {
    /// Method which provide the insert of the model
    /// - Parameter model: instance of the model
    mutating func insert(models: [FCMModel], forced: Bool = false) {
        // Read models
        if var model = self.models {
            // Save old count
            let oldCount: Int = model.items.count;
            // Append fcm messages
            for fcm in models {
                // Remove message before adding if we need to force override
                if forced == true { model.items.remove(fcm) }
                // Insert message
                model.items.insert(fcm);
            }
            // Caclulate new count
            let newCount: Int = model.items.count;
            // If old count not equal new count send the notifications
            if oldCount != newCount {
                // If recieved models items count == 1, send update recieved 1 message
                if models.count == 1, let first = models.first {
                    fcmSendRecieveNotification(model: first);
                    // If items count more than 1, than send update notifications
                } else {
                    fcmSendUpdate();
                }
                // If item count wasn't changed but force replace was set,
                // send notification about read message
            } else if models.count == 1,
                let first = models.first,
                first.isReaded == true,
                forced == true  {
                fcmSendReadNotification(model: first);
            }
            // Save models
            self.models = model;
        }
    }
}

// ================================================================================================================
// MARK: - Protocol extensions
// ================================================================================================================
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

// FCMProtocol
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

/// Protocol which provide to subscribe for the channels
public extension FCMProtocol {
    
    /// Method which provide the subscribe on channels
    func fcmSubscribeOnChannels(channels: [String]) {
        for channel in channels {
            Messaging.messaging().subscribe(toTopic: channel);
        }
    }
}

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
        self.dispatch.enter();
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
                                  isReaded: false);
            models.append(object);
            
        }
        FCMInternalStorage.shared.insert(models: models);
        self.dispatch.leave();
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
        self.dispatch.enter();
        if let date = date,
            let id = id {
            let object = FCMModel(id: id,
                                  date: date,
                                  title: userInfo.title ?? "",
                                  body: userInfo.body ?? "",
                                  isReaded: readed);
            FCMInternalStorage.shared.insert(models: [object], forced: forced);
        }
        self.dispatch.leave();
    }
    
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
