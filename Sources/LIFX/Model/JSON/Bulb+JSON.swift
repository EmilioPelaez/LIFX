//
//  Bulb+JSON.swift
//  LIFX
//
//  Created by Emilio Peláez on 8/27/17.
//
//

import Foundation
import JSON

extension Bulb: JSONRepresentable {
	public func makeJSON() throws -> JSON {
		var json = JSON()
		
		try json.set("id", id)
		try json.set("label", name)
		try json.set("power", powered ? "on" : "off")
		try json.set("connected", connected)
		if let color = color {
			try json.set("color", color.makeJSON())
		}
		
		return json
	}
}
