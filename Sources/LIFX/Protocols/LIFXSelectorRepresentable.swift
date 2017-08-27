//
//  LIFXSelectorRepresentable.swift
//  LIFX
//
//  Created by Emilio Peláez on 1/11/17.
//
//

import Foundation

protocol LIFXSelectorRepresentable {
	var selector: LIFXSelector { get }
}

extension LIFXSelector: LIFXSelectorRepresentable {
	var selector: LIFXSelector { return self }
}
