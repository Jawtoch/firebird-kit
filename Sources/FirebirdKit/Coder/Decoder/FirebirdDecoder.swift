//
//  FirebirdDecoder.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

public class FirebirdDecoder {
	
	public typealias Data = FirebirdData
	
	public let data: Data
	
	public init(data: Data) {
		self.data = data
	}
}

public extension FirebirdDecoder {
	
	static func decode<T>(_ type: T.Type, data: Data) throws -> T where T: Decodable {
		return try FirebirdDecoder(data: data).decode(T.self)
	}
	
}

public extension FirebirdDecoder {
	
	func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
		
		switch type {
			case is Int.Type, is Int?.Type:
				return self.data.long as! T
			default:
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "ça marche po"))
		}

	}

}

extension FirebirdDecoder: Decoder {
	
	public var codingPath: [CodingKey] { [] }
	
	public var userInfo: [CodingUserInfoKey : Any] { [:] }
	
	public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
		return KeyedDecodingContainer(KeyedContainer(decoder: self, codingPath: [], allKeys: []))
	}
	
	public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		return UnkeyedContainer(decoder: self)
	}
	
	public func singleValueContainer() throws -> SingleValueDecodingContainer {
		return UnkeyedContainer(decoder: self)
	}
	
	private struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
		
		let decoder: FirebirdDecoder
		
		var codingPath: [CodingKey]
		
		var allKeys: [Key]
		
		func contains(_ key: Key) -> Bool {
			true
		}
		
		func decodeNil(forKey key: Key) throws -> Bool {
			true
		}
		
		func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
			return try self.decoder.decode(T.self)
		}
		
		func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
			try self.decoder.container(keyedBy: type)
		}
		
		func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
			try self.decoder.unkeyedContainer()
		}
		
		func superDecoder() throws -> Decoder {
			self.decoder
		}
		
		func superDecoder(forKey key: Key) throws -> Decoder {
			self.decoder
		}
		
		
	}
	
	private struct UnkeyedContainer: UnkeyedDecodingContainer, SingleValueDecodingContainer {

		let decoder: FirebirdDecoder
		
		var codingPath: [CodingKey] = []
		
		var count: Int? = nil
		
		var isAtEnd: Bool = false
		
		var currentIndex: Int = 0
		
		func decodeNil() -> Bool {
			return true
		}

		func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
			return try self.decoder.decode(T.self)
		}
		
		mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
			return try self.decoder.container(keyedBy: type)
		}
		
		mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
			return try self.decoder.unkeyedContainer()
		}
		
		mutating func superDecoder() throws -> Decoder {
			return self.decoder
		}
		
	}
}
