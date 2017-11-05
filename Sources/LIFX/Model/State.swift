//
//  State.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

public struct State {
	
	public static let empty = State()
	public static let on = State(powered: true)
	public static let off = State(powered: false)
	
	public var powered: Bool?
	public var color: Color?
	public var brightness: Double? {
		didSet {
			if let brightness = brightness {
				self.brightness = max(0, min(1, brightness))
			}
		}
	}
	public var duration: Double? {
		didSet {
			if let duration = duration {
				self.duration = max(0, min(3155760000, duration))
			}
		}
	}
	
	public init(powered: Bool? = nil, color: Color? = nil, brightness: Double? = nil, duration: Double? = nil) {
		self.powered = powered
		self.color = color
		if let brightness = brightness {
			self.brightness = max(0, min(1, brightness))
		}
		if let duration = duration {
			self.duration = max(0, min(3155760000, duration))
		}
	}
	
	func makeDictionary() -> [String: Any] {
		var values = [String: Any]()
		
		if let powered = powered {
			values["power"] = powered ? "on" : "off"
		}
		if let color = color?.string {
			values["color"] = color
		}
		if let brightness = brightness {
			values["brightness"] = brightness
		}
		if let duration = duration {
			values["duration"] = duration
		}
		
		return values
	}
}

extension State {
	enum CodingKeys: String, CodingKey {
		case power
		case color
		case brightness
		case duration
	}
}

extension State: Decodable {
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		if let powerString = try? values.decode(String.self, forKey: .power) {
			self.powered = powerString == "on"
		}
		self.color = try? values.decode(Color.self, forKey: .color)
		self.brightness = try? values.decode(Double.self, forKey: .brightness)
		self.duration = try? values.decode(Double.self, forKey: .duration)
	}
}

extension State {
	public static func fade(duration: TimeInterval = 5) -> State {
		return State(duration: duration)
	}
	
	public mutating func addValues(from state: State) {
		powered = state.powered ?? powered
		color = state.color ?? color
		brightness = state.brightness ?? brightness
		duration = state.duration ?? duration
	}
	
	public static func +(lhs: State, rhs: State) -> State {
		var result = lhs
		result.addValues(from: rhs)
		return result
	}
	
	public static func +(lhs: State, rhs: Color) -> State {
		var result = lhs
		result.addValues(from: State(color: rhs))
		return result
	}
}

extension State: CustomStringConvertible {
	public var description: String { return "State" }
}
