//
//  Task.swift
//  Task List
//
//  Created by Иван Метальников on 06.10.2025.
//

import Foundation



struct Task : Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
}
