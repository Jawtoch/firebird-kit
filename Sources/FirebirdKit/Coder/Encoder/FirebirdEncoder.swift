//
//  FirebirdEncoder.swift
//  
//
//  Created by Ugo Cottin on 17/03/2021.
//

public class FirebirdEncoder {
	
	public var data: FirebirdData? = nil
	
	public init() { }
}

public extension FirebirdEncoder {
	
	static func encode(_ value: FirebirdEncodable) throws -> FirebirdData? {
		let encoder = FirebirdEncoder()
		try value.firebirdEncode(to: encoder)
		return encoder.data
	}
}

public extension FirebirdEncoder {
	
	func encode<T>(_ value: T) throws where T: Encodable {
		
		if let value = value as? FirebirdEncodable {
			self.data = value.firebirdData
		} else {
			print(T.Type.self)
			throw EncodingError.invalidValue(value, EncodingError.Context.init(codingPath: self.codingPath, debugDescription: "ça marche po"))
		}
	}
	
}


extension FirebirdEncoder: Encoder {
	
	public var codingPath: [CodingKey] { [] }
	
	public var userInfo: [CodingUserInfoKey : Any] { [:] }
	
	public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
		let container = KeyedContainer<Key>(encoder: self, codingPath: self.codingPath)
		return .init(container)
	}
	
	public func unkeyedContainer() -> UnkeyedEncodingContainer {
		return UnkeyedContainer(encoder: self, codingPath: self.codingPath)
	}
	
	public func singleValueContainer() -> SingleValueEncodingContainer {
		return UnkeyedContainer(encoder: self, codingPath: self.codingPath)
	}
	
	private struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
		
		let encoder: FirebirdEncoder
		
		var codingPath: [CodingKey]
		
		mutating func encodeNil(forKey key: Key) throws { }
		
		mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
			try self.encoder.encode(value)
		}
		
		mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
			self.encoder.container(keyedBy: keyType)
		}
		
		mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
			self.encoder.unkeyedContainer()
		}
		
		mutating func superEncoder() -> Encoder {
			self.encoder
		}
		
		mutating func superEncoder(forKey key: Key) -> Encoder {
			encoder
		}

	}
	
	private struct UnkeyedContainer: UnkeyedEncodingContainer, SingleValueEncodingContainer {
		
		let encoder: FirebirdEncoder
		
		var codingPath: [CodingKey] = []
		
		var count: Int = 0
		
		mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
			self.encoder.container(keyedBy: keyType)
		}
		
		mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
			self.encoder.unkeyedContainer()
		}
		
		mutating func superEncoder() -> Encoder {
			self.encoder
		}
		
		mutating func encode<T>(_ value: T) throws where T : Encodable {
			try self.encoder.encode(value)
		}

		mutating func encodeNil() throws {
			
		}
		
	}
	
}
