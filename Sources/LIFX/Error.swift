//
//  Error.swift
//  LIFX
//
//  Created by Emilio Peláez on 8/27/17.
//
//

import Foundation
import JSON

public enum Error: Swift.Error {
	case invalidJson(JSON)
	case invalidParameter(String)
	case apiError(String)
}
