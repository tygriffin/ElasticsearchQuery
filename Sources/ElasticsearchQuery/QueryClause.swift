//
//  QueryClause.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public enum RangeValue: String {
    case gt
    case gte
    case lt
    case lte
}

public enum QueryClause<Index: ESIndex>: Encodable {

    case term(field: KeyPath<Index, MappingField>, value: ESValue)
    case range(field: KeyPath<Index, MappingField>, value: Dictionary<RangeValue, ESValue>)
    case match(field: KeyPath<Index, MappingField>, value: ESValue)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        switch self {
        case .term(let field, let value):
            var nested = container.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: "term")!
            )
            
            var nestedNested = nested.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: Index.shared[keyPath: field].name)!
            )
            try nestedNested.encode(value, forKey: DynamicCodingKey(stringValue: "value")!)
            
        case .range(let field, let value):
            var nested = container.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: "range")!
            )
            
            var nestedNested = nested.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: Index.shared[keyPath: field].name)!
            )
            
            for (key, esvalue) in value {
                try nestedNested.encodeIfPresent(esvalue, forKey: DynamicCodingKey(stringValue: key.rawValue)!)
            }
        case .match(let field, let value):
            var nested = container.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: "match")!
            )
            
            try nested.encode(value, forKey: DynamicCodingKey(stringValue: Index.shared[keyPath: field].name)!)
        }
    }
}
