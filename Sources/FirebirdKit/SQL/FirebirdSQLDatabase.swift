//
//  FirebirdSQLDatabase.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

public protocol FirebirdSQLDatabase {
	
	var database: FirebirdDatabase { get }
	
	var encoder: FirebirdEncoder { get }
	
	var decoder: FirebirdDecoder { get }
}
