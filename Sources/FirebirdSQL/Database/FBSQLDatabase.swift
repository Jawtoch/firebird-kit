import FirebirdNIO
import SQLKit

public struct FBSQLDatabase: FirebirdSQLDatabase {
    
    public let database: FirebirdNIODatabase
    
    public let dialect: SQLDialect
        
    init(_ database: FirebirdNIODatabase, dialect: SQLDialect) {
        self.database = database
        self.dialect = dialect
    }
    
    public func execute(sql query: SQLExpression, _ onRow: @escaping (SQLRow) -> ()) -> EventLoopFuture<Void> {
        let (sql, binds) = self.serialize(query)
        
        return self.database.query(sql, binds, onRow: onRow)
    }
    
}
