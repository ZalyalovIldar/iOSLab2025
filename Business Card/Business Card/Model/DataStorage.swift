//
//  Menu.swift
//  Business Card
//
//  Created by Ляйсан on 12.09.2025.
//

import Foundation
import SwiftUI

struct DataStorage {
    var categories = [Category(icon: "person.text.rectangle.fill", iconBackgroundColor: .gray, title: Text("Personal Information"), categoryType: .personalInformation),
                      Category(icon: "sun.max.fill", iconBackgroundColor: .blue, title: Text("Display"), categoryType: .display)]
    
    struct Category: Identifiable {
        let id = UUID()
        let icon: String
        let iconBackgroundColor: Color
        let title: Text
        let categoryType: CategoryType
    }
    
    enum CategoryType {
        case personalInformation
        case display
    }
    
    struct AccentColor: Identifiable {
        let id = UUID()
        let color: Color
        let name: String
    }
    
    var accentColors = [AccentColor(color: Color(.systemBlue), name: "systemBlue"),
                        AccentColor(color: Color(.systemPurple), name: "systemPurple"),
                        AccentColor(color: Color(.systemPink), name: "systemPink"),
                        AccentColor(color: Color(.systemRed), name: "systemRed"),
                        AccentColor(color: Color(.systemOrange), name: "systemOrange"),
                        AccentColor(color: Color(.systemYellow), name: "systemYellow"),
                        AccentColor(color: Color(.systemGreen), name: "systemGreen"),
                        AccentColor(color: Color(.systemGray), name: "systemGray")]
    
    static func stringToColor(color: String) -> Color {
        switch color {
            case "systemBlue": return Color(.systemBlue)
            case "systemPurple": return Color(.systemPurple)
            case "systemPink": return Color(.systemPink)
            case "systemRed": return Color(.systemRed)
            case "systemOrange": return Color(.systemOrange)
            case "systemYellow": return Color(.systemYellow)
            case "systemGreen": return Color(.systemGreen)
            case "systemGray": return Color(.systemGray)
            default: return Color(.systemBlue)
        }
    }
    
    static var gitHubAccountLink: URL? {
        URL(string: "https://github.com/Lyasan-byte")
    }
    
}
