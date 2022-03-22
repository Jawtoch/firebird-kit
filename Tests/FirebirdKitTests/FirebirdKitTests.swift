import XCTest
@testable import FirebirdKit

final class FirebirdKitTests: XCTestCase {
	
	private func encodeAndDecode<T>(_ value: T) throws -> T where T: Codable {
		let encoded = try FirebirdEncoder().encode(value)
		let decoded = try FirebirdDecoder().decode(T.self, from: encoded)
		return decoded
	}
	
	func testCodableBool() throws {
		for value in [true, false] {
			let decoded = try self.encodeAndDecode(value)
			XCTAssertEqual(value, decoded)
		}
	}

	func testCodableInt() throws {
		let values: [Int32] = [.min, .zero, .max]
		for value in values {
			let decoded = try self.encodeAndDecode(value)
			XCTAssertEqual(value, decoded)
		}
	}
	
	func testCodableRandomInt() throws {
		let value: Int32 = .random(in: .min ... .max)
		let decoded = try self.encodeAndDecode(value)
		XCTAssertEqual(value, decoded)
	}
	
	func testCodableString() throws {
		let value: String = "Hello, world!"
		let decoded = try self.encodeAndDecode(value)
		XCTAssertEqual(value, decoded)
	}
	
	func testCodableDate() throws {
		let values: [Date] = [.init(timeIntervalSince1970: 0), .init(), .distantFuture]
		for value in values {
			let decoded = try self.encodeAndDecode(value)
			XCTAssertEqual(floor(value.timeIntervalSince1970), floor(decoded.timeIntervalSince1970))
		}
	}
	
	func testCodableDouble() throws {
		let values: [Double] = [.pi, .zero]
		for value in values {
			let decoded = try self.encodeAndDecode(value)
			XCTAssertEqual(value, decoded)
		}
	}
	
	func testNonFirebirdCodable() throws {
		struct Dummy: Codable {
			let foo: String
			let bar: Int
		}
		
		let values: [Dummy] = [Dummy(foo: "one", bar: 1), Dummy(foo: "two", bar: 2)]
		for value in values {
			XCTAssertThrowsError(try FirebirdEncoder().encode(value))
		}
	}
	
	func testQuery() throws {
		let configuration = FirebirdConnectionConfiguration(
			host: FirebirdDatabaseHost(
				hostname: "localhost",
				port: 3050),
			username: "SYSDBA",
			password: "SMETHING",
			database: "employee")
		let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
		defer {
			try! eventLoopGroup.syncShutdownGracefully()
		}
		let eventLoop = eventLoopGroup.next()
		
		let connection = FirebirdNIOConnection.connect(configuration, on: eventLoop)
		
		let database = connection.map { FirebirdSQLDatabase(database: $0) }
		
		let query = database.map { $0.select().from("employee").column("first_name").where("last_name", .equal, ["Foo"])
		}
		
		let rows = try query.flatMap { $0.all() }.wait()
		
		for row in rows {
			let value = try row.decode(column: "FIRST_NAME", as: String.self)
			print(value)
		}
	}
	
    static var allTests = [
		("testCodableBool", testCodableBool),
		("testCodableInt", testCodableInt),
		("testCodableRandomInt", testCodableRandomInt),
		("testCodableString", testCodableString),
        ("testCodableDate", testCodableDate),
		("testCodableDouble", testCodableDouble),
    ]
}
