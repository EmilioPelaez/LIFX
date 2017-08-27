//
//  LIFXSelector.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

public struct LIFXSelector {
	
	public struct Selector {
		public enum Category: String {
			case all
			case label
			case id
			case groupId = "group_id"
			case group
			case locationId = "location_id"
			case location
			case sceneId = "scene_id"
		}
		
		public let value: String
		public let category: Category
		
		public var string: String {
			guard category != .all else { return Category.all.rawValue }
			return "\(category.rawValue):\(value)"
		}
		
		public static let all = Selector(value: "", category: .all)
	}
	
	public static let all = LIFXSelector(selector: .all)
	
	public var selectors = Set<Selector>()
	
	public init() { }
	
	fileprivate init(selectors: Set<Selector>) {
		self.selectors = selectors
	}
	
	public init(value: String, category: Selector.Category) {
		let selector = Selector(value: value, category: category)
		self.init(selector: selector)
	}
	
	public init(selector: Selector) {
		selectors.insert(selector)
	}
	
	public init(selectors: [Selector]) {
		self.selectors = Set(selectors)
	}
	
	var string: String {
		return selectors
			.map { $0.string }
			.joined(separator: ",")
	}
}

extension LIFXSelector {
	public static func +(lhs: LIFXSelector, rhs: LIFXSelector) -> LIFXSelector {
		let set = lhs.selectors.union(rhs.selectors)
		return LIFXSelector(selectors: set)
	}
}

extension LIFXSelector: Equatable {
	public static func ==(lhs: LIFXSelector, rhs: LIFXSelector) -> Bool {
		return lhs.selectors == rhs.selectors
	}
}

extension LIFXSelector: Hashable {
	public var hashValue: Int { return string.hashValue }
}

extension LIFXSelector.Selector: Equatable {
	public static func ==(lhs: LIFXSelector.Selector, rhs: LIFXSelector.Selector) -> Bool {
		return lhs.string == rhs.string
	}
}

extension LIFXSelector.Selector: Hashable {
	public var hashValue: Int { return string.hashValue }
}
