//
//  LIFXSelector.swift
//  LIFX
//
//  Created by Emilio Peláez on 12/24/16.
//
//

import Foundation

public struct LIFXSelector {
	
	public struct Identifier {
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
		
		public static let all = Identifier(value: "", category: .all)
	}
	
	public static let all = LIFXSelector(identifier: .all)
	
	public var identifiers = Set<Identifier>()
	
	public init() { }
	
	fileprivate init(identifiers: Set<Identifier>) {
		self.identifiers = identifiers
	}
	
	public init(value: String, category: Identifier.Category) {
		let identifier = Identifier(value: value, category: category)
		self.init(identifier: identifier)
	}
	
	public init(identifier: Identifier) {
		identifiers.insert(identifier)
	}
	
	public init(identifier: [Identifier]) {
		self.identifiers = Set(identifier)
	}
	
	var string: String {
		return identifiers
			.map { $0.string }
			.joined(separator: ",")
	}
}

extension LIFXSelector {
	public static func +(lhs: LIFXSelector, rhs: LIFXSelector) -> LIFXSelector {
		let set = lhs.identifiers.union(rhs.identifiers)
		return LIFXSelector(identifiers: set)
	}
}

extension LIFXSelector: Equatable {
	public static func ==(lhs: LIFXSelector, rhs: LIFXSelector) -> Bool {
		return lhs.identifiers == rhs.identifiers
	}
}

extension LIFXSelector: Hashable {
	public var hashValue: Int { return string.hashValue }
}

extension LIFXSelector.Identifier: Equatable {
	public static func ==(lhs: LIFXSelector.Identifier, rhs: LIFXSelector.Identifier) -> Bool {
		return lhs.string == rhs.string
	}
}

extension LIFXSelector.Identifier: Hashable {
	public var hashValue: Int { return string.hashValue }
}
