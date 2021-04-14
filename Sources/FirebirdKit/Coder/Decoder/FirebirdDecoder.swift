//
//  FirebirdDecoder.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

import Foundation

public struct FirebirdDecoder {
	
	public typealias Data = FirebirdData
	
	public enum FirebirdDecoderError: Error {
		case unsupportedOperation
		case unsupportedType(Any.Type)
		case unableToDecodeDataToType(FirebirdDecodable.Type)
	}
	
	public init() { }
	
	public func decode<T>(_ type: T.Type, from data: FirebirdDecoder.Data) throws -> T where T: Decodable {
		
		if let value = T.self as? FirebirdDecodable.Type {
			return try value.init(from: data) as! T
		}
		
		throw FirebirdDecoderError.unsupportedType(T.self)
	}
	
	private struct _Decoder: Decoder {
		
		let data: FirebirdDecoder.Data
		
		var codingPath: [CodingKey] = []
		
		var userInfo: [CodingUserInfoKey : Any] = [:]
		
		func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
			return KeyedDecodingContainer(_KeyedContainer(decoder: FirebirdDecoder(), data: self.data))
		}
		
		func unkeyedContainer() throws -> UnkeyedDecodingContainer {
			// TODO: support for array. While array type is not supported, this function will throw an unsupported error
			throw FirebirdDecoder.FirebirdDecoderError.unsupportedOperation
		}
		
		func singleValueContainer() throws -> SingleValueDecodingContainer {
			return _ValueContainer(decoder: self, data: self.data, codingPath: self.codingPath)
		}
		
	}
	
	private struct _UnkeyedContainer: UnkeyedDecodingContainer {
		
		let decoder: Decoder
		
		let array: [FirebirdDecoder.Data]
		
		var codingPath: [CodingKey] = []
		
		var count: Int? = 0
		
		var isAtEnd: Bool { self.currentIndex == self.array.count }
		
		var currentIndex: Int = 0
		
		mutating func decodeNil() throws -> Bool { false }
		
		mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
			defer { self.currentIndex += 1 }
			let data = self.array[self.currentIndex]
			return try FirebirdDecoder().decode(T.self, from: data)
		}
		
		mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
			throw FirebirdDecoder.FirebirdDecoderError.unsupportedOperation
		}
		
		mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
			throw FirebirdDecoder.FirebirdDecoderError.unsupportedOperation
		}
		
		mutating func superDecoder() throws -> Decoder {
			return self.decoder
		}
		
	}
			
	private struct _ValueContainer: SingleValueDecodingContainer {
		
		let decoder: Decoder
		
		let data: FirebirdDecoder.Data
		
		var codingPath: [CodingKey] = []
		
		func decodeNil() -> Bool {
			return self.data.value == nil
		}
		
		func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
			return try FirebirdDecoder().decode(T.self, from: self.data)
		}
		
	}
	
	private struct _KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
		
		let decoder: FirebirdDecoder
		
		let data: FirebirdData
		
		var codingPath: [CodingKey] = []
		
		var allKeys: [Key] = []
		
		func contains(_ key: Key) -> Bool {
			self.allKeys.contains { $0.stringValue == key.stringValue }
		}
		
		func decodeNil(forKey key: Key) throws -> Bool {
			return self.data.value == nil
		}
		
		func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
			try self.decoder.decode(T.self, from: self.data)
		}
		
		func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
			throw FirebirdDecoder.FirebirdDecoderError.unsupportedOperation
		}
		
		func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
			throw FirebirdDecoder.FirebirdDecoderError.unsupportedOperation
		}
		
		func superDecoder() throws -> Decoder {
			throw FirebirdDecoder.FirebirdDecoderError.unsupportedOperation
		}
		
		func superDecoder(forKey key: Key) throws -> Decoder {
			throw FirebirdDecoder.FirebirdDecoderError.unsupportedOperation
		}
		
	}
	
}
