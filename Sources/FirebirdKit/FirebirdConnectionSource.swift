//
//  FirebirdConnectionSource.swift
//  
//
//  Created by Ugo Cottin on 15/03/2021.
//

extension FirebirdNIOConnection: ConnectionPoolItem {
	public var isClosed: Bool {
		!self.connection.isOpened
	}
	
	public func close() -> EventLoopFuture<Void> {
		let promise = self.eventLoop.makePromise(of: Void.self)
		do {
			try self.connection.close()
			promise.succeed(())
		} catch {
			promise.fail(error)
		}
		
		return promise.futureResult
	}
}

public struct FirebirdConnectionSource: ConnectionPoolSource {
	
	public typealias Connection = FirebirdNIOConnection
	
	public let configuration: FirebirdConnectionConfiguration
	
	public init(configuration: FirebirdConnectionConfiguration) {
		self.configuration = configuration
	}
		
	public func makeConnection(logger: Logger, on eventLoop: EventLoop) -> EventLoopFuture<FirebirdNIOConnection> {
		return FirebirdNIOConnection.connect(self.configuration, logger: logger, on: eventLoop)
	}
}
