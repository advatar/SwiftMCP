//
//  NoOpLogHandler.swift
//  SwiftMCP
//
//  Created by Oliver Drobnik on 19.03.25.
//

import Foundation
import Logging

// swiftlint:disable unused_setter_value
// `LogHandler` protocol from swift-log dictates the signatures; we just no-op.
struct NoOpLogHandler: LogHandler {
	var logLevel: Logger.Level = .critical
	var metadata: Logger.Metadata = [:]

	subscript(metadataKey key: String) -> Logger.Metadata.Value? {
		get { return nil }
		set { }
	}

	// The swift-log compatibility protocol requires all seven parameters.
	// swiftlint:disable:next function_parameter_count
	func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?,
	         source: String, file: String, function: String, line: UInt) {
		// Common LogHandler entry point supported by swift-log 1.10.1 and later.
		// Discard all log messages.
	}
}
// swiftlint:enable unused_setter_value
