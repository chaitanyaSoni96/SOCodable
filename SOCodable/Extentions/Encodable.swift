//
//  Encodable.swift
//  SOCodable
//
//  Created by Chaitanya Soni on 03/10/20.
//  Copyright © 2020 Chaitanya Soni. All rights reserved.
//

import Foundation
extension Encodable {
    var dictionary: [String: Any]? {
      guard let data = try? JSONEncoder().encode(self) else { return nil }
      return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var jsonData: Data? {
        let dic = self.dictionary ?? [:]
        let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        return jsonData
    }
    
    var stringValue: String? {
        guard
            let jsonData = self.jsonData,
            let stringValue = String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "")
            else {
            return nil
        }
        
        return stringValue
    }
    
    static func fromDict<T: Codable>(_ dict: [String : Any]) -> T? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
        //                        headerCodable = try JSONSerialization.jsonObject(with: jsonData, options: []) as! Header
            let headerC = try? JSONDecoder().decode(T.self, from: jsonData) else {
                return nil
        }
        return headerC
    }
    static func fromArrayOfDicts<T: Codable>(_ arrayOfDicts: [[String : Any]]) -> T? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: arrayOfDicts, options: .prettyPrinted),
        //                        headerCodable = try JSONSerialization.jsonObject(with: jsonData, options: []) as! Header
            let headerC = try? JSONDecoder().decode(T.self, from: jsonData) else {
                return nil
        }
        return headerC
    }
}

