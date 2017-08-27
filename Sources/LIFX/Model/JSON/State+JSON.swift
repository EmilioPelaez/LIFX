//
//  State+JSON.swift
//  LIFX
//
//  Created by Emilio Peláez on 8/27/17.
//
//

import Foundation
import JSON

extension State: JSONInitializable {
	public init(json: JSON) throws {
		if let powerString = json["power"]?.string {
			self.powered = powerString == "on"
		} else {
			self.powered = nil
		}
		if let color = try? Color(string: json["color"]?.string ?? "") {
			self.color = color
		} else {
			self.color = nil
		}
		self.brightness = json["brightness"]?.double
		self.duration = json["duration"]?.double
	}
}

extension State: JSONRepresentable {
	public func makeJSON() throws -> JSON {
		var json = JSON()
		
		let values: [(String, Any?)] = [
			("power", powerString),
			("color", try color?.makeJSON()),
			("brightness", brightness),
			("duration", duration)
		]
		
		try values.forEach {
			guard let value = $0.1 else {
				return
			}
			try json.set($0.0, value)
		}
		
		return json
	}
}

extension State: JSONConvertible { }
