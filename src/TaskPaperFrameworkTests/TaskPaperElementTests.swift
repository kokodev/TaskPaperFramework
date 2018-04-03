//
//  TaskPaperProjectTests.swift
//  TaskPaperFrameworkTests
//
//  Created by Riess, Manuel on 21.03.18.
//  Copyright © 2018 kokodev.de. All rights reserved.
//

import XCTest
import BirchOutline

@testable import TaskPaper

class TaskPaperElementTests: XCTestCase {
    
    var project: TaskPaperProject!
    var outline: OutlineType!

    override func setUp() {
        super.setUp()
        
        let path = Bundle(for: TaskPaperDocumentTests.self).path(forResource: "SingleProject", ofType: "taskpaper")!
        let textContents = try! String(contentsOfFile: path, encoding: .utf8)
        
        outline = BirchOutline.createTaskPaperOutline(textContents)

        let expect = expectation(description: "Taskpaper Generated")

        let generator = TaskPaperGenerator()
        generator.generateTaskPaper(from: outline) { (projects, tasks, notes, searches) in
            XCTAssertEqual(projects.count, 1)
            self.project = projects[0]
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler:nil)
    }
    
    override func tearDown() {
        super.tearDown()
        outline = nil
    }
    
    func testInitWithTitle() {
        let project = TaskPaperProject("title")
        XCTAssertEqual(project.title, "title")
    }
    
    func testInitWithItemType() {
        let item = outline.items.first!
        let project = TaskPaperProject(item)
        XCTAssertEqual(project.title, "Project 1")
    }
    
    func testAddSubproject() {
        let item = outline.createItem("title")
        let project = TaskPaperProject(item)

        let subItem = outline.createItem("subTitle")
        let subproject = TaskPaperProject(subItem)
        
        project.addProject(subproject)
        
        XCTAssertEqual(project.projects.count, 1)
        XCTAssertNotNil(project.project(at: 0))
    }
}
