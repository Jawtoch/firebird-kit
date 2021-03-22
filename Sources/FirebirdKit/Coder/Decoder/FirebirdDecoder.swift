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
		case unableToDecodeDataToType(FirebirdDecodable.Type)
	}
	
	public init() { }
	
	public func decode<T>(_ type: T.Type, from data: FirebirdDecoder.Data) throws -> T where T: Decodable {
		
		if let value = T.self as? FirebirdDecodable.Type {
			return try value.init(from: data) as! T
		}
		
		return try T.init(from: _Decoder(data: data))
	}
	
	private struct _Decoder: Decoder {
		
		let data: FirebirdDecoder.Data
		
		var codingPath: [CodingKey] = []
		
		var userInfo: [CodingUserInfoKey : Any] = [:]
		
		func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
			throw FirebirdDecoder.FirebirdDecoderError.unsupportedOperation
		}
		
		func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		
			// TODO: support for array. While array type is not supported, this function will throw an unsupported error
			throw FirebirdDecoder.FirebirdDecoderError.unsupportedOperation
//			return _UnkeyedContainer(decoder: self, array: [])
			
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
			return false
		}
		
		func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
			return try FirebirdDecoder().decode(T.self, from: self.data)
		}
		
		
	}
}
