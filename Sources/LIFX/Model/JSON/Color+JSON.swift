//
//  Color+JSON.swift
//  LIFX
//
//  Created by Emilio Peláez on 8/27/17.
//
//

import Foundation
import JSON

extension Color {
	static func from(string: String) throws -> Color {
		guard !string.isEmpty else {
			throw LIFXError.invalidParameter("Empty string")
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
			throw LIFXError.invalidParameter("Empty string")
		}
		let decoder = JSONDecoder()
		return try decoder.decode(Color.self, from: data)
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
