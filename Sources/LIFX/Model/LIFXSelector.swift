//
//  LIFXSelector.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

struct LIFXSelector {
	
	struct Selector {
		enum Category: String {
			case all
			case label
			case id
			case groupId = "group_id"
			case group
			case locationId = "location_id"
			case location
			case sceneId = "scene_id"
		}
		
		let value: String
		let category: Category
		
		var string: String {
			guard category != .all else { return Category.all.rawValue }
			return "\(category.rawValue):\(value)"
		}
		
		static let all = Selector(value: "", category: .all)
	}
	
	static let all = LIFXSelector(selector: .all)
	
	var selectors = Set<Selector>()
	
	init() { }
	
	fileprivate init(selectors: Set<Selector>) {
		self.selectors = selectors
	}
	
	init(value: String, category: Selector.Category) {
		let selector = Selector(value: value, category: category)
		self.init(selector: selector)
	}
	
	init(selector: Selector) {
		selectors.insert(selector)
	}
	
	init(selectors: [Selector]) {
		self.selectors = Set(selectors)
	}
	
	var string: String {
		return selectors
			.map { $0.string }
			.joined(separator: ",")
	}
}

extension LIFXSelector {
	static func +(lhs: LIFXSelector, rhs: LIFXSelector) -> LIFXSelector {
		let set = lhs.selectors.union(rhs.selectors)
		return LIFXSelector(selectors: set)
	}
}

extension LIFXSelector: Equatable {
	static func ==(lhs: LIFXSelector, rhs: LIFXSelector) -> Bool {
		return lhs.selectors == rhs.selectors
	}
}

extension LIFXSelector: Hashable {
	var hashValue: Int { return string.hashValue }
}

extension LIFXSelector.Selector: Equatable {
	static func ==(lhs: LIFXSelector.Selector, rhs: LIFXSelector.Selector) -> Bool {
		return lhs.string == rhs.string
	}
}

extension LIFXSelector.Selector: Hashable {
	var hashValue: Int { return string.hashValue }
}
