import Firebird
import SQLKit

extension FirebirdRow: SQLRow {

    public var allColumns: [String] {
        self.columns
    }

    public func decodeNil(column: String) throws -> Bool {
        guard self.contains(column: column) else {
            throw Error.invalidColumn(column: column)
        }

        let data = try self.column(column)

        return data.value == nil
    }

}
