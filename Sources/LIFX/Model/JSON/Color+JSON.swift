//
//  Color+JSON.swift
//  LIFX
//
//  Created by Emilio Peláez on 8/27/17.
//
//

import Foundation
import JSON

extension Color: JSONInitializable {
	public init(json: JSON) throws {
		self.hue = json["hue"]?.int ?? json["color", "hue"]?.int
		self.saturation = json["saturation"]?.double ?? json["color", "saturation"]?.double
		self.brightness = json["brightness"]?.double ?? json["color", "brightness"]?.double
		self.kelvin = json["kelvin"]?.int ?? json["color", "kelvin"]?.int
	}
}

extension Color {
	init(string: String) throws {
		guard !string.isEmpty else {
			throw LIFX.Error.invalidParameter("Empty String")
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
			throw LIFX.Error.invalidParameter("Empty String")
		}
		let json: JSON = try JSON(bytes: data.makeBytes())
		try self.init(json: json)
	}
}

extension Color: JSONRepresentable {
	public func makeJSON() throws -> JSON {
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

extension Color: JSONConvertible { }
