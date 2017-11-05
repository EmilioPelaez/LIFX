//
//  Color.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

public struct Color: Decodable {
	public var hue: Double?					{ didSet { validate() } }
	public var saturation: Double?	{ didSet { validate() } }
	public var brightness: Double?	{ didSet { validate() } }
	public var kelvin: Int?					{ didSet { validate() } }
	
	public init(hue: Double? = nil, saturation: Double? = nil, brightness: Double? = nil, kelvin: Int? = nil) {
		self.hue = hue
		self.saturation = saturation
		self.brightness = brightness
		self.kelvin = kelvin
		
		validate()
	}
	
	private mutating func validate() {
		if var hue = hue {
			while hue < 0 { hue += 360 }
			let target = Double(Int(hue) % 360)
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

extension Color: CustomStringConvertible {
	public var description: String { return "Color " + string }
}
