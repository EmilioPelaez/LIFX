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
		return try performAndHandleRequest(path: [selector.string], unwrapResults: false)
	}
	
	@discardableResult
	open func setState(selector: Selector = .all, state: State) throws -> [Result] {
		return try performAndHandleRequest(method: .put, path: [selector.string, "state"], body: state, unwrapResults: true)
	}
	
	@discardableResult
	open func setStates(operations: [(selector: Selector, state: State)], defaults: State? = nil) throws -> [OperationResult] {
		let operation = try Operation(operations: operations, defaults: defaults)
		return try setStates(operation)
	}
	
	@discardableResult
	open func setStates(_ operation: Operation) throws -> [OperationResult] {
		return try performAndHandleRequest(method: .put, path: ["states"], body: operation, unwrapResults: true)
	}
	
	@discardableResult
	open func cycle(selector: Selector = .all, states: [State], defaults: State? = nil) throws -> [Result] {
		let operation = try Operation(states: states, defaults: defaults)
		return try self.cycle(selector: selector, operation: operation)
	}
	
	@discardableResult
	open func cycle(selector: Selector = .all, operation: Operation) throws -> [Result] {
		return try performAndHandleRequest(method: .post, path: [selector.string, "cycle"], body: operation, unwrapResults: true)
	}
	
	@discardableResult
	open func pulse(selector: Selector = .all, color: Color, period: Double = 0.75, cycles: Int = 3, powerOn: Bool = false) throws -> [Result] {
		let effect = Effect(color: color, period: period, cycles: cycles, powerOn: powerOn)
		return try pulse(selector: selector, effect: effect)
	}
	
	@discardableResult
	open func pulse(selector: Selector = .all, effect: Effect) throws -> [Result] {
		return try performAndHandleRequest(method: .post, path: [selector.string, "effects", "pulse"], body: effect, unwrapResults: true)
	}
	
	@discardableResult
	open func breathe(selector: Selector = .all, color: Color, period: Double = 0.75, cycles: Int = 3, persist: Bool = false, powerOn: Bool = true, peak: Double = 0.5) throws -> [Result] {
		let effect = Effect(color: color, period: period, cycles: cycles, persist: persist, powerOn: powerOn, peak: peak)
		return try breathe(selector: selector, effect: effect)
	}
	
	open func breathe(selector: Selector = .all, effect: Effect) throws -> [Result] {
		return try performAndHandleRequest(method: .post, path: [selector.string, "effects", "pulse"], body: effect, unwrapResults: true)
	}
}

extension Client {
	@discardableResult
	fileprivate func performAndHandleRequest<T: Decodable, D: Encodable>(method: HTTP.Method = .get, path components: [String], query: [String: CustomStringConvertible] = [:], body: D, unwrapResults: Bool) throws -> [T] {
		let requestBody = try ContentBody(object: body)
		return try performAndHandleRequest(method: method, path: components, query: query, body: requestBody, unwrapResults: unwrapResults)
	}
	
	@discardableResult
	fileprivate func performAndHandleRequest<T: Decodable>(method: HTTP.Method = .get, path components: [String], query: [String: CustomStringConvertible] = [:], body: ContentBody = .empty, unwrapResults: Bool) throws -> [T] {
		if unwrapResults {
			let wrapper: ResultsWraper<T> = try performDecodableRequest(method: method, path: components, query: query, body: body)
			return wrapper.results
		} else {
			return try performDecodableRequest(method: method, path: components, query: query, body: body)
		}
	}
	
}

private struct ResultsWraper<T: Decodable>: Decodable {
	let results: [T]
}
