//
//  LIFXState.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation
import Vapor

struct LIFXState {
	
	static let empty = LIFXState()
	static let on = LIFXState(powered: true)
	static let off = LIFXState(powered: false)
	
	internal var powerString: String? {
		guard let powered = powered else { return nil }
		return powered ? "on" : "off"
	}
	var powered: Bool?
	var color: LIFXColor?
	var brightness: Double? {
		didSet {
			if let brightness = brightness {
				self.brightness = max(0, min(1, brightness))
			}
		}
	}
	var duration: Double? {
		didSet {
			if let duration = duration {
				self.duration = max(0, min(3155760000, duration))
			}
		}
	}
	
	init(powered: Bool? = nil, color: LIFXColor? = nil, brightness: Double? = nil, duration: Double? = nil) {
		self.powered = powered
		self.color = color
		if let brightness = brightness {
			self.brightness = max(0, min(1, brightness))
		}
		if let duration = duration {
			self.duration = max(0, min(3155760000, duration))
		}
	}
}

extension LIFXState {
	
	static func fade(duration: TimeInterval = 5) -> LIFXState {
		return LIFXState(duration: duration)
	}
	
	mutating func addValues(from state: LIFXState) {
		if powered == nil { powered = state.powered }
		if color == nil { color = state.color }
		if brightness == nil { brightness = state.brightness }
		if duration == nil { duration = state.duration }
	}
	
	static func +(lhs: LIFXState, rhs: LIFXState) -> LIFXState {
		var result = lhs
		result.addValues(from: rhs)
		return result
	}
	
	static func +(lhs: LIFXState, rhs: LIFXColor) -> LIFXState {
		var result = lhs
		result.addValues(from: LIFXState(color: rhs))
		return result
	}
}

extension LIFXState: CustomStringConvertible {
	var description: String { return "LIFXState" }
}
extension LIFXState: JSONRepresentable {
	func makeJSON() throws -> JSON {
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


extension LIFXState {
	func encoded() -> LIFXStateEncoder {
		return LIFXStateEncoder(state: self)
	}
}

class LIFXStateEncoder {
	var state: LIFXState
	
	init() {
		state = LIFXState()
	}
	
	init(state: LIFXState) {
		self.state = state
	}
	
	func getJSONValues() -> [String : Any] {
		var values = [String: Any]()
		
		if let power = state.powerString {
			values["power"] = power
		}
		if let color = state.color?.string {
			values["color"] = color
		}
		if let brightness = state.brightness {
			values["brightness"] = brightness
		}
		if let duration = state.duration {
			values["duration"] = duration
		}
		
		return values
	}
	
}
