//
//  FirebirdDataDecoder.swift
//  
//
//  Created by Ugo Cottin on 16/03/2021.
//

public protocol FirebirdDataDecoder {
	
	func decode<T>(_ type: T.Type, from data: FirebirdData) throws -> T
	
}
