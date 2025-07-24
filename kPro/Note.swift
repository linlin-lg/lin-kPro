//
//  Note.swift
//  kPro
//
//  Created by KPLiOS on 2025/5/30.
//

import Foundation
import UIKit

// MARK: - Note Category
enum NoteCategory: String, Codable {
    case general
    case stock
    
    var displayName: String {
        switch self {
        case .general:
            return "普通"
        case .stock:
            return "股票"
        }
    }
    
    var icon: String {
        switch self {
        case .general:
            return "note.text"
        case .stock:
            return "chart.line.uptrend.xyaxis"
        }
    }
}

struct Note: Codable {
    let id: UUID
    var title: String
    var content: String
    let createdAt: Date
    var modifiedAt: Date
    var color: NoteColor
    var tags: [String]
    var category: NoteCategory
    
    init(title: String = "", 
         content: String = "", 
         color: NoteColor = .default, 
         tags: [String] = [],
         category: NoteCategory = .general) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.color = color
        self.tags = tags
        self.category = category
    }
    
    mutating func update(title: String? = nil, 
                        content: String? = nil, 
                        color: NoteColor? = nil, 
                        tags: [String]? = nil,
                        category: NoteCategory? = nil) {
        if let title = title {
            self.title = title
        }
        if let content = content {
            self.content = content
        }
        if let color = color {
            self.color = color
        }
        if let tags = tags {
            self.tags = tags
        }
        if let category = category {
            self.category = category
        }
        self.modifiedAt = Date()
    }
}

// MARK: - Note Color
enum NoteColor: String, CaseIterable, Codable {
    case `default` = "default"
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case blue = "blue"
    case purple = "purple"
    case pink = "pink"
    
    var uiColor: UIColor {
        switch self {
        case .default:
            return .systemBackground
        case .red:
            return UIColor { trait in
                trait.userInterfaceStyle == .dark ? UIColor(red: 0.4, green: 0.1, blue: 0.1, alpha: 1.0) : UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)
            }
        case .orange:
            return UIColor { trait in
                trait.userInterfaceStyle == .dark ? UIColor(red: 0.45, green: 0.25, blue: 0.1, alpha: 1.0) : UIColor(red: 1.0, green: 0.95, blue: 0.9, alpha: 1.0)
            }
        case .yellow:
            return UIColor { trait in
                trait.userInterfaceStyle == .dark ? UIColor(red: 0.45, green: 0.45, blue: 0.1, alpha: 1.0) : UIColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
            }
        case .green:
            return UIColor { trait in
                trait.userInterfaceStyle == .dark ? UIColor(red: 0.1, green: 0.4, blue: 0.1, alpha: 1.0) : UIColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1.0)
            }
        case .blue:
            return UIColor { trait in
                trait.userInterfaceStyle == .dark ? UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 1.0) : UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0)
            }
        case .purple:
            return UIColor { trait in
                trait.userInterfaceStyle == .dark ? UIColor(red: 0.25, green: 0.1, blue: 0.4, alpha: 1.0) : UIColor(red: 0.95, green: 0.9, blue: 1.0, alpha: 1.0)
            }
        case .pink:
            return UIColor { trait in
                trait.userInterfaceStyle == .dark ? UIColor(red: 0.4, green: 0.1, blue: 0.25, alpha: 1.0) : UIColor(red: 1.0, green: 0.9, blue: 0.95, alpha: 1.0)
            }
        }
    }
    
    var accentColor: UIColor {
        switch self {
        case .default:
            return .systemBlue
        case .red:
            return .systemRed
        case .orange:
            return .systemOrange
        case .yellow:
            return .systemYellow
        case .green:
            return .systemGreen
        case .blue:
            return .systemBlue
        case .purple:
            return .systemPurple
        case .pink:
            return .systemPink
        }
    }
    
    var displayName: String {
        switch self {
        case .default:
            return "默认"
        case .red:
            return "红色"
        case .orange:
            return "橙色"
        case .yellow:
            return "黄色"
        case .green:
            return "绿色"
        case .blue:
            return "蓝色"
        case .purple:
            return "紫色"
        case .pink:
            return "粉色"
        }
    }
} 