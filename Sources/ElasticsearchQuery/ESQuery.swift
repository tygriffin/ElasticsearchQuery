//
//  ESQuery.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public enum SortOrder: String, Encodable {
    case desc
    case asc
    
    enum CodingKeys: CodingKey {
        case order
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawValue, forKey: .order)
    }
}

public class ESQuery<Index: ESIndex>: Encodable {
    enum CodingKeys: String, CodingKey {
        case query
        case aggs
        case sort
        case _source
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(query, forKey: .query)
        try container.encodeIfPresent(_aggs, forKey: .aggs)
        try container.encodeIfPresent(_sort, forKey: .sort)
        try container.encodeIfPresent(_source?.map { Index.shared[keyPath: $0].name }, forKey: ._source)
    }
    
    var _source: [KeyPath<Index, MappingField>]?
    var query = Query<Index>()
    func aggs(_ name: String, _ agg: Agg<Index>) {
        _aggs[name] = agg
    }
    func sort(field: KeyPath<Index, MappingField>, order: SortOrder = .desc) {
        _sort = [Index.shared[keyPath: field].name: order]
    }
    
    private var _aggs = Dictionary<String, Agg<Index>>()
    private var _sort: Dictionary<String, SortOrder>?
}
