import XCTest
@testable import FirebirdKit

final class FirebirdKitTests: XCTestCase {
	
	/// Test if an int is codable
	func testCodableInt() throws {
		let value: Int? = 87
		let encoder = FirebirdEncoder()
		try encoder.encode(value)
		guard let data = encoder.data else {
			throw XCTestError(XCTestError.Code.failureWhileWaiting)
		}
		
		let decoder = FirebirdDecoder(data: data)
		let decoded = try decoder.decode(Int?.self)
		XCTAssertEqual(value, decoded)
	}
	
	func testCodableString() throws {
		let value: String = "Hello, world!"
		let encoded = try FirebirdEncoder.encode(value)
		XCTAssertNotNil(encoded)
		
		let decoded = try FirebirdDecoder.decode(String.self, data: encoded!)
		XCTAssertEqual(value, decoded)
	}
	
	func testCodableDate() throws {
		let value: Date = Date()
		let encoded = try FirebirdEncoder.encode(value)
		XCTAssertNotNil(encoded)
		
		let decoded = try FirebirdDecoder.decode(Date.self, data: encoded!)
		XCTAssertEqual(value, decoded)
	}
	
	func testDateConversion() {
		let date: Date = Date()
		let ctime = date.tm_time
		let copy: Date? = Date(tm_time: ctime)
		XCTAssertNotNil(copy)

		XCTAssertEqual(Int(date.timeIntervalSince1970), Int(copy!.timeIntervalSince1970))
	}
	
	func testFooBar() {
		let value: Double = 123.05
		let data = value.firebirdData.value
		XCTAssertNotNil(data)
		
		print(value.firebirdData.description ,data!.map { String(format: "0x%02x", $0) }.joined(separator: ", "))
	}
	
    static var allTests = [
        ("codableInt", testCodableInt),
		("codableString", testCodableString),
    ]
}
