//
//  Date+FirebirdCodable.swift
//  
//
//  Created by Ugo Cottin on 19/03/2021.
//

import Foundation

extension Date: FirebirdCodable {
	public static var firebirdDataType: FirebirdDataType { .timestamp }
	
	public var firebirdData: FirebirdData {
		var tm_time = self.tm_time

		let data = withUnsafeBytes(of: &tm_time) { buffer in
			return Data(buffer)
		}
		
		return FirebirdData(type: Self.firebirdDataType, value: data)
	}
	
	
}

public extension Date {
	
	/// Initialize a date from a `tm_time` structure
	/// - Parameter tm_time: a `tm_time` structure
	init(tm_time: tm) {
		var copy = tm_time
		let timestamp = mktime(&copy)
		self.init(timeIntervalSince1970: TimeInterval(timestamp))
	}
	
	/// Get the `tm_time` structure associated to this date
	var tm_time: tm {
		var timestamp: time_t = Int(self.timeIntervalSince1970)
		let c_time: tm = withUnsafePointer(to: &timestamp) { time_ptr in
			localtime(time_ptr).pointee
		}

		return c_time
	}
}
