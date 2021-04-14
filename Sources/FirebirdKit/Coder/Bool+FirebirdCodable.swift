//
//  Bool+FirebirdCodable.swift
//  
//
//  Created by Ugo Cottin on 11/04/2021.
//

import Foundation

extension Bool: FirebirdCodable {
	public static var firebirdDataType: FirebirdDataType { .short }
	
	public var firebirdData: FirebirdData {
		let value: Int16 = self ? 1 : 0
		return value.firebirdData
	}
	
	public init(from firebirdData: FirebirdData) throws {
		guard let value = firebirdData.short else {
			throw FirebirdDecoder.FirebirdDecoderError.unableToDecodeDataToType(Self.self)
		}
		
		self = value == 1
	}
	
}
