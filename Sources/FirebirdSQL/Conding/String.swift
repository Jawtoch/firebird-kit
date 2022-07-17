import Firebird
import Foundation

extension String: FirebirdDataConvertible {
	
	public init(firebirdData: FirebirdData) throws {
		switch firebirdData.metadata.type {
			case .text:
				self = try _decodeFromText(firebirdData: firebirdData)
			default:
				throw FirebirdDataConvertionError.typeMismatch
		}
	}
	
	public func firebirdData(metadata: FirebirdData.Metadata) throws -> Data? {
		switch metadata.type {
			case .text:
				return try _encodeForText(value: self)
			default:
				throw FirebirdDataConvertionError.typeMismatch
		}
	}
	
	
}

fileprivate func _encodeForText(value: String) throws -> Data {
	guard let data = value.data(using: .utf8) else {
		throw FirebirdDataConvertionError.dataRequired
	}
	
	return data
}

fileprivate func _decodeFromText(firebirdData: FirebirdData) throws -> String {
	guard let data = firebirdData.value else {
		throw FirebirdDataConvertionError.dataRequired
	}
	
	guard let value = String(data: data, encoding: .utf8) else {
		throw FirebirdDataConvertionError.typeMismatch
	}
	
	return value
}
