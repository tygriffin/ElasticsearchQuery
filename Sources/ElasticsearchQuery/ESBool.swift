//
//  ESBool.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public class ESBool<Index: ESIndex>: Encodable {
    @discardableResult
    public func must(_ clause: QueryClause<Index>) -> ESBool {
        _must.append(clause)
        return self
    }
    @discardableResult
    public func mustNot(_ clause: QueryClause<Index>) -> ESBool {
        _mustNot.append(clause)
        return self
    }
    @discardableResult
    public func should(_ clause: QueryClause<Index>) -> ESBool {
        _should.append(clause)
        return self
    }
    private var _must: [QueryClause<Index>] = []
    private var _mustNot: [QueryClause<Index>] = []
    private var _should: [QueryClause<Index>] = []
    
    enum CodingKeys: CodingKey {
        case must
        case mustNot
        case should
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if !_must.isEmpty {
            try container.encode(_must, forKey: .must)
        }
        if !_mustNot.isEmpty {
            try container.encode(_mustNot, forKey: .mustNot)
        }
        if !_should.isEmpty {
            try container.encode(_should, forKey: .should)
        }
    }
}
