//
//  Int+FirebirdCodable.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

import Foundation

extension Int16: FirebirdCodable {
	
	public static var firebirdDataType: FirebirdDataType { .short }
	
	public var firebirdData: FirebirdData {
		var copy = self
		let data = withUnsafeBytes(of: &copy) { Data($0) }
		
		return FirebirdData(type: Self.firebirdDataType, value: data)
	}
	
	public init(from firebirdData: FirebirdData) throws {
		guard let value = firebirdData.short else {
			throw FirebirdDecoder.FirebirdDecoderError.unableToDecodeDataToType(Self.self)
		}
		
		self = value
	}
	
}

extension Int32: FirebirdCodable {
	
	public static var firebirdDataType: FirebirdDataType { .long }
	
	public var firebirdData: FirebirdData {
		var copy = self
		let data = withUnsafeBytes(of: &copy) { Data($0) }
		
		return FirebirdData(type: Self.firebirdDataType, value: data)
	}
	
	public init(from firebirdData: FirebirdData) throws {
		guard let longValue = firebirdData.long else {
			throw FirebirdDecoder.FirebirdDecoderError.unableToDecodeDataToType(Self.self)
		}
		
		self = longValue
	}
	
}

extension Int: FirebirdCodable {
	
	public static var firebirdDataType: FirebirdDataType { .long }
	
	public var firebirdData: FirebirdData {
//		let int16Range = Int(Int16.min) ... Int(Int16.max)
		let int32Range = Int(Int32.min) ... Int(Int32.max)
		
//		if int16Range.contains(self) {
//			return Int16(self).firebirdData
//		}
		
		if int32Range.contains(self) {
			return Int32(self).firebirdData
		}
		
		var copy = self
		let data = withUnsafeBytes(of: &copy) { Data($0) }
		
		return FirebirdData(type: Self.firebirdDataType, value: data)
	}
	
	public init(from firebirdData: FirebirdData) throws {
		switch firebirdData.type {
			case .short:
				if let shortValue = firebirdData.short {
					self = Int(shortValue)
					return
				}
			case .long:
				if let longValue = firebirdData.long {
					self = Int(longValue)
					return
				}
			default:
				throw FirebirdDecoder.FirebirdDecoderError.unableToDecodeDataToType(Self.self)
		}
		
		throw FirebirdDecoder.FirebirdDecoderError.unableToDecodeDataToType(Self.self)
	}
	
}

