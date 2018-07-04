//
//  Mapping.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public typealias Mapping = Dictionary<String, MappingField>

extension Dictionary where Key == String, Value == MappingField {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        for (key, value) in self {
            try container.encode(value, forKey: DynamicCodingKey(stringValue: key)!)
        }
    }
}
