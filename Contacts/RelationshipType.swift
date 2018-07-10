//
//  RelationshipType.swift
//  Contacts
//
//  Created by eOne Bilch Enko on 19.06.18.
//  Copyright © 2018 eOne Bilch Enko. All rights reserved.
//

import UIKit

enum RelationshipType: Int {
    
    case family
    case love
    case work
    case friend
    case general
    
    static let count: Int = {
        var max: Int = 0
        while let _ = RelationshipType(rawValue: max) { max += 1 }
        return max
    }()

    func getImage() -> UIImage {
        switch self {
        case .family:
            return UIImage(named: "family")!
        case .love:
            return UIImage(named: "love")!
        case .work:
            return UIImage(named: "work")!
        case .friend:
            return UIImage(named: "friend")!
        case .general:
            return UIImage(named: "general")!
        }
    }

    func getNameType() -> String {
        switch self {
        case .family:
            return "Family"
        case .love:
            return "Love"
        case .work:
            return "Work"
        case .friend:
            return "Friend"
        case .general:
            return "General"
        }
    }
}
