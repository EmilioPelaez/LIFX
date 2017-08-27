//
//  LIFXColor.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

struct LIFXColor {
	var hue: Int?						{ didSet { validate() } }
	var saturation: Double?	{ didSet { validate() } }
	var brightness: Double?	{ didSet { validate() } }
	var kelvin: Int?				{ didSet { validate() } }
	
	init(hue: Int? = nil, saturation: Double? = nil, brightness: Double? = nil, kelvin: Int? = nil) {
		self.hue = hue
		self.saturation = saturation
		self.brightness = brightness
		self.kelvin = kelvin
		
		validate()
	}
	
	mutating func validate() {
		if var hue = hue {
			while hue < 0 { hue += 360 }
			let target = hue % 360
			if hue != target { self.hue = target }
		}
		if let saturation = saturation {
			let target = max(0, min(1, saturation))
			if saturation != target { self.saturation = target }
		}
		if let brightness = brightness {
			let target = max(0, min(1, brightness))
			if brightness != target { self.brightness = target }
		}
		if let kelvin = kelvin {
			let target = max(2500, min(9000, kelvin))
			if kelvin != target { self.kelvin = target }
		}
	}
	
	var string: String {
		var components = [String]()
		if let hue = hue { components += ["hue:\(hue)"] }
		if let saturation = saturation { components += [String(format:"saturation:%.1f", saturation)] }
		if let brightness = brightness { components += [String(format:"brightness:%.1f", brightness)] }
		if let kelvin = kelvin { components += ["kelvin:\(kelvin)"] }
		
		return components.joined(separator: " ")
	}
}

extension LIFXColor: CustomStringConvertible {
	var description: String { return "LIFXColor " + string }
}
