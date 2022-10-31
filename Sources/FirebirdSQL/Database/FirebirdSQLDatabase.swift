import FirebirdNIO
import SQLKit

public protocol FirebirdSQLDatabase: SQLDatabase {
    
    var database: FirebirdNIODatabase { get }
    
}

extension FirebirdSQLDatabase {
    
    public var logger: Logger {
        self.database.logger
    }
    
    public var eventLoop: EventLoop {
        self.database.eventLoop
    }
    
}

extension FirebirdNIODatabase {

    public func sql(dialect: SQLDialect) -> FirebirdSQLDatabase {
        FBSQLDatabase(self, dialect: FirebirdSQLDialect())
    }

}
