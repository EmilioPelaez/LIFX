//
//  Result.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

public struct Result {
	public let id: String
	public let label: String
	public let status: String
}

extension Result: CustomStringConvertible {
	public var description: String { return "Result \(label): status \(status)" }
}

public struct OperationResult {
	public let selectorString: String
	public let state: State
	public let results: [Result]
}

extension OperationResult: CustomStringConvertible {
	public var description: String { return "LIFXOperationResult" }
}
