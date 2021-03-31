//
//  FirebirdSQLDatabase.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

public struct FirebirdSQLDatabase {
	
	public let database: FirebirdNIODatabase
	
	public let encoder: FirebirdEncoder
	
	public let decoder: FirebirdDecoder
	
	public init(
		database: FirebirdNIODatabase,
		encoder: FirebirdEncoder = FirebirdEncoder(),
		decoder: FirebirdDecoder = FirebirdDecoder()) {
		self.database = database
		self.encoder = encoder
		self.decoder = decoder
	}
}

extension FirebirdSQLDatabase: SQLDatabase {
	public var logger: Logger { self.database.logger }
	
	public var eventLoop: EventLoop { self.database.eventLoop }
	
	public var dialect: SQLDialect { FirebirdDialect( )}
	
	public func execute(sql query: SQLExpression, _ onRow: @escaping (SQLRow) -> ()) -> EventLoopFuture<Void> {
		let promise = self.eventLoop.makePromise(of: Void.self)
		
		let (sql, binds) = self.serialize(query)
		do {
			let firebirdBinds = try binds.map { try self.encoder.encode($0) }
			self.database.query(sql, firebirdBinds) { print($0) }
				.cascade(to: promise)
//			return self.database.query(
//				sql,
//				firebirdBinds,
//				onMetadata: { print("Metadata: \($0)") },
//				onRow: { print("Row: \($0)") })
//				.map { _ in }
//
		} catch {
			promise.fail(error)
		}
		
		return promise.futureResult
	}
	
	public func serialize(_ expression: SQLExpression) -> (sql: String, binds: [Encodable]) {
		var serializer = SQLSerializer(database: self)
		expression.serialize(to: &serializer)
		return (serializer.sql, serializer.binds)
	}
}
