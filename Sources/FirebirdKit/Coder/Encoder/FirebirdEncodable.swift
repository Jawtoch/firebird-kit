//
//  FirebirdEncodable.swift
//  
//
//  Created by Ugo Cottin on 17/03/2021.
//

/// A protocol for types which can be encoded to firebird type.
public protocol FirebirdEncodable: Encodable {
		
	/// FirebirdData associated to this value
	static var firebirdDataType: FirebirdDataType { get }
	
	var firebirdData: FirebirdData { get }
}

/// Implementation for optional types, who conforms to `FirebirdEncodable`
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
