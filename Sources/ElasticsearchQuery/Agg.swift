//
//  Agg.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public enum Agg<Index: ESIndex>: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        switch self {
        case .dateHistogram(let field, let interval):
            var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: DynamicCodingKey(stringValue: "dateHistogram")!)
            try nested.encode(Index.shared[keyPath: field].name, forKey: DynamicCodingKey(stringValue: "field")!)
            try nested.encode(interval, forKey: DynamicCodingKey(stringValue: "interval")!)
        }
    }
    
    case dateHistogram(field: KeyPath<Index, MappingField>, interval: Interval)
}
