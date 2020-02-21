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
    print("FCMFramework: \(message)");
    #endif
}

/// Method which provide the sending of the notification when items is updating
/// - Parameter notify: if it need notification
func fcmSendUpdate(notify: Bool = true) {
    guard notify == true else { return }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        NotificationCenter.default
            .post(name: FCMConstants.notificationUpdate, object: nil, userInfo: nil);
    }
}

/// Method which provide the sending of the recieving model
/// - Parameters:
///   - model: instance of the {@link FCMModel}
///   - notify: if it need notification
func fcmSendRecieveNotification(model: FCMModel,
                                notify: Bool = true) {
    guard notify == true else { return }
    let userInfo: [AnyHashable: Any] = [FCMConstants.notificationMessageKey: model];
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        NotificationCenter.default
            .post(name: FCMConstants.notificationRecieved, object: nil, userInfo: userInfo);
    }
}

/// Method which provide the sending of the recieving model
/// - Parameters:
///   - model: instance of the {@link FCMModel}
///   - notify: if it need notification
func fcmSendReadNotification(model: FCMModel,
                             notify: Bool = true) {
    guard notify == true else { return }
    let userInfo: [AnyHashable: Any] = [FCMConstants.notificationMessageKey: model];
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        NotificationCenter.default
            .post(name: FCMConstants.notificationReaded, object: nil, userInfo: userInfo);
    }
}
