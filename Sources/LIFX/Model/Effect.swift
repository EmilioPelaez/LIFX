//
//  Effect.swift
//  LIFX
//
//  Created by Emilio Peláez on 2/3/18.
//

import Foundation

public struct Effect: Encodable {
	let color: String
	let fromColor: String?
	let period: Double?
	let cycles: Int?
	let persist: Bool?
	let powerOn: Bool?
	let peak: Double?
	
	init(color: Color, fromColor: Color? = nil, period: Double? = nil, cycles: Int? = nil, persist: Bool? = nil, powerOn: Bool? = nil, peak: Double? = nil) {
		self.color = color.buildString()
		self.fromColor = fromColor?.buildString()
		self.period = period
		self.cycles = cycles
		self.persist = persist
		self.powerOn = powerOn
		self.peak = peak
	}
}

extension Effect {
	enum CodingKeys: String, CodingKey {
		case color, period, cycles, persist, peak
		case fromColor = "from_color"
		case powerOn = "power_on"
	}
}
