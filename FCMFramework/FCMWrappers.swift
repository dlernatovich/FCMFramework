//
//  Created by Dmitry Lernatovich on 14.02.2020.
//  Copyright © 2020 Dmitry Lernatovich. All rights reserved.
//

import UIKit


// ================================================================================================================
// MARK: - Date wrapper
// ================================================================================================================
/// Positive wrapper
@propertyWrapper
public struct DateValue: Codable, Hashable {
    /// Number value
    private var value: TimeInterval;
    /// Wrapped value
    public var wrappedValue: Date {
        get { return Date(timeIntervalSince1970: value) }
        set { value = newValue.timeIntervalSince1970 }
    }
    /// Constructor for the wrapper
    /// - Parameter initialValue: initial value
    public init(wrappedValue initialValue: Date) {
        self.value = initialValue.timeIntervalSince1970;
    }
}

// ================================================================================================================
// MARK: - Storable object value
// ================================================================================================================
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

// ================================================================================================================
// MARK: - Storable string value
// ================================================================================================================
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
// MARK: - Storable array value
// ================================================================================================================
/// Positive wrapper
@propertyWrapper
struct StorableArrayValue<T: Codable>: Codable {
    /// Key value
    var key: String;
    /// Wrapped value
    var wrappedValue: Array<T>? {
        get { return UserDefaults.standard.object(forKey: key) as? Array<T> }
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
