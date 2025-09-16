//
//  Menu.swift
//  Business Card
//
//  Created by Ляйсан on 12.09.2025.
//

import Foundation
import SwiftUI

struct DataStorage {
    var categories = [Category(icon: "person.text.rectangle.fill", iconBackgroundColor: .gray, title: "Personal Information", categoryType: .personalInformation),
                      Category(icon: "sun.max.fill", iconBackgroundColor: .blue, title: "Display", categoryType: .display),
                      Category(icon: "globe", iconBackgroundColor: .blue, title: "Language", categoryType: .language),
                      Category(icon: "square.and.arrow.up", iconBackgroundColor: .green, title: "Share", categoryType: .share)]
    
    struct Category: Identifiable {
        let id = UUID()
        let icon: String
        let iconBackgroundColor: Color
        let title: String
        let categoryType: CategoryType
    }
    
    enum CategoryType {
        case personalInformation
        case display
        case language
        case share
    }
    
}
