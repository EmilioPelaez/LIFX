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
