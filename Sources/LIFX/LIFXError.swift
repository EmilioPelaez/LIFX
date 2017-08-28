//
//  LIFXError.swift
//  LIFX
//
//  Created by Emilio Peláez on 8/27/17.
//
//

import Foundation
import JSON

public enum LIFXError: Error {
	case invalidJson(JSON)
	case invalidParameter(String)
	case apiError(String)
}
