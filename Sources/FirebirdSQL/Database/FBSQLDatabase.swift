import FirebirdNIO
import SQLKit

public struct FBSQLDatabase: FirebirdSQLDatabase {

    public let database: FirebirdNIODatabase

    public let dialect: SQLDialect

    init(_ database: FirebirdNIODatabase, dialect: SQLDialect) {
        self.database = database
        self.dialect = dialect
    }

    public func execute(sql query: SQLExpression, _ onRow: @escaping (SQLRow) -> Void) -> EventLoopFuture<Void> {
        var (sql, binds) = self.serialize(query)

        let limitRange = sql.range(of: #" LIMIT (\d+)"#, options: .regularExpression)

        let offsetRange = sql.range(of: #" OFFSET (\d+)"#, options: .regularExpression)

        var limit: Int?

        var offset: Int?

        if let offsetRange {
            let offsetStatement = sql[offsetRange]
            let valueRange = offsetStatement.range(of: #"\d+"#, options: .regularExpression)!
            let stringValue = offsetStatement[valueRange]
            offset = Int(stringValue)!

            sql.removeSubrange(offsetRange)
        }

        if let limitRange {
            let limitStatement = sql[limitRange]
            let valueRange = limitStatement.range(of: #"\d+"#, options: .regularExpression)!
            let stringValue = limitStatement[valueRange]
            limit = Int(stringValue)!

            sql.removeSubrange(limitRange)
        }

        if let limit {
            let offset = offset ?? 0
            let startIndex = offset + 1
            let endIndex = offset + limit
            sql.append(" ROWS \(startIndex) TO \(endIndex)")
        }

        return self.database.query(sql, binds, onRow: onRow)
    }

}
