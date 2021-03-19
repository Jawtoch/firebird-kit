//
//  String+FirebirdCodable.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

import Foundation

extension String: FirebirdCodable {
	
	public init(from firebirdData: FirebirdData) throws {
		guard let value = firebirdData.string else {
			throw FirebirdDecoder.FirebirdDecoderError.unableToDecodeDataToType(Self.self)
		}
		
		self = value
	}
	
	public static var firebirdDataType: FirebirdDataType { .text }
	
	public var firebirdData: FirebirdData {
		return FirebirdData(type: Self.firebirdDataType, value: self.data(using: .utf8))
	}
}
