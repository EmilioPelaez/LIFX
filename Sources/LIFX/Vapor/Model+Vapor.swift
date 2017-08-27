//
//  Model+Vapor.swift
//  LIFX
//
//  Created by Emilio Peláez on 08/27/17.
//
//

import Foundation
import Vapor

extension LIFXBulb: JSONInitializable {
	init(json: JSON) throws {
		guard let id = json["id"]?.string,
			let name = json["label"]?.string,
			let power = json["power"]?.string, (power == "on" || power == "off"),
			let connected = json["connected"]?.bool
			else {
				print("Can't create bulb", json)
				throw LIFXError.invalidJson(json)
		}
		
		self.id = id
		self.name = name
		self.powered = power == "on"
		self.connected = connected
		self.color = try LIFXColor(json: json)
	}
}

extension LIFXBulb: JSONRepresentable {
	func makeJSON() throws -> JSON {
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

extension LIFXBulb: JSONConvertible {}

extension LIFXColor: JSONInitializable {
	init(json: JSON) throws {
		self.hue = json["hue"]?.int ?? json["color", "hue"]?.int
		self.saturation = json["saturation"]?.double ?? json["color", "saturation"]?.double
		self.brightness = json["brightness"]?.double ?? json["color", "brightness"]?.double
		self.kelvin = json["kelvin"]?.int ?? json["color", "kelvin"]?.int
	}
}

extension LIFXColor {
	init(string: String) throws {
		guard !string.isEmpty else {
			throw LIFXError.invalidParameter("Empty String")
		}
		//	String is in format "property:value property:value, this converts it to format
		//	{"property":value,"property":value}, then it's converted to data and initialized
		//	as a json to load the values in init(json:)
		let body = string.components(separatedBy: " ")
			.map { $0.components(separatedBy: ":") }
			.map { "\"\($0[0])\":\($0[1])" }
			.joined(separator: ",")
		let jsonString = "{" + body + "}"
		guard let data = jsonString.data(using: .utf8) else {
			throw LIFXError.invalidParameter("Empty String")
		}
		let json: JSON = try JSON(bytes: data.makeBytes())
		try self.init(json: json)
	}
}

extension LIFXColor: JSONRepresentable {
	func makeJSON() throws -> JSON {
		var json = JSON()
		
		let values: [(String, Any?)] = [
			("hue", hue),
			("saturation", saturation),
			("brightness", brightness),
			("kelvin", kelvin)
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

extension LIFXColor: JSONConvertible { }

extension LIFXResult: JSONInitializable {
	init(json: JSON) throws {
		self.id = json["id"]?.string ?? "????????????"
		self.label = json["label"]?.string ?? "Unknown"
		self.status = json["status"]?.string ?? "Unknown"
	}
}

extension LIFXOperationResult: JSONInitializable {
	init(json: JSON) throws {
		let results = json["results"]?.array ?? []
		let operation = json["operation"] ?? JSON()
		
		self.selectorString = operation["selector"]?.string ?? "Unknown Selector"
		self.state = try LIFXState(json: operation) 
		self.results = try results.flatMap(LIFXResult.init)
	}
}

extension LIFXState: JSONInitializable {
	init(json: JSON) throws {
		if let powerString = json["power"]?.string {
			self.powered = powerString == "on"
		} else {
			self.powered = nil
		}
		if let color = try? LIFXColor(string: json["color"]?.string ?? "") {
			self.color = color
		} else {
			self.color = nil
		}
		self.brightness = json["brightness"]?.double
		self.duration = json["duration"]?.double
	}
}
