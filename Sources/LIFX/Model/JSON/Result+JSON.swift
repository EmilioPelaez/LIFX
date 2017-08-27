//
//  Result+JSON.swift
//  LIFX
//
//  Created by Emilio Peláez on 8/27/17.
//
//

import Foundation
import JSON

extension Result: JSONInitializable {
	public init(json: JSON) throws {
		self.id = json["id"]?.string ?? "????????????"
		self.label = json["label"]?.string ?? "Unknown"
		self.status = json["status"]?.string ?? "Unknown"
	}
}

extension OperationResult: JSONInitializable {
	public init(json: JSON) throws {
		let results = json["results"]?.array ?? []
		let operation = json["operation"] ?? JSON()
		
		self.selectorString = operation["selector"]?.string ?? "Unknown Selector"
		self.state = try State(json: operation)
		self.results = try results.flatMap(Result.init)
	}
}
