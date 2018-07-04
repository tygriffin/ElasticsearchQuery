# ElasticsearchQuery

Expressive, statically-typed syntax for writing Elasticsearch queries in Swift.

## Basic Usage:
```
let q = ESQuery<MyIndex>()
        
q.query
    .bool
    .must(.term(field: \.somefield, value: .text("somevalue")))
    .mustNot(.term(field: \.otherfield, value: .text("othervalue")))

q.aggs("somedatehistogram", .dateHistogram(field: \.datefield, interval: .week))

```

## Index:
```
struct MyIndex: ESIndex, Encodable {
    let somefield = MappingField(name: "somefield", type: .keyword)
    let otherfield = MappingField(name: "otherfield", type: .text)
    let datefield = MappingField(name: "datefield", type: .date)
    
    static let shared = MyIndex()
    
    private init() {}
}
```