//
//  FirebirdDecodable.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

public protocol FirebirdDecodable: Decodable {
	
	init(fromFirebird decoder: FirebirdDecoder) throws
	
}

public extension FirebirdDecodable {
	
	init(fromFirebird decoder: FirebirdDecoder) throws {
		try self.init(from: decoder)
	}
	
}
