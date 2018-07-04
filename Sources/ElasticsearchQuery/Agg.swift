//
//  Agg.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public indirect enum Agg<Index: ESIndex>: Encodable {
    case dateHistogram(field: KeyPath<Index, MappingField>, interval: Interval)
    case stats(field: KeyPath<Index, MappingField>)
    case avg(field: KeyPath<Index, MappingField>)
    case sum(field: KeyPath<Index, MappingField>)
    case valueCount(field: KeyPath<Index, MappingField>)
    case topHits(size: Int)
    case aggs(agg: Agg<Index>)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        switch self {
        case .dateHistogram(let field, let interval):
            var nested = container.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: "date_histogram")!
            )
            try nested.encode(Index.shared[keyPath: field].name, forKey: DynamicCodingKey(stringValue: "field")!)
            try nested.encode(interval, forKey: DynamicCodingKey(stringValue: "interval")!)
        case .stats(let field):
            var nested = container.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: "stats")!
            )
            try nested.encode(Index.shared[keyPath: field].name, forKey: DynamicCodingKey(stringValue: "field")!)
        case .avg(let field):
            var nested = container.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: "avg")!
            )
            try nested.encode(Index.shared[keyPath: field].name, forKey: DynamicCodingKey(stringValue: "field")!)
        case .sum(let field):
            var nested = container.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: "sum")!
            )
            try nested.encode(Index.shared[keyPath: field].name, forKey: DynamicCodingKey(stringValue: "field")!)
        case .valueCount(let field):
            var nested = container.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: "value_count")!
            )
            try nested.encode(Index.shared[keyPath: field].name, forKey: DynamicCodingKey(stringValue: "field")!)
        case .topHits(let size):
            var nested = container.nestedContainer(
                keyedBy: DynamicCodingKey.self,
                forKey: DynamicCodingKey(stringValue: "top_hits")!
            )
            try nested.encode(size, forKey: DynamicCodingKey(stringValue: "size")!)
        case .aggs(let agg):
            try container.encode(agg, forKey: DynamicCodingKey(stringValue: "aggs")!)
        }
    }
}
