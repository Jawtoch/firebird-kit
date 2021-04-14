//
//  Exports.swift
//  
//
//  Created by Ugo Cottin on 16/03/2021.
//

@_exported import FirebirdNIO
@_exported import SQLKit

import Foundation

extension Data {
	
	var hexDescription: String {
		self.map { String(format: "%02x", $0) }.joined(separator: ", ")
	}
	
}
