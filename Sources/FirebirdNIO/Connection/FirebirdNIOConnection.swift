import Firebird
import Logging
import NIOCore

public protocol FirebirdNIOConnection: FirebirdNIODatabase {
    
    var eventLoop: EventLoop { get }
    
    var logger: Logger { get }
    
    var isClosed: Bool { get }
    
    func attach(_ url: String, parameters: [CChar]) -> EventLoopFuture<Void>
    
    func detach() -> EventLoopFuture<Void>
    
}

public extension FirebirdNIOConnection {
    
    func attach(to host: String, port: UInt16, database: String, username: String, password: String, parameters: [FirebirdConnectionParameter] = [.version1]) -> EventLoopFuture<Void> {
        let allParameters = parameters + [.username(username), .password(password)]
        return self.attach(to: host, port: port, database: database, parameters: allParameters)
    }
    
    func attach(to host: String, port: UInt16, database: String, parameters: [FirebirdConnectionParameter] = []) -> EventLoopFuture<Void> {
        let parametersBuffer = parameters.flatMap { $0.rawValue }
        return self.attach(to: host, port: port, database: database, parameters: parametersBuffer)
    }
    
    func attach(to host: String, port: UInt16, database: String, parameters: [CChar] = []) -> EventLoopFuture<Void> {
        let url = "\(host)/\(port):\(database)"
        return self.attach(url, parameters: parameters)
    }
    
}
