import Firebird
import Logging
import NIOCore

public protocol FirebirdNIODatabase {
    
    var eventLoop: EventLoop { get }
    
    var logger: Logger { get }
    
    func withConnection<T>(_ closure: @escaping (FirebirdNIOConnection) -> EventLoopFuture<T>) -> EventLoopFuture<T>
    
    func withTransaction<T>(_ closure: @escaping (FirebirdNIOTransaction) -> EventLoopFuture<T>) -> EventLoopFuture<T>
    
    func query(_ string: String, _ binds: [Encodable], onRow: @escaping (FirebirdRow) -> ()) -> EventLoopFuture<Void>
    
}

public extension FirebirdNIODatabase {
    
    func query(_ string: String, _ binds: [Encodable]) -> EventLoopFuture<[FirebirdRow]> {
        var rows: [FirebirdRow] = []
        
        return self.query(string, binds) { rows.append($0) }
            .map { rows }
    }
    
}
