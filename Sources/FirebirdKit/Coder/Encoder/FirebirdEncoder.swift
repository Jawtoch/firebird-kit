//
//  FirebirdEncoder.swift
//  
//
//  Created by Ugo Cottin on 17/03/2021.
//

public struct FirebirdEncoder {
	
	public typealias Data = FirebirdData
	
	public enum FirebirdEncoderError: Error {
		case unsupportedOperation
		case unsupportedType(Any.Type)
	}
	
	public init() { }
	
	private final class FirebirdEncoderContext {
		var value: FirebirdEncoder.Data?
		var array: [FirebirdEncoder.Data]?
		var keyedArray: [(CodingKey, FirebirdEncoder.Data)]?
		
		init() { }
	}
	
	private struct _Encoder: Encoder {
		
		let context: FirebirdEncoderContext
		
		var codingPath: [CodingKey] = []
		
		var userInfo: [CodingUserInfoKey : Any] = [:]
		
		func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
			self.context.keyedArray = []
			return KeyedEncodingContainer(_KeyedContainer(encoder: self, context: self.context, codingPath: self.codingPath))
		}
		
		func unkeyedContainer() -> UnkeyedEncodingContainer {
			self.context.array = []
			return _UnkeyedContainer(encoder: self, context: self.context, codingPath: self.codingPath)
		}
		
		func singleValueContainer() -> SingleValueEncodingContainer {
			return _ValueContainer(encoder: self, context: self.context, codingPath: self.codingPath)
		}
	}
	
	private struct _UnkeyedContainer: UnkeyedEncodingContainer {
		
		let encoder: Encoder
		
		let context: FirebirdEncoderContext
		
		var codingPath: [CodingKey] = []
		
		var count: Int = 0
		
		mutating func encode<T>(_ value: T) throws where T : Encodable {
			try self.context.array!.append(FirebirdEncoder().encode(value))
		}
		
		mutating func encodeNil() throws { }
		
		mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
			fatalError()
		}
		
		mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
			fatalError()
		}
		
		mutating func superEncoder() -> Encoder {
			return self.encoder
		}
	}
	
	private struct _KeyedContainer<Key>: KeyedEncodingContainerProtocol where Key: CodingKey {
		
		let encoder: Encoder
		
		let context: FirebirdEncoderContext
		
		var codingPath: [CodingKey] = []
		
		mutating func encodeNil(forKey key: Key) throws { }
		
		mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
			try self.context.keyedArray!
				.append((key, FirebirdEncoder().encode(value)))
		}
		
		mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
			fatalError()
		}
		
		mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
			fatalError()
		}
		
		mutating func superEncoder() -> Encoder {
			return self.encoder
		}
		
		mutating func superEncoder(forKey key: Key) -> Encoder {
			return self.encoder
		}
		
	}
	
	private struct _ValueContainer: SingleValueEncodingContainer {
		
		let encoder: Encoder
		
		let context: FirebirdEncoderContext
		
		var codingPath: [CodingKey] = []
		
		mutating func encodeNil() throws { }
		
		mutating func encode<T>(_ value: T) throws where T : Encodable {
			self.context.value = try FirebirdEncoder().encode(value)
		}
		
		
	}
	
	
	public func encode(_ value: Encodable) throws -> Data {
		if let value = value as? FirebirdEncodable {
			return value.firebirdData
		}
		
		let context = FirebirdEncoderContext()
		try value.encode(to: _Encoder(context: context))
		
		if let value = context.value {
			return value
		}
		
		if let _ = context.array {
			throw FirebirdEncoderError.unsupportedOperation
		}
		
		if let _ = context.keyedArray {
			throw FirebirdEncoderError.unsupportedOperation
		}
		
		throw FirebirdEncoderError.unsupportedType(type(of: value))
	}
}

public extension FirebirdEncoder {
	
	static func encode(_ value: FirebirdEncodable) throws -> FirebirdEncoder.Data? {
		return try FirebirdEncoder().encode(value)
	}
}
