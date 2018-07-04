//
//  MappingType.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public enum MappingType: String, Encodable {
    case keyword
    case text
    case date
}
