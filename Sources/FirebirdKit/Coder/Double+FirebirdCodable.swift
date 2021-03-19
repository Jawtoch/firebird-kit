//
//  Double+FirebirdCodable.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

import Foundation

extension Double: FirebirdCodable {
	public static var firebirdDataType: FirebirdDataType { .int64 }
	
	public var firebirdData: FirebirdData {
		let bitsInEntirePart = Int(log(self) / log(10) + 1)
		let scale = 18 - bitsInEntirePart
		let multiplier = pow(10.0, Double(scale))
		var scaledValue = self * multiplier
		
		let data = withUnsafeBytes(of: &scaledValue) { buffer in
			return Data(buffer)
		}
		
		return FirebirdData(
			type: Self.firebirdDataType,
			scale: scale,
			value: data)
	}
	
	
}
