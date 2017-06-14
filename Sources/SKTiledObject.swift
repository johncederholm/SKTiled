//
//  SKTiledObject.swift
//  SKTiled
//
//  Created by Michael Fessenden on 5/16/16.
//  Copyright © 2016 Michael Fessenden. All rights reserved.
//

import SpriteKit

/**
 The `SKTiledObject` protocol describes a generic Tiled object containing a dictionary of properties parsed from the TMX file.
 
 Objects conforming to this protocol support custom properties that can be parsed via the `SKTilemapParser` parser.
 
 - parameter uuid:             `String` unique object id.
 - parameter type:             `String!` object type.
 - parameter properties:       `[String: String]` dictionary of object properties.
 - parameter ignoreProperties: `Bool` ignore custom properties.
 */
public protocol SKTiledObject: class {
    /// Unique id (layer & object names may not be unique).
    var uuid: String { get set }
    /// Object type
    var type: String! { get set }
    /// Properties shared by most objects.
    var properties: [String: String] { get set }
    /// Ignore properties
    var ignoreProperties: Bool { get set }
    /// Parse function (with optional completion block).
    func parseProperties(completion: (() -> ())?)
}


public extension SKTiledObject {
    
    public var hashValue: Int { return uuid.hashValue }
    
    // MARK: - Properties Parsing
    /**
     Returns true if the node has stored properties.
     
     - returns: `Bool` properties are not empty.
     */
    public var hasProperties: Bool {
        return properties.count > 0
    }
    
    /**
     Returns true if the node has the given property.
     
     - parameter key: `String` key to query.
     - returns: `Bool` properties has a value for the key.
     */
    public func hasKey(_ key: String) -> Bool {
        return properties[key] != nil
    }
    
    /**
     Sets a named property. Returns the value, or nil if it does not exist.
     
     - parameter key:   `String` property key.
     - parameter value: `String` property value.
     */
    public func setValue(forKey key: String, _ value: String) {
        properties[key] = value
    }

    /**
     Remove a named property, returns the value as a string (if property exists).
     
     - parameter key: `String` property key.
     - returns:       `String?` property value (if it exists).
     */
    public func removeProperty(forKey key: String) -> String? {
        if let value = properties[key] {
            properties.removeValue(forKey: key)
            return value
        }
        return nil
    }
    
    /// Returns a string representation of the node's properties.
    public var propertiesString: String {
        return properties.reduce("", { (aggregate: String, pair) -> String in
            let comma: String = (pair.key == Array(properties.keys).last) ? "" : ","
            return "\(aggregate)\(pair.key): \(pair.value)\(comma) "
            
        })
    }
    
    // MARK: - Helpers
    /**
     Returns true if the property is a numeric type.
     
     - parameter key: `String` key to query.
     - returns: `Bool` value is a numeric type.
     */
    internal func hasNumericKey(_ key: String) -> Bool {
        guard let value = properties[key] else { return false }
        return Int(value) != nil || Double(value) != nil
    }

    
    /**
     Returns a string for the given key.
     
     - parameter key: `String` properties key.
     - returns: `String` value for properties key.
     */
    public func stringForKey(_ key: String) -> String? {
        for k in properties.keys {
            if k.lowercased() == key.lowercased() {
                return properties[k]
            }
        }
        return properties[key]
    }
    
    /**
     Returns a string array for the given key.
     
     - parameter key:         `String` properties key.
     - parameter separatedBy: `String` separator.
     - returns: `[String]` value for properties key.
     */
    internal func stringArrayForKey(_ key: String, separatedBy: String=",") -> [String] {
        if let value = properties[key] {
            return value.components(separatedBy: separatedBy)
        }
        return [String]()
    }
    
    /**
     Returns a integer value for the given key.
     
     - parameter key: `String` properties key.
     - returns: `Int?` value for properties key.
     */
    internal func intForKey(_ key: String) -> Int? {
        guard (hasKey(key) == true) else { return nil }
        return Int(properties[key]!)
    }
    
    /**
     Returns a integer array for the given key.
     
     - parameter key:         `String` properties key.
     - parameter separatedBy: `String` separator.
     - returns: `[Int]` array of integers for properties key.
     */
    internal func integerArrayForKey(_ key: String, separatedBy: String=",") -> [Int] {
        if let value = properties[key] {
            return  value.components(separatedBy: separatedBy).flatMap { Int($0) }
        }
        return [Int]()
    }
    
    /**
     Returns a float value for the given key.
     
     - parameter key: `String` properties key.
     - returns: `Double?` value for properties key.
     */
    internal func doubleForKey(_ key: String) -> Double? {
        guard (hasKey(key) == true) else { return nil }
        return Double(properties[key]!)
    }
    
    /**
     Returns a double array for the given key.
     
     - parameter key:         `String` properties key.
     - parameter separatedBy: `String` separator.
     - returns: `[Double]` array of doubles for properties key.
     */
    internal func doubleArrayForKey(_ key: String, separatedBy: String=",") -> [Double] {
        if let value = properties[key] {
            return value.components(separatedBy: separatedBy).flatMap { Double($0) }
        }
        return [Double]()
    }
    
    /**
     Returns a boolean value for the given key.
     
     - parameter key: `String` properties key.
     - returns: `Bool` value for properties key.
     */
    internal func boolForKey(_ key: String) -> Bool {
        guard let value = properties[key]?.lowercased() else { return false }
        return Bool(value) ?? false || Int(value) == 1
    }

    // MARK: - Key/Value Parsing
    /**
     Parses a key/value string (separated by '=') and returns a tuple.
     
     - parameter string: `String` key/value string.
     - returns: `(String:Any)?` value for properties key.
     */
    public func keyValuePair(_ string: String) -> (key: String, value: Any)? {
        var result: (key: String, value: Any)? = nil
        let values = string.components(separatedBy: "=")
        if values.count == 2 {
            result = (key: values[0], value: values[1])
        }
        return result
    }
}

