//
//  TaskPaperDocument.swift
//  TaskPaperFramework
//
//  Created by Riess, Manuel on 20.03.18.
//  Copyright © 2018 kokodev.de. All rights reserved.
//

import Foundation
import BirchOutline

public typealias EmptyCompletionHandler = ()->()

public class TaskPaperDocument {
    
    private(set) var projects = [TaskPaperProject]()
    private(set) var tasks = [TaskPaperTask]()
    private(set) var notes = [TaskPaperNote]()
    private(set) var searches = [TaskPaperSearch]()
    
    private var outline: OutlineType?
    
    private let documentPath: String
    private let documentQueue = DispatchQueue(label: "de.kokodev.TaskPaper.TaskPaperDocument.Queue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    public init(taskPaperPath: String) {
        documentPath = taskPaperPath
    }
    
    public func load(completion: EmptyCompletionHandler?) {
        projects.removeAll()
        documentQueue.async {
            self.loadOutline(completion)
        }
    }
    
    private func loadOutline(_ completion: EmptyCompletionHandler?) {
        if let textContents = try? String(contentsOfFile: self.documentPath, encoding: .utf8)
        {
            outline = BirchOutline.createTaskPaperOutline(textContents)
            guard let outline = self.outline else {
                print("Failed to create outline from '\(self.documentPath)'")
                completion?()
                return
            }
            
            let generator = TaskPaperGenerator()
            generator.generateTaskPaper(from: outline)
            { (projects, tasks, notes, searches) in
                self.projects = projects
                self.tasks = tasks
                self.notes = notes
                self.searches = searches
                completion?()
            }
        } else {
            print("Failed to get text content of '\(self.documentPath)'")
            completion?()
        }
    }
    
}

