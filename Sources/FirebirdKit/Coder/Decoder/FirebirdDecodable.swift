//
//  FirebirdDecodable.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

public protocol FirebirdDecodable: Decodable {
	
	init?(from firebirdData: FirebirdData) throws
	
}

extension Optional: FirebirdDecodable where Wrapped: FirebirdDecodable {
	
	public init?(from firebirdData: FirebirdData) throws {
		if firebirdData.value != nil {
			self = try Wrapped(from: firebirdData)
		} else {
			return nil
		}
	}
}
