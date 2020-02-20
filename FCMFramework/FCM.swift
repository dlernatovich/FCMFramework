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
