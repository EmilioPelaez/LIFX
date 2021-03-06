//
//  Result.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

public struct Result: Decodable {
	public let id: String
	public let label: String
	public let status: String
}

extension Result: CustomStringConvertible {
	public var description: String { return "Result \(label): status \(status)" }
}

public struct OperationResult: Decodable {
	public let selector: String?
	public let operation: State
	public let results: [Result]
}

extension OperationResult: CustomStringConvertible {
	public var description: String { return "LIFXOperationResult" }
}
