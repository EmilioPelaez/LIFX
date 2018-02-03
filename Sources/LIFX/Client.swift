//
//  Client.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/18/16.
//
//

import Foundation
import HTTP
import JSON
import JSONClient

extension String {
	static let lifxEndpoint = "https://api.lifx.com/v1/lights"
}

open class Client: JSONClient {
	//	You can learn more about generating the token here https://api.developer.lifx.com/docs/authentication
	public let token: String
	
	public init(token: String, client: Responder) {
		self.token = token
		super.init(baseUrl: .lifxEndpoint, client: client)
	}
	
	open override func headers() -> [HeaderKey : String] {
		var headers = super.headers()
		headers[.authorization] = "Bearer \(token)"
		return headers
	}
	
	@discardableResult
	open func list(selector: Selector = .all) throws -> [Bulb] {
		return try performAndHandleRequest(pathComponents: [selector.string], unwrapResults: false)
	}
	
	@discardableResult
	open func setState(selector: Selector = .all, state: State) throws -> [Result] {
		guard let body = state.makeDictionary() as? [String: CustomStringConvertible] else {
			fatalError("Invalid parameters \(state.makeDictionary())")
		}
		return try performAndHandleRequest(method: .put, pathComponents: [selector.string, "state"], body: body, unwrapResults: true)
	}
	
	@discardableResult
	open func setStates(operations: [(selector: Selector, state: State)], defaults: State? = nil) throws -> [OperationResult] {
		guard operations.count > 0 else {
			throw LIFXError.invalidParameter("Empty operations array")
		}
		
		let operationsBody: [[String: Any]] = operations.map { selector, state in
			var dictionary = state.makeDictionary()
			dictionary[APIKey.selector] = selector.string
			return dictionary
		}
		var body: [String: Any] = [APIKey.states: operationsBody]
		if let defaults = defaults {
			body[APIKey.defaults] = defaults.makeDictionary()
		}
		
		return try performAndHandleRequest(method: .put, pathComponents: ["states"], body: body, unwrapResults: true)
	}
	
	@discardableResult
	open func cycle(selector: Selector = .all, states: [State], defaults: State? = nil) throws -> [Result] {
		guard states.count > 0 else {
			throw LIFXError.invalidParameter("Empty states array")
		}
		
		let statesValues = states.map { $0.makeDictionary() }
		var body: [String: Any] = [APIKey.states: statesValues]
		if let defaults = defaults {
			body[APIKey.defaults] = defaults.makeDictionary()
		}
		
		return try performAndHandleRequest(method: .post, pathComponents: [selector.string, "cycle"], body: body, unwrapResults: true)
	}
	
	@discardableResult
	open func pulse(selector: Selector = .all, color: Color, period: Double = 0.75, cycles: Double = 3, powerOn: Bool = false) throws -> [Result] {
		return try pulse(selector: selector, colorString: color.string, period: period, cycles: cycles, powerOn: powerOn)
	}
	
	@discardableResult
	open func pulse(selector: Selector = .all, colorString: String, period: Double = 0.75, cycles: Double = 3, powerOn: Bool = false) throws -> [Result] {
		let body: [String: Any] = [
			APIKey.color: colorString,
			APIKey.period: period,
			APIKey.cycles: cycles,
			APIKey.powerOn: powerOn
		]
		
		return try performAndHandleRequest(method: .post, pathComponents: [selector.string, "effects", "pulse"], body: body, unwrapResults: true)
	}
	
	@discardableResult
	open func breathe(selector: Selector = .all, color: Color, period: Double = 0.75, cycles: Double = 3, persist: Bool = false, powerOn: Bool = true, peak: Double = 0.5) throws -> [Result] {
		return try breathe(selector: selector, colorString: color.string, period: period, cycles: cycles, persist: persist, powerOn: powerOn, peak: peak)
	}
	
	@discardableResult
	open func breathe(selector: Selector = .all, colorString: String, period: Double = 0.75, cycles: Double = 3, persist: Bool = false, powerOn: Bool = true, peak: Double = 0.5) throws -> [Result] {
		let body: [String: Any] = [
			APIKey.color: colorString,
			APIKey.period: period,
			APIKey.cycles: cycles,
			APIKey.persist: persist,
			APIKey.powerOn: powerOn,
			APIKey.peak: peak
		]
		
		return try performAndHandleRequest(method: .post, pathComponents: [selector.string, "effects", "pulse"], body: body, unwrapResults: true)
	}
}

extension Client {
	@discardableResult
	fileprivate func performAndHandleRequest<T: Decodable>(method: HTTP.Method = .get, pathComponents components: [String], query: [String: CustomStringConvertible] = [:], body: [String: Any]? = nil, unwrapResults: Bool) throws -> [T] {
		
		let requestBody: ContentBody = try {
			if let body = body {
				var json = JSON()
				
				try body.forEach { key, value in
					try json.set(key, value)
				}
				
				return ContentBody(json: json)
			} else {
				return .empty
			}
		}()
		
		if unwrapResults {
			let wrapper: ResultsWraper<T> = try performDecodableRequest(method: method, path: components, query: query, body: requestBody)
			return wrapper.results
		} else {
			return try performDecodableRequest(method: method, path: components, query: query, body: requestBody)
		}
	}
	
	
}

private struct ResultsWraper<T: Decodable>: Decodable {
	let results: [T]
}
