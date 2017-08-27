//
//  LIFXClient.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/18/16.
//
//

import Foundation
import HTTP
import Vapor
import JSONClient

enum LIFXError: Error {
	case invalidJson(JSON)
	case invalidParameter(String)
	case apiError(String)
	case unknown
}

extension String {
	static let lifxEndpoint = "https://api.lifx.com/v1/lights"
}

class LIFXClient: JSONClient {
	
	let token: String
	
	init(token: String, client: Responder) {
		self.token = token
		super.init(baseUrl: .lifxEndpoint, client: client)
	}
	
	override func headers() -> [HTTP.HeaderKey : String] {
		var headers = super.headers()
		headers["Authorization"] = "Bearer \(token)"
		return headers
	}
	
	@discardableResult
	func list(selector: LIFXSelector = .all) throws -> [LIFXBulb] {
		return try performAndHandleRequest(pathComponents: [selector.string], contentKey: nil)
	}
	
	@discardableResult
	func setState(selector: LIFXSelector = .all, state: LIFXState) throws -> [LIFXResult] {
		let encoder = LIFXStateEncoder(state: state)
		guard let body = encoder.getJSONValues() as? [String: CustomStringConvertible] else {
			fatalError("Invalid parameters \(encoder.getJSONValues())")
		}
		return try performAndHandleRequest(method: .put, pathComponents: [selector.string, "state"], body: body, contentKey: "results")
	}
	
	@discardableResult
	func setStates(operations: [(selector: LIFXSelector, state: LIFXState)], defaults: LIFXState? = nil) throws -> [LIFXOperationResult] {
		guard operations.count > 0 else {
			throw LIFXError.invalidParameter("operations")
		}
		
		let operationsBody: [[String: Any]] = operations.map { selector, state in
			var dictionary = state.encoded().getJSONValues()
			dictionary["selector"] = selector.string
			return dictionary
		}
		var body: [String: Any] = ["states": operationsBody]
		if let defaults = defaults {
			body["defaults"] = defaults.encoded().getJSONValues()
		}
		
		return try performAndHandleRequest(method: .put, pathComponents: ["states"], body: body, contentKey: "results")
	}
	
	@discardableResult
	func cycle(selector: LIFXSelector = .all, states: [LIFXState], defaults: LIFXState? = nil) throws -> [LIFXResult] {
		guard states.count > 0 else {
			throw LIFXError.invalidParameter("states")
		}
		
		let statesValues = states.map { $0.encoded().getJSONValues() }
		var body: [String: Any] = ["states": statesValues]
		if let defaults = defaults {
			body["defaults"] = defaults.encoded().getJSONValues()
		}
		
		return try performAndHandleRequest(method: .post, pathComponents: [selector.string, "cycle"], body: body, contentKey: "results")
	}
	
	@discardableResult
	func pulse(selector: LIFXSelector = .all, color: LIFXColor, period: Double = 0.75, cycles: Double = 3) throws -> [LIFXResult] {
		let body: [String: Any] = [
			"color": color.string,
			"period": period,
			"cycles": cycles,
			"power_on": false
		]
		
		return try performAndHandleRequest(method: .post, pathComponents: [selector.string, "effects", "pulse"], body: body, contentKey: "results")
	}
	
	@discardableResult
	func breathe(selector: LIFXSelector = .all, color: LIFXColor, period: Double = 0.75, cycles: Double = 3, persist: Bool = false, powerOn: Bool = true, peak: Double = 0.5) throws -> [LIFXResult] {
		let body: [String: Any] = [
			"color": color.string,
			"period": period,
			"cycles": cycles,
			"persist": persist,
			"power_on": powerOn,
			"peak": peak
		]
		
		return try performAndHandleRequest(method: .post, pathComponents: [selector.string, "effects", "pulse"], body: body, contentKey: "results")
	}
}

extension LIFXClient {
	@discardableResult
	fileprivate func performAndHandleRequest<T: JSONInitializable>(method: HTTP.Method = .get, pathComponents components: [String], query: [String: CustomStringConvertible] = [:], body: [String: Any]? = nil, contentKey key: String?) throws -> [T] {
		
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
		
		let result = try performRequest(method: method, pathComponents: components, query: query, body: requestBody)
		return try self.handleRequestResult(result, contentKey: key)
	}
	
	//	Receives a request result, validates it and calls the completion handler with a a result with 
	//	either an error or an array of objects of type T, where T is infered from the completion handler
	fileprivate func handleRequestResult<T: JSONInitializable>(_ result: JSON, contentKey key: String?) throws -> [T] {
		let result: [JSON] = try validateRequestResult(result, contentKey: key)
		
		return try result.flatMap(T.init)
	}
	
	//	Validates the request result by making sure it's a success and that the json has no errors
	fileprivate func validateRequestResult(_ result: JSON, contentKey key: String?) throws -> [JSON] {
		return try validateJson(result, contentKey: key)
	}
	
	fileprivate func validateJson(_ json: JSON, contentKey key: String?) throws -> [JSON] {
		let jsonContent: JSON = {
			if let key = key {
				return json[key]!
			} else {
				return json
			}
		}()
		
		guard let object = jsonContent.array else {
			if let error = json["error"]!.string {
				throw LIFXError.apiError(error)
			} else {
				throw LIFXError.invalidJson(json)
			}
		}
		return object
	}
}
