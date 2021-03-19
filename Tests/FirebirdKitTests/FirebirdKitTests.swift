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

    static var allTests = [
        ("codableInt", testCodableInt),
		("codableString", testCodableString),
    ]
}
