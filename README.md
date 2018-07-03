# ElasticsearchQuery

Expressive, statically-typed syntax for writing Elasticsearch queries in Swift.

## Basic Usage:
```
let q = ESQuery<MyIndex>()
        
q.query
    .bool
    .must(.term(field: .somefield, value: .text("somevalue")))
    .mustNot(.term(field: .otherfield, value: .text("othervalue")))

q.aggs("somedatehistogram", .dateHistogram(field: .datefield, interval: .week))

```

## Index:
```
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
```