//
//  Created by Dmitry Lernatovich on 14.02.2020.
//  Copyright © 2020 Dmitry Lernatovich. All rights reserved.
//

import UIKit

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
