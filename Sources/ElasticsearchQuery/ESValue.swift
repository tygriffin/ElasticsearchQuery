//
//  ESValue.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public enum ESValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let value):
            try container.encode(value)
        case .date(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        }
    }
    
    case text(String)
    case date(String)
    case number(Double)
}
