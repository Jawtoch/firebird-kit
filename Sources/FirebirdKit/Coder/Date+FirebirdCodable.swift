//
//  Date+FirebirdCodable.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

import Foundation

extension Date: FirebirdCodable {
	public static var firebirdDataType: FirebirdDataType { .timestamp }
	
	public var firebirdData: FirebirdData {
		var tm_time = self.tm_time
		
		var date = ISC_TIMESTAMP()
		
		isc_encode_timestamp(&tm_time, &date)
		
		let data = withUnsafeBytes(of: &date) { buffer in
			return Data(buffer)
		}
		
		return FirebirdData(type: Self.firebirdDataType, value: data)
	}
	
	public init(from firebirdData: FirebirdData) throws {
		guard let value = firebirdData.date else {
			throw FirebirdDecoder.FirebirdDecoderError.unableToDecodeDataToType(Self.self)
		}
		
		self = value
	}
	
	
}
