//
//  MappingField.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public struct MappingField: CustomStringConvertible, Encodable {
    public var description: String {
        return name
    }
    
    enum CodingKeys: CodingKey {
        case type
    }
    
    var name: String
    var type: MappingType
}
