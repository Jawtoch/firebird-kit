import XCTest
@testable import FirebirdKit

final class FirebirdKitTests: XCTestCase {
    func testExample() {
		class Database: FirebirdDatabase {
			var configuration: FirebirdDatabaseConfiguration
			
			init(_ configuration: FirebirdDatabaseConfiguration) {
				self.configuration = configuration
			}
		}
		
		let configuration = FirebirdDatabaseConfiguration(hostname: "localhost", port: 3051, username: "SYSDBA", password: "MASTERKEY", database: "EMPLOYEE")
		
		let database = Database(configuration)
		do {
			let result = try database.query("***REMOVED***")
			print(result.rows)
		} catch {
			print(error)
		}

        XCTAssertEqual(FirebirdKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
