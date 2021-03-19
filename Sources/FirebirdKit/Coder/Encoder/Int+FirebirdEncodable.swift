//
//  Int+FirebirdEncodable.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

import Foundation

extension Int: FirebirdEncodable {
	public static var firebirdDataType: FirebirdDataType { .double }
	
	public var firebirdData: FirebirdData {
		var data: Data = Data()
		var copy = self
		
		
		withUnsafeBytes(of: &copy) { uself in
			data.append(contentsOf: uself)
		}
		
		return FirebirdData(
			type: Self.firebirdDataType,
			value: data)
	}
	
	
}
