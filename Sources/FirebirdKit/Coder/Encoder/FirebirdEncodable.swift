//
//  FirebirdEncodable.swift
//  
//
//  Created by Ugo Cottin on 17/03/2021.
//

/// A protocol for types which can be encoded to firebird type.
public protocol FirebirdEncodable: Encodable {
	
	/// Encodes this value into the given FirebirdEncoder encoder.
	/// - Parameter encoder: given FirebirdEncoder
	func firebirdEncode(to encoder: FirebirdEncoder) throws
	
	/// FirebirdData associated to this value
	static var firebirdDataType: FirebirdDataType { get }
	
	var firebirdData: FirebirdData { get }
}

/// Provide a default implementation which calls through to `Encodable`. This
/// allows `FirebirdEncodable` to use the `Encodable` implementation generated by the
/// compiler.
public extension FirebirdEncodable {
	func firebirdEncode(to encoder: FirebirdEncoder) throws {
		try self.encode(to: encoder)
	}
}

extension Optional: FirebirdEncodable where Wrapped: FirebirdEncodable {
	public static var firebirdDataType: FirebirdDataType {
		Wrapped.firebirdDataType
	}
	
	public var firebirdData: FirebirdData {
		if let value = self {
			return value.firebirdData
		}
		
		return FirebirdData(type: Self.firebirdDataType)
	}
	
	
}

import Foundation
extension Int: FirebirdEncodable {
	public static var firebirdDataType: FirebirdDataType { .double }
	
	public var firebirdData: FirebirdData {
		var data: Data = Data()
		var copy = self
		
		
		withUnsafeBytes(of: &copy) { uself in
			data.append(contentsOf: uself)
		}
		
		return FirebirdData(
			type: Self.firebirdDataType,
			value: data)
	}
	
	
}