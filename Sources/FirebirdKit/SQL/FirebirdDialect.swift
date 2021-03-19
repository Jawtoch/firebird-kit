//
//  FirebirdDialect.swift
//  
//
//  Created by Ugo Cottin on 16/03/2021.
//

import SQLKit

public struct FirebirdDialect: SQLDialect {
	public var name: String { "firebirdsql" }
	
	public var identifierQuote: SQLExpression { SQLRaw("") }
	
	public var autoIncrementClause: SQLExpression {
		SQLRaw("")
	}
	
	public func bindPlaceholder(at position: Int) -> SQLExpression {
		SQLRaw("?")
	}
	
	public func literalBoolean(_ value: Bool) -> SQLExpression {
		value ? SQLRaw("1") : SQLRaw("0")
	}
	
	public var supportsAutoIncrement: Bool { false }
	
	public var enumSyntax: SQLEnumSyntax { .unsupported }
	
	
}
