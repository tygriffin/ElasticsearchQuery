//
//  ESIndex.swift
//  ElasticsearchQuery
//
//  Created by Taylor Griffin on 4/7/18.
//

import Foundation

public protocol ESIndex {
    static var shared: Self { get }
}
