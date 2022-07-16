import SQLKit

public struct FirebirdSQLDialect: SQLDialect {
	
	public var name: String { "firebirdsql" }
	
	public var identifierQuote: SQLExpression { SQLRaw("") }
	
	public var supportsAutoIncrement: Bool { false }
	
	public var autoIncrementClause: SQLExpression { fatalError() }
	
	public var enumSyntax: SQLEnumSyntax { .unsupported }
	
	public init() { }
	
	public func bindPlaceholder(at position: Int) -> SQLExpression { SQLRaw("?") }
	
	public func literalBoolean(_ value: Bool) -> SQLExpression {
		value ? SQLRaw("1") : SQLRaw("0")
	}
	
}
