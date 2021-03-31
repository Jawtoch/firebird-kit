import XCTest
@testable import FirebirdKit

final class FirebirdKitTests: XCTestCase {
	
	/// Test if an int is codable
	func testCodableInt() throws {
		let value: Int? = 87
		let encoded = try FirebirdEncoder().encode(value)
		let decoded = try FirebirdDecoder().decode(Int?.self, from: encoded)
		XCTAssertEqual(value, decoded)
	}
	
	func testCodableString() throws {
		let value: String = "Hello, world!"
		let encoded = try FirebirdEncoder.encode(value)
		XCTAssertNotNil(encoded)
		
		let decoded = try FirebirdDecoder().decode(String.self, from: encoded!)
		XCTAssertEqual(value, decoded)
	}
	
	func testCodableDate() throws {
		let value: Date = Date()
		let encoded = try FirebirdEncoder.encode(value)
		XCTAssertNotNil(encoded)
		
		let decoded = try FirebirdDecoder().decode(Date.self, from: encoded!)
		XCTAssertEqual(Int(value.timeIntervalSince1970), Int(decoded.timeIntervalSince1970))
	}
	
	func testDateConversion() {
		let date: Date = Date()
		let ctime = date.tm_time
		let copy: Date? = Date(tm_time: ctime)
		XCTAssertNotNil(copy)

		XCTAssertEqual(Int(date.timeIntervalSince1970), Int(copy!.timeIntervalSince1970))
	}
	
	func testSQLDatabase() {
		let eventLoop = EmbeddedEventLoop()
		let logger = Logger(label: "dev.firebird.test")
		let connection = FirebirdNIOConnection.connect(
			FirebirdConnectionConfiguration(hostname: "localhost", port: 3051, username: "SYSDBA", password: "MASTERKEY", database: "EMPLOYEE"),
			logger: logger,
			on: eventLoop)
		
		let database = connection.map { conn -> FirebirdSQLDatabase in
			return FirebirdSQLDatabase(database: conn)
		}
		
		database.whenFailure { error in
			print(error)
			XCTAssert(false)
		}
		
		XCTAssertNoThrow {
			let _ = try database.wait()
		}
	}

    static var allTests = [
        ("codableInt", testCodableInt),
		("codableString", testCodableString),
    ]
}
