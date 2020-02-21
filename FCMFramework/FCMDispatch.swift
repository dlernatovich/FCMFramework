//
//  Created by Dmitry Lernatovich on 14.02.2020.
//  Copyright © 2020 Dmitry Lernatovich. All rights reserved.
//

import Foundation

/// Dispatcher singleton
class FCMDispatch {
    /// Instance of the {@link DispatchGroup}
    private var dispatch: DispatchGroup = DispatchGroup();
    /// Instance of the {@link FCMDispatch}
    private static var shared: FCMDispatch = FCMDispatch();
    /// Default constructor
    private init() { }
    /// Method which provide to enter to the dispatch group
    static func enter() { FCMDispatch.shared.dispatch.enter() }
    /// Method which provide to enter to the dispatch group
    static func leave() { FCMDispatch.shared.dispatch.leave() }
}
