import XCTest
@testable import ElasticsearchQuery

struct MyIndex: ESIndex, Encodable {
    let somefield = MappingField(name: "somefield", type: .keyword)
    let otherfield = MappingField(name: "otherfield", type: .text)
    let datefield = MappingField(name: "datefield", type: .date)
    
    static let shared = MyIndex()
    
    private init() {}
}

final class ElasticsearchQueryTests: XCTestCase {
    func testExample() {
        let q = ESQuery<MyIndex>()
        
        q.query
            .bool
            .must(
                .term(field: \.somefield, value: .text("somevalue")),
                .match(field: \.otherfield, value: .text("match")),
                .range(field: \.datefield, value: [
                    .gt: .date("2017-03-01"),
                    .lte: .date("2018-04-2")
                ])
            )
            .mustNot(
                .term(field: \.otherfield, value: .text("othervalue"))
            )
        
        q.aggs("somedatehistogram", .dateHistogram(field: \.datefield, interval: .week))
        
        q.sort(field: \.somefield, order: .asc)
        
        q._source = [\.somefield, \.otherfield]
        
        prettyPrint(query: q)
        prettyPrint(mapping: MyIndex.shared)
    }
    
    func prettyPrint(mapping: MyIndex) {
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
