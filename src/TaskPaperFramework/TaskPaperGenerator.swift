//
//  TaskPaperGenerator.swift
//  TaskPaperFramework
//
//  Created by Riess, Manuel on 23.03.18.
//  Copyright © 2018 kokodev.de. All rights reserved.
//

import Foundation
import BirchOutline

public typealias TaskPaperGeneratorCallback = (([TaskPaperProject], [TaskPaperTask], [TaskPaperNote], [TaskPaperSearch])->())

public class TaskPaperGenerator {
    
    private struct Constants {
        static let projectSearches = "Searches"
    }
    
    enum Attributes: String {
        case dataType = "data-type"
        case indent = "indent"
        case data = "data-"
    }
    
    enum DataType: String {
        case project = "project"
        case task = "task"
        case note = "note"
    }
    
    private(set) var projects = [TaskPaperProject]()
    private(set) var tasks = [TaskPaperTask]()
    private(set) var notes = [TaskPaperNote]()
    private(set) var searches = [TaskPaperSearch]()

    public func generateTaskPaper(from outline: OutlineType, completion: @escaping TaskPaperGeneratorCallback) {
        let items = outline.items
        var itemIterator = items.makeIterator()
        collectObjects(forElement: nil, withIterator: &itemIterator)
        completion(projects, tasks, notes, searches)
    }
    
    fileprivate func collectObjects(forElement element: TaskPaperElement?, withIterator itemIterator: inout IndexingIterator<[ItemType]>)
    {
        while let item = itemIterator.next() {
            guard let rawType = item.attributeForName(Attributes.dataType.rawValue) else {
                print("Item \(item) does not contain a data type")
                break
            }
            
            guard let dataType = DataType(rawValue: rawType) else {
                print("Unknown data type: \(rawType)")
                break
            }
            
            switch dataType {
            case .project:
                processProjectItem(item, forElement: element, withIterator: &itemIterator)
            case .task:
                processTaskItem(item, forElement: element, withIterator: &itemIterator)
            case .note:
                processNoteItem(item, forElement: element, withIterator: &itemIterator)
            }
            
            if item.nextSibling == nil {
                break
            }
        }
    }
    
    fileprivate func processProjectItem(_ item: ItemType, forElement element: TaskPaperElement?, withIterator itemIterator: inout IndexingIterator<[ItemType]>)
    {
        let newElement: TaskPaperElement
        if item.bodyContent == Constants.projectSearches {
            newElement = TaskPaperSearch(item)
        } else {
            newElement = TaskPaperProject(item)
        }
        
        if item.children.count > 0 {
            collectObjects(forElement: newElement, withIterator: &itemIterator)
        }
        
        processTags(item, forElement: newElement)

        if let element = element {
            element.addProject(newElement as! TaskPaperProject)
        } else {
            if item.bodyContent == Constants.projectSearches {
                searches.append(newElement as! TaskPaperSearch)
            } else {
                projects.append(newElement as! TaskPaperProject)
            }
        }
    }
    
    fileprivate func processTaskItem(_ item: ItemType, forElement element: TaskPaperElement?, withIterator itemIterator: inout IndexingIterator<[ItemType]>) {
        let newTask = TaskPaperTask(item)
        if item.children.count > 0 {
            collectObjects(forElement: newTask, withIterator: &itemIterator)
        }
        
        processTags(item, forElement: newTask)

        if let element = element {
            element.addTask(newTask)
        } else {
            tasks.append(newTask)
        }
    }
    
    fileprivate func processNoteItem(_ item: ItemType, forElement element: TaskPaperElement?, withIterator itemIterator: inout IndexingIterator<[ItemType]>) {
        if item.body.lengthOfBytes(using: .utf8) > 0 {
            let newNote = TaskPaperNote(item)
            if item.children.count > 0 {
                collectObjects(forElement: newNote, withIterator: &itemIterator)
            }
            
            processTags(item, forElement: newNote)

            if let element = element {
                element.addNote(newNote)
            } else {
                notes.append(newNote)
            }
        }
    }

    fileprivate func processTags(_ item: ItemType, forElement element: TaskPaperElement?) {
        for attribute in item.attributes {
            if attribute.key != Attributes.dataType.rawValue &&
                attribute.key != Attributes.indent.rawValue {
                if let range = attribute.key.range(of: Attributes.data.rawValue) {
                    let title = attribute.key[range.upperBound...]
                    let attributeValues = attribute.value.split(separator: ",", maxSplits: Int.max, omittingEmptySubsequences: true).map {
                        $0.trimmingCharacters(in: .whitespaces)
                    }
                    let values = attributeValues.count > 0 ? attributeValues : nil
                    let tag = TaskPaperTag(title: String(title), values: values)
                    element?.addTag(tag)
                }
            }
        }
    }

}
