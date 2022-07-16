import AsyncKit
import Firebird
import SQLKit

public struct FBSQLDatabase: FirebirdSQLDatabase {
	
	public enum Error: FirebirdSQLError {
		case invalidBind(_: Encodable)
	}
	
	public let database: FirebirdDatabase
	
	public let dialect: SQLDialect
	
	public func execute(sql query: SQLExpression, _ onRow: @escaping (SQLRow) -> ()) -> EventLoopFuture<Void> {
		let (sql, encodableBinds) = self.serialize(query)
		
		return self.makeBinds(encodableBinds)
			.flatMap { self.database.query(sql, binds: $0) }
			.mapEach { $0.sql() }
			.mapEach { onRow($0) }
			.transform(to: self.eventLoop.makeSucceededVoidFuture())
	}
	
	private func makeBinds(_ encodables: [Encodable]) -> EventLoopFuture<[FirebirdDataConvertible]> {
		self.eventLoop.submit {
			try encodables.map { encodable in
				guard let convertible = encodable as? FirebirdDataConvertible else {
					throw Error.invalidBind(encodable)
				}
				
				return convertible
			}
		}
	}
	
}

extension FirebirdDatabase {
	
	public func sql() -> FirebirdSQLDatabase {
		FBSQLDatabase(database: self.self, dialect: FirebirdSQLDialect())
	}
	
}
