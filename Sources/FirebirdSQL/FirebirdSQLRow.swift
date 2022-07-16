import Firebird
import SQLKit

public struct FirebirdSQLRow: SQLRow {
		
	public enum Error: FirebirdSQLError {
		case unknownColumn(_: String)
		case emptyColumn(_: String)
		case invalidType(_: Decodable.Type)
		case typeMismatch
	}
	
	public let row: FirebirdRow
	
	public var allColumns: [String] {
		self.row.columns
	}
	
	public func contains(column: String) -> Bool {
		self.row.contains(column: column)
	}
	
	public func decodeNil(column: String) throws -> Bool {
		guard self.contains(column: column) else {
			throw Error.unknownColumn(column)
		}
		
		guard let field = self.row.field(ofColumn: column) else {
			throw Error.emptyColumn(column)
		}
		
		return field.data.value == nil
	}
	
	public func decode<D>(column: String, as type: D.Type) throws -> D where D : Decodable {
		guard self.contains(column: column) else {
			throw Error.unknownColumn(column)
		}
		
		guard let field = self.row.field(ofColumn: column) else {
			throw Error.emptyColumn(column)
		}
		
		guard let Convertible = D.self as? FirebirdDataConvertible.Type else {
			throw Error.invalidType(D.self)
		}
		
		guard let decoded = try Convertible.init(firebirdData: field.data) as? D else {
			throw Error.typeMismatch
		}
		
		return decoded
	}
	
}

extension FirebirdRow {
	
	func sql() -> SQLRow {
		FirebirdSQLRow(row: self)
	}
	
}
