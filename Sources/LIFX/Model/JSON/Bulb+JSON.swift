//
//  Bulb+JSON.swift
//  LIFX
//
//  Created by Emilio Peláez on 8/27/17.
//
//

import Foundation
import JSON

extension Bulb: JSONInitializable {
	public init(json: JSON) throws {
		guard let id = json["id"]?.string,
			let name = json["label"]?.string,
			let power = json["power"]?.string, (power == "on" || power == "off"),
			let connected = json["connected"]?.bool
			else {
				print("Can't create bulb", json)
				throw LIFX.Error.invalidJson(json)
		}
		
		self.id = id
		self.name = name
		self.powered = power == "on"
		self.connected = connected
		self.color = try Color(json: json)
	}
}

extension Bulb: JSONRepresentable {
	public func makeJSON() throws -> JSON {
		var json = JSON()
		
		try json.set("id", id)
		try json.set("label", name)
		try json.set("power", powered ? "on" : "off")
		try json.set("connected", connected)
		if let color = color {
			try json.set("color", color)
		}
		
		return json
	}
}

extension Bulb: JSONConvertible {}
