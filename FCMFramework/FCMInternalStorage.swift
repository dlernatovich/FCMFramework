//
//  FCMInternalStorage.swift
//  Alamofire
//
//  Created by Dmitry Lernatovich on 20.02.2020.
//

import UIKit

// FCMModelContainer
/// Container for the {@link FCMModel}
struct FCMModelContainer: Codable {
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
struct FCMInternalStorage: Codable {
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
