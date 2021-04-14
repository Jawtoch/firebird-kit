//
//  FirebirdSQLDatabase.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

public struct FirebirdSQLDatabase {
	
	/// Non blocking database that support query string
	public let database: FirebirdNIODatabase
	
	/// Encoder used to encode encodable data to firebird understandable data
	public let encoder: FirebirdEncoder
	
	/// Decoder used to decode firebird data to decodable data
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
	
	public var dialect: SQLDialect { FirebirdDialect() }
	
	public func execute(sql query: SQLExpression, _ onRow: @escaping (SQLRow) -> ()) -> EventLoopFuture<Void> {
		let promise = self.eventLoop.makePromise(of: Void.self)
		
		// TODO: - support for different type of expression (SELECT, UPDATE…)
		let (sql, binds) = self.serialize(query)
		do {
			let firebirdBinds = try binds.map { try self.encoder.encode($0) }
			self.database.query(sql, firebirdBinds) { onRow($0.sql(decoder: self.decoder)) }
				.cascade(to: promise)
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

public struct FirebirdSQLRow {
	
	public enum Error: Swift.Error {
		case noSuchColumn(String)
	}
	
	public let row: FirebirdRow
	public let decoder: FirebirdDecoder
	
	public func data(for column: String) throws -> FirebirdData {
		guard self.contains(column: column) else {
			throw FirebirdSQLRow.Error.noSuchColumn(column)
		}
		
		let column = self.row.values.first { $0.key == column }!
		return column.value
	}
	
}

extension FirebirdSQLRow: SQLRow {
	
	public var allColumns: [String] {
		Array(row.values.keys)
	}
	
	public func contains(column: String) -> Bool {
		return self.allColumns.contains(column)
	}
	
	public func decodeNil(column: String) throws -> Bool {
		guard self.contains(column: column) else {
			throw FirebirdSQLRow.Error.noSuchColumn(column)
		}
		
		let column = self.row.values.first { $0.key == column }!
		let firebirdData = column.value
		return firebirdData.value == nil
	}
	
	public func decode<D>(column: String, as type: D.Type) throws -> D where D : Decodable {
		let data = try self.data(for: column)
		return try self.decoder.decode(D.self, from: data)
	}
	
}

public extension FirebirdRow {
	
	func sql(decoder: FirebirdDecoder = .init()) -> SQLRow {
		return FirebirdSQLRow(row: self, decoder: decoder)
	}
	
}
