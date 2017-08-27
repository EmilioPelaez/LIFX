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
	
	internal var powerString: String? {
		guard let powered = powered else { return nil }
		return powered ? "on" : "off"
	}
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
		
		if let power = powerString {
			values["power"] = power
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
