//
//  NSObject.swift
//  SOCodable
//
//  Created by Chaitanya Soni on 03/10/20.
//  Copyright © 2020 Chaitanya Soni. All rights reserved.
//

import Foundation
extension NSObject {
    var className: String {
        self.description.components(separatedBy: ["<",":",">"])[1]
    }
}
