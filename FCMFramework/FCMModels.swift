//
//  Created by Dmitry Lernatovich on 14.02.2020.
//  Copyright © 2020 Dmitry Lernatovich. All rights reserved.
//

import UIKit

// ================================================================================================================
// MARK: - FCMModel
// ================================================================================================================
/// Struct which provide the FCM model container
public struct FCMModel: Codable, Hashable {
    /// {@link String} value of the id
    public var id: String;
    /// {@link Date} value of the creating/recieving notification
    @DateValue public var date: Date;
    /// {@link String} value of the title
    public var title: String;
    /// {@link String} value of the body
    public var body: String;
    /// {@link String} value of the imageUrl
    public var imageUrl: String?;
    /// {@link Bool} value if it readed
    public var isReaded: Bool;
    /// Array of the tags
    public var tags: [String]?;
    /// Method which provide the hash functionality
    /// - Parameter hasher: instance of the {@link Hasher}
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    /// Method which provide the compare functionality
    /// - Parameters:
    ///   - lhs: instance of the {@link FCMModel}
    ///   - rhs: instance of the {@link FCMModel}s
    public static func == (lhs: FCMModel, rhs: FCMModel) -> Bool { return lhs.id == rhs.id }
}

// ================================================================================================================
// MARK: - Add tags functionality
// ================================================================================================================
/// Add tag functional
public extension FCMModel {
    /// Method which provide the adding of the tag
    /// - Parameter tag: array of the tags
    mutating func add(tags: [String]?) {
        guard let tags = tags else { return }
        if self.tags == nil { self.tags = [] }
        for tag in tags {
            self.tags?.append(tag.lowercased());
        }
    }
}

// ================================================================================================================
// MARK: - Search tags functionality
// ================================================================================================================
/// Search tag extension
public extension FCMModel {
    /// Method which provide the checking if the model contain tags
    /// - Parameters:
    ///   - tags: {@link String} value of tag
    ///   - needUntagged: if we need untagged
    func contains(tags: [String]?, needUntagged: Bool = false) -> Bool {
        if needUntagged == true, (self.tags == nil || self.tags?.count == 0) {
            return true;
        }
        guard let searchTags = tags, let selfTags = self.tags else { return false }
        for tag in searchTags {
            if selfTags.contains(tag.lowercased()) == true { return true }
        }
        return false;
    }
}
