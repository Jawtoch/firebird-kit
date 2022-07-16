import Firebird
import SQLKit

public protocol FirebirdSQLDatabase: SQLDatabase {
	
	var database: FirebirdDatabase { get }
	
}

extension FirebirdSQLDatabase {
	
	public var logger: Logger {
		self.database.logger
	}
	
	public var eventLoop: EventLoop {
		self.database.eventLoop
	}
	
}
