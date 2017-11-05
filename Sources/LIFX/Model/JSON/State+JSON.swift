//
//  State+JSON.swift
//  LIFX
//
//  Created by Emilio Peláez on 8/27/17.
//
//

import Foundation
import JSON

extension State: JSONRepresentable {
	public func makeJSON() throws -> JSON {
		var json = JSON()
		
		var values: [(String, Any?)] = [
			("color", try color?.makeJSON()),
			("brightness", brightness),
			("duration", duration)
		]
		if let powered = powered {
			values.append(("power", powered ? "on" : "off"))
		}
		
		try values.forEach {
			guard let value = $0.1 else {
				return
			}
			try json.set($0.0, value)
		}
		
		return json
	}
}
