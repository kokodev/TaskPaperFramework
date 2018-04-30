//
//  TaskPaperElement.swift
//  TaskPaperFramework
//
//  Created by Riess, Manuel on 22.03.18.
//  Copyright © 2018 kokodev.de. All rights reserved.
//

import Foundation
import BirchOutline

public protocol TaskPaperElementProtocol {

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

public class TaskPaperElement: TaskPaperElementProtocol {
        
    private let item: ItemType
    
    public var title: String {
        get {
            return item.bodyContent
        }
    }
    
    public required init(_ title: String) {
        let outline = BirchOutline.createTaskPaperOutline(nil)
        item = outline.createItem(title)
    }
    
    public required init(_ item: ItemType) {
        self.item = item
    }
    
    // MARK: - Tags
    
    private(set) public var tags = [TaskPaperTag]()
    
    public func addTag(_ tag: TaskPaperTag) {
        tags.append(tag)
        tags.sort { (tag1, tag2) -> Bool in
            return tag1.title.compare(tag2.title) == ComparisonResult.orderedAscending
        }
    }

    // MARK: - Subprojects
    
    private(set) public var projects = [TaskPaperProject]()
    
    public func addProject(_ project: TaskPaperProject) {
        projects.append(project)
    }
    
    public func project(at index: Int) -> TaskPaperProject? {
        if projects.count > index {
            return projects[index]
        }
        return nil
    }
    
    // MARK: - Tasks
    
    private(set) public var tasks = [TaskPaperTask]()
    
    public func addTask(_ task: TaskPaperTask) {
        tasks.append(task)
    }
    
    // MARK: - Notes
    
    public var notes = [TaskPaperNote]()
    
    public func addNote(_ note: TaskPaperNote) {
        notes.append(note)
    }
    
}
