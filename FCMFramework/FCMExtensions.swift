//
//  FCMExtensions.swift
//  Alamofire
//
//  Created by Dmitry Lernatovich on 20.02.2020.
//

import UIKit

// ================================================================================================================
// MARK: - Extensions
// ================================================================================================================
// String
/// Extension which provide convert string to name
extension String {
    /// Notification name
    var name: Notification.Name { return Notification.Name(rawValue: self) }
}

/// Extension which provide the convert data to the apns formatted string
extension Data {
    /// {@link String} value of the pans token
    var apnsString: String? {
        let format: String = "%02.2hhx";
        let tokenParts = self.map { data in String(format: format, data) }
        return tokenParts.joined();
    }
}

/// Extension which provide the getting title, body and other thing
extension Dictionary {
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
