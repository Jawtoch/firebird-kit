//
//  FirebirdDecodable.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

public protocol FirebirdDecodable: Decodable {
	
	init(from firebirdData: FirebirdData) throws
	
}
