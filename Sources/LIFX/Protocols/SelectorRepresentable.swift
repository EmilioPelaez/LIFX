//
//  SelectorRepresentable.swift
//  LIFX
//
//  Created by Emilio Peláez on 1/11/17.
//
//

import Foundation

protocol SelectorRepresentable {
	var selector: Selector { get }
}

extension Selector: SelectorRepresentable {
	var selector: Selector { return self }
}
