//
//  LIFXBulb.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

public struct LIFXBulb {
	let id: String
	let name: String
	let powered: Bool
	let connected: Bool
	let color: LIFXColor?
}

extension LIFXBulb: CustomStringConvertible {
	public var description: String { return "LIFXBulb " + name }
}

extension LIFXBulb: Equatable {
	public static func ==(lhs: LIFXBulb, rhs: LIFXBulb) -> Bool {
		return lhs.id == rhs.id
	}
}

extension LIFXBulb: Hashable {
	public var hashValue: Int { return id.hashValue }
}
