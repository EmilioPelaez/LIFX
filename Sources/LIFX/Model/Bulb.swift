//
//  Bulb.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

public struct Bulb {
	public let id: String
	public let name: String
	public let powered: Bool
	public let connected: Bool
	public let color: Color?
}

extension Bulb {
	enum CodingKeys: String, CodingKey {
		case id
		case name = "label"
		case power
		case connected
		case color
		case brightness
	}
}

extension Bulb: Decodable {
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try values.decode(String.self, forKey: .id)
		self.name = try values.decode(String.self, forKey: .name)
		let power = try values.decode(String.self, forKey: .power)
		self.powered = power == "on"
		self.connected = try values.decode(Bool.self, forKey: .connected)
		self.color = try? values.decode(Color.self, forKey: .color)
		let brightness = try? values.decode(Double.self, forKey: .brightness)
		self.color?.brightness = brightness
	}
}

extension Bulb: CustomStringConvertible {
	public var description: String { return "LIFXBulb " + name }
}

extension Bulb: Equatable {
	public static func ==(lhs: Bulb, rhs: Bulb) -> Bool {
		return lhs.id == rhs.id
	}
}

extension Bulb: Hashable {
	public var hashValue: Int { return id.hashValue }
}
