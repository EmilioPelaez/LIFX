//
//  LIFXResult.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

public struct LIFXResult {
	public let id: String
	public let label: String
	public let status: String
}

extension LIFXResult: CustomStringConvertible {
	public var description: String { return "LIFXResult \(label): status \(status)" }
}

public struct LIFXOperationResult {
	public let selectorString: String
	public let state: LIFXState
	public let results: [LIFXResult]
}

extension LIFXOperationResult: CustomStringConvertible {
	public var description: String { return "LIFXOperationResult" }
}
