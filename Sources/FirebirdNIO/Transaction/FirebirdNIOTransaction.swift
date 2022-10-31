import NIOCore
import Logging
import Firebird

public protocol FirebirdNIOTransaction {
    
    var eventLoop: EventLoop { get }
    
    var logger: Logger { get }
    
    var isClosed: Bool { get }
    
    func commit() -> EventLoopFuture<Void>
    
    func rollback() -> EventLoopFuture<Void>
    
}

public class FBNIOTransaction: FirebirdNIOTransaction {
    
    public var eventLoop: EventLoop
    
    private let syncTransaction: FBTransaction
    
    public var logger: Logger {
        self.syncTransaction.logger
    }
    
    public var isClosed: Bool {
        self.syncTransaction.isClosed
    }
    
    public init(_ transaction: FBTransaction, on eventLoop: EventLoop) {
        self.eventLoop = eventLoop
        self.syncTransaction = transaction
    }
    
    public func commit() -> EventLoopFuture<Void> {
        self.eventLoop.submit {
            try self.syncTransaction.commit()
        }
    }
    
    public func rollback() -> EventLoopFuture<Void> {
        self.eventLoop.submit {
            try self.syncTransaction.rollback()
        }
    }
    
}
