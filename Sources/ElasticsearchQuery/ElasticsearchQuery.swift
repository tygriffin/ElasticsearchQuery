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

public protocol ESIndex {
    static var shared: Self { get }
}

struct DynamicCodingKey: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.stringValue = ""
        self.intValue = intValue
    }
}

public enum QueryClause<Index: ESIndex>: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        switch self {
        case .term(let field, let value):
            var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: DynamicCodingKey(stringValue: "term")!)
            
            var nestedNested = nested.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: DynamicCodingKey(stringValue: Index.shared[keyPath: field].name)!)
            try nestedNested.encode(value, forKey: DynamicCodingKey(stringValue: "value")!)
        }
    }
    
    case term(field: KeyPath<Index, MappingField>, value: ESValue)
}

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

public struct Query<Index: ESIndex>: Encodable {
    enum CodingKeys: String, CodingKey {
        case bool
    }
    
    var bool = ESBool<Index>()
}

public enum Interval: String, Encodable {
    case week
    case month
    case year
}

public enum Agg<Index: ESIndex>: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        switch self {
        case .dateHistogram(let field, let interval):
            var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: DynamicCodingKey(stringValue: "dateHistogram")!)
            try nested.encode(Index.shared[keyPath: field].name, forKey: DynamicCodingKey(stringValue: "field")!)
            try nested.encode(interval, forKey: DynamicCodingKey(stringValue: "interval")!)
        }
    }
    
    case dateHistogram(field: KeyPath<Index, MappingField>, interval: Interval)
}

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

public enum MappingType: String, Encodable {
    case keyword
    case text
    case date
}

public struct MappingField: CustomStringConvertible, Encodable {
    public var description: String {
        return name
    }
    
    enum CodingKeys: CodingKey {
        case type
    }
    
    var name: String
    var type: MappingType
}

public typealias Mapping = Dictionary<String, MappingField>
extension Dictionary where Key == String, Value == MappingField {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        for (key, value) in self {
            try container.encode(value, forKey: DynamicCodingKey(stringValue: key)!)
        }
    }
}
