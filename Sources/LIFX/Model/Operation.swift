//
//  Operation.swift
//  LIFX
//
//  Created by Emilio Peláez on 2/3/18.
//

import Foundation

public struct Operation: Encodable {
	let states: [State]
	let defaults: State?
	
	public init(operations: [(selector: Selector, state: State)], defaults: State? = nil) throws {
		guard !operations.isEmpty else { throw LIFXError.invalidParameter("Operations array can't be empty") }
		self.states = operations.map {
			var state = $0.state
			state.selector = $0.selector
			return state
		}
		self.defaults = defaults
	}
	
	public init(states: [State], defaults: State? = nil) throws {
		guard !states.isEmpty else { throw LIFXError.invalidParameter("States array can't be empty") }
		self.states = states
		self.defaults = defaults
	}
}
