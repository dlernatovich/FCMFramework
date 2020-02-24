//
//  Created by Dmitry Lernatovich on 14.02.2020.
//  Copyright © 2020 Dmitry Lernatovich. All rights reserved.
//

import UIKit

// ================================================================================================================
// FCMModelContainer
// ================================================================================================================
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
    /// Array of the tags
    @StorableArrayValue<String>("8k8j5rc77ydi47fo2hginm9sw3pbrhqvsxre5fdc") var tags: [String]?;
    /// Default constructor
    private init() { if models == nil { models = FCMModelContainer() } }
}

// ================================================================================================================
// MARK: - Insert functionality
// ================================================================================================================
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
                // Update message if we need to force override
                if forced == true {
                    model.items.update(with: fcm)
                } else {
                    // Insert message
                    model.items.insert(fcm);
                }
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
// MARK: - Clear cached
// ================================================================================================================
/// Extension which provide the clearing cached messages functionality
extension FCMInternalStorage {
    /// Method which provide the clearing functional
    /// - Parameter notify: if it need notification
    mutating func clear(notify: Bool = true) {
        FCMDispatch.enter();
        self.models = FCMModelContainer();
        fcmSendUpdate(notify: notify);
        FCMDispatch.leave();
    }
}

// ================================================================================================================
// MARK: - Modify reading state
// ================================================================================================================
/// Extension which provide the modify readable state functionality
extension FCMInternalStorage {
    /// Method which provide the modify readed state for the message id
    /// - Parameters:
    ///   - id: {@link String} value of the ID
    ///   - isReaded: {@link Bool} value if it readed
    ///   - notify: if it need notification
    mutating func updateReadedState(withId id: String?,
                                    andState isReaded: Bool,
                                    notify: Bool = true) {
        FCMDispatch.enter();
        if var model = self.models,
            let id = id,
            var first = model.items.first(where: {$0.id == id}) {
            first.isReaded = isReaded;
            model.items.update(with: first);
            self.models = model;
            fcmSendUpdate(notify: notify);
        }
        FCMDispatch.leave();
    }
    
    /// Method which provide the updating model
    /// - Parameters:
    ///   - model: instance of {@link FCMModel}
    ///   - notify: if it need notification
    mutating func update(model: FCMModel?,
                         notify: Bool = true) {
        FCMDispatch.enter();
        if let model = model, var models = self.models {
            models.items.update(with: model);
            self.models = models;
            fcmSendUpdate(notify: notify);
        }
        FCMDispatch.leave();
    }
}

// ================================================================================================================
// MARK: - Tags
// ================================================================================================================
/// Extension which provide the tags serach
extension FCMInternalStorage {
    
    /// Method which provide the search by tags
    /// - Parameter tags: array of the tags
    func search(by tags: [String]?) -> [FCMModel] {
        guard let tags = tags,
            let notifications: Set<FCMModel> = self.models?.items else { return [] }
        return Array(notifications.filter({$0.contains(tags: tags) == true}));
    }
    
    /// Method which provide the remove models by tags
    /// - Parameters:
    ///   - tags: array of the tags
    ///   - notify: if it need notification
    mutating func remove(by tags: [String]?,
                         notify: Bool = true) -> [FCMModel] {
        FCMDispatch.enter();
        var removed: [FCMModel] = self.search(by: tags);
        guard removed.count > 0, var models = self.models else {
            FCMDispatch.leave();
            return [];
        }
        for item in removed { models.items.remove(item) }
        self.models = models;
        fcmSendUpdate(notify: notify);
        FCMDispatch.leave();
        return removed;
    }
}

// ================================================================================================================
// MARK: - Tags managements
// ================================================================================================================
/// Extension which provide the tags serach
extension FCMInternalStorage {
    /// Method which provide the adding of the tags
    /// - Parameter tags: array of the tags
    mutating func add(tags: [String]?) {
        guard let tags = tags else { return }
        FCMDispatch.enter();
        if (self.tags == nil) { self.tags = [] }
        self.tags?.append(contentsOf: tags.map({$0.lowercased()}));
        FCMDispatch.leave();
    }
    
    /// Method which provide the removing tags
    /// - Parameter tags: array of the tags
    mutating func remove(tags: [String]?) {
        guard let tags = tags else { return }
        FCMDispatch.enter();
        self.tags?.removeAll(where: {tags.map({$0.lowercased()}).contains($0)});
        FCMDispatch.leave();
    }
    
    /// Method which provide the clearing tags
    mutating func clearTags() {
        FCMDispatch.enter();
        self.tags = nil;
        FCMDispatch.leave();
    }
}
