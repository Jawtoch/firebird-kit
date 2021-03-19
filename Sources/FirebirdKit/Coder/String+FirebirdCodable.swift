//
//  String+FirebirdCodable.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

import Foundation

extension String: FirebirdCodable {
	public static var firebirdDataType: FirebirdDataType { .text }
	
	public var firebirdData: FirebirdData {
		return FirebirdData(type: Self.firebirdDataType, value: self.data(using: .utf8))
	}
}
