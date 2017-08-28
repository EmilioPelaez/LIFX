//
//  SelectorRepresentable.swift
//  LIFX
//
//  Created by Emilio Peláez on 1/11/17.
//
//

import Foundation

public protocol SelectorRepresentable {
	var selector: Selector { get }
}

extension Selector: SelectorRepresentable {
	public var selector: Selector { return self }
}
