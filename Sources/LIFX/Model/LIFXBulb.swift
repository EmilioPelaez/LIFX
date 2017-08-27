//
//  LIFXBulb.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

struct LIFXBulb {
	
	let id: String
	let name: String
	let powered: Bool
	let connected: Bool
	let color: LIFXColor?
	
}

extension LIFXBulb: CustomStringConvertible {
	var description: String { return "LIFXBulb " + name }
}

extension LIFXBulb: Equatable {
	static func ==(lhs: LIFXBulb, rhs: LIFXBulb) -> Bool {
		return lhs.id == rhs.id
	}
}

extension LIFXBulb: Hashable {
	var hashValue: Int { return id.hashValue }
}
