import XCTest
@testable import ElasticsearchQuery

enum MyIndex: String, CustomStringConvertible {
    var description: String { return rawValue }
    
    case somefield
    case otherfield
    case datefield
    
    static let allCases: [MyIndex] = [.somefield, .otherfield, .datefield]
    
    static func toMapping() -> Mapping {
        var mapping = Mapping()
        for enumCase in allCases {
            mapping[enumCase.rawValue] = enumCase.toMappingField()
        }
        return mapping
    }
    
    func toMappingField() -> MappingField {
        switch self {
        case .somefield:
            return MappingField(name: "somefield", type: .keyword)
        case .otherfield:
            return MappingField(name: "otherfield", type: .text)
        case .datefield:
            return MappingField(name: "datefield", type: .date)
        }
    }
}

final class ElasticsearchQueryTests: XCTestCase {
    func testExample() {
        let q = ESQuery<MyIndex>()
        
        q.query
            .bool
            .must(.term(field: .somefield, value: .text("somevalue")))
            .mustNot(.term(field: .otherfield, value: .text("othervalue")))
        
        q.aggs("somedatehistogram", .dateHistogram(field: .datefield, interval: .week))
        
        prettyPrint(query: q)
        prettyPrint(mapping: MyIndex.toMapping())
    }
    
    func prettyPrint(mapping: Mapping) {
        let encoder = JSONEncoder()
        prettyPrint(data: try! encoder.encode(mapping))
    }
    
    func prettyPrint(query: ESQuery<MyIndex>) {
        let encoder = JSONEncoder()
        prettyPrint(data: try! encoder.encode(query))
    }
    
    func prettyPrint(data: Data) {
        let obj = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        let jsonData = try! JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
        print(String(data: jsonData, encoding: .utf8)!)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
