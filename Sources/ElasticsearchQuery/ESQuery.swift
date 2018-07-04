//
//  ESQuery.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public class ESQuery<Index: ESIndex>: Encodable {
    enum CodingKeys: String, CodingKey {
        case query
        case _aggs = "aggs"
    }
    
    var query = Query<Index>()
    func aggs(_ name: String, _ agg: Agg<Index>) {
        _aggs[name] = agg
    }
    
    private var _aggs = Dictionary<String, Agg<Index>>()
}
