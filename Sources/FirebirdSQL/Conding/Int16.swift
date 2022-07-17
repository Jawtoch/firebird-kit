import Firebird
import Foundation

extension Int16: FirebirdDataConvertible {

	public init(firebirdData: FirebirdData) throws {
		switch firebirdData.metadata.type {
			case .int16:
				self = try _decodeFromInt16(firebirdData: firebirdData)
			default:
				throw FirebirdDataConvertionError.typeMismatch
		}
	}
	
	public func firebirdData(metadata: FirebirdData.Metadata) throws -> Data? {
		switch metadata.type {
			case .int16:
				return _encodeForInt16(value: self)
			default:
				throw FirebirdDataConvertionError.typeMismatch
		}
	}
	
}

fileprivate func _encodeForInt16(value: Int16) -> Data {
	let encoded = withUnsafeBytes(of: value) { unsafeSelf in
		Data(unsafeSelf)
	}
	
	return encoded
}

fileprivate func _decodeFromInt16(firebirdData: FirebirdData) throws -> Int16 {
	guard let data = firebirdData.value else {
		throw FirebirdDataConvertionError.dataRequired
	}
	
	let decoded = data.withUnsafeBytes { unsafeData in
		unsafeData.load(as: Int16.self)
	}
	
	return decoded
}
