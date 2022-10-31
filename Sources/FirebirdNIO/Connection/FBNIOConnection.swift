import Firebird
import Logging
import NIOCore

public class FBNIOConnection: FirebirdNIOConnection {
    
    public let eventLoop: EventLoop
    
    public var logger: Logger {
        self.syncConnection.logger
    }
    
    internal let syncConnection: FBConnection
    
    public var isClosed: Bool {
        self.syncConnection.isClosed
    }
    
    public init(logger: Logger, on eventLoop: EventLoop) {
        self.eventLoop = eventLoop
        self.syncConnection = FBConnection(logger: logger)
    }
    
    public func attach(_ url: String, parameters: [CChar]) -> EventLoopFuture<Void> {
        self.eventLoop.submit {
            try self.syncConnection.attach(url, parameters: parameters)
        }
    }
    
    public func detach() -> EventLoopFuture<Void> {
        self.eventLoop.submit {
            try self.syncConnection.detach()
        }
    }
    
    public func withConnection<T>(_ closure: @escaping (FirebirdNIOConnection) -> EventLoopFuture<T>) -> EventLoopFuture<T> {
        closure(self)
    }
    
    public func withTransaction<T>(_ closure: @escaping (FirebirdNIOTransaction) -> EventLoopFuture<T>) -> EventLoopFuture<T> {
        let promise = self.eventLoop.makePromise(of: T.self)
        
        do {
            let result = try self.syncConnection.withTransaction { transaction in
                let transaction = transaction as! FBTransaction
                let asyncTransaction = FBNIOTransaction(transaction, on: self.eventLoop)
                
                return closure(asyncTransaction)
            }
            
            promise.completeWith(result)
        } catch {
            promise.fail(error)
        }
        
        return promise.futureResult
    }
    
    public func query(_ string: String, _ binds: [Encodable], onRow: @escaping (FirebirdRow) -> ()) -> EventLoopFuture<Void> {
        self.eventLoop.submit {
            try self.syncConnection.query(string, binds, onRow: onRow)
        }
    }
    
}
