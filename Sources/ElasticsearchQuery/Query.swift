//
//  Query.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public struct Query<Index: ESIndex>: Encodable {
    enum CodingKeys: String, CodingKey {
        case bool
    }
    
    var bool = ESBool<Index>()
}
