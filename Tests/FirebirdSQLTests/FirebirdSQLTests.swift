import Logging
import Firebird
import NIO
import XCTest

@testable import FirebirdSQL

final class FirebirdSQLTests: XCTestCaseInEventLoop {

	var hostname: String {
		"localhost"
	}
	
	var port: UInt16 {
		3050
	}
	
	var path: String {
		"employee"
	}
	
	var username: String {
		"SYSDBA"
	}
	
	var password: String {
		"SMETHING"
	}
	
	var logger: Logger {
		.init(label: "test.firebirdsql")
	}
	
	var connection: FBConnection!
	
	var database: FirebirdDatabase {
		self.connection
	}
	
	var target: FirebirdConnectionConfiguration.Target {
		.remote(
			hostName: self.hostname,
			port: self.port,
			path: self.path)
	}
	
	var parameters: [FirebirdConnectionParameter] {
		[
			.version1,
			.username(self.username),
			.password(self.password)
		]
	}
	
	var configuration: FirebirdConnectionConfiguration {
		.init(
			target: self.target,
			parameters: self.parameters)
	}
	
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		let connection = FBConnection(
			configuration: self.configuration,
			logger: self.logger,
			on: self.eventLoop)
		
		try connection.connect().wait()
		self.connection = connection
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
		try self.connection.close().wait()
		self.connection = nil
	}
	
	func testInt16() throws {
		let originalValue: Int16 = 9
		let decodedValue = try self.database.query("SELECT emp_no FROM employee WHERE emp_no = ?", binds: [originalValue])
			.map { $0.first! }
			.map { $0.sql() }
			.flatMapThrowing { try $0.decode(column: "EMP_NO", as: Int16.self) }
			.wait()
		
		XCTAssertEqual(originalValue, decodedValue)
	}
	
	func testText() throws {
		let originalValue: String = "Katherine"
		let decodedValue = try self.database.query("SELECT first_name FROM employee WHERE first_name = ?", binds: [originalValue])
			.map { $0.first! }
			.map { $0.sql() }
			.flatMapThrowing { try $0.decode(column: "FIRST_NAME", as: String.self) }
			.wait()
		
		XCTAssertEqual(originalValue, decodedValue)
	}
		
}
