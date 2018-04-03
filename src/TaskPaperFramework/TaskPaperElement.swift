//
//  TaskPaperElement.swift
//  TaskPaperFramework
//
//  Created by Riess, Manuel on 22.03.18.
//  Copyright © 2018 kokodev.de. All rights reserved.
//

import Foundation
import BirchOutline

protocol TaskPaperElementProtocol {

    init(_ title: String)
    init(_ item: ItemType)

    var title: String { get }

    var tags: [TaskPaperTag] { get }
    func addTag(_ tag: TaskPaperTag)
    
    var projects: [TaskPaperProject] { get }
    func addProject(_ project: TaskPaperProject)
    func project(at index: Int) -> TaskPaperProject?

    var tasks: [TaskPaperTask] { get }
    func addTask(_ task: TaskPaperTask)

    var notes: [TaskPaperNote] { get }
    func addNote(_ note: TaskPaperNote)

}

class TaskPaperElement: TaskPaperElementProtocol {
        
    private let item: ItemType
    
    var title: String {
        get {
            return item.bodyContent
        }
    }
    
    required init(_ title: String) {
        let outline = BirchOutline.createTaskPaperOutline(nil)
        item = outline.createItem(title)
    }
    
    required init(_ item: ItemType) {
        self.item = item
    }
    
    // MARK: - Tags
    
    private(set) var tags = [TaskPaperTag]()
    
    func addTag(_ tag: TaskPaperTag) {
        tags.append(tag)
        tags.sort { (tag1, tag2) -> Bool in
            return tag1.title.compare(tag2.title) == ComparisonResult.orderedAscending
        }
    }

    // MARK: - Subprojects
    
    private(set) var projects = [TaskPaperProject]()
    
    func addProject(_ project: TaskPaperProject) {
        projects.append(project)
    }
    
    func project(at index: Int) -> TaskPaperProject? {
        if projects.count > index {
            return projects[index]
        }
        return nil
    }
    
    // MARK: - Tasks
    
    private(set) var tasks = [TaskPaperTask]()
    
    func addTask(_ task: TaskPaperTask) {
        tasks.append(task)
    }
    
    // MARK: - Notes
    
    var notes = [TaskPaperNote]()
    
    func addNote(_ note: TaskPaperNote) {
        notes.append(note)
    }
    
}
