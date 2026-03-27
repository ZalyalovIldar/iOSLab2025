//
//  TaskRepository.swift
//  Task List
//
//  Created by Иван Метальников on 06.10.2025.
//
import Observation
import Foundation
import SwiftUI

@Observable
class TaskRepository{
    var tasks: [Task] = []
    
    func addTask(_ task_title: String){
        tasks.append(
            Task(title: task_title)
        )
    }
    
    func removeTask(at offsets: IndexSet){
        tasks.remove(atOffsets: offsets)
    }
}
