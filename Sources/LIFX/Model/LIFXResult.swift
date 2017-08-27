//
//  LIFXResult.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

struct LIFXResult {
	let id: String
	let label: String
	let status: String
}

extension LIFXResult: CustomStringConvertible {
	var description: String { return "LIFXResult \(label): status \(status)" }
}

struct LIFXOperationResult {
	let selectorString: String
	let state: LIFXState
	let results: [LIFXResult]
}

extension LIFXOperationResult: CustomStringConvertible {
	var description: String { return "LIFXOperationResult" }
}
