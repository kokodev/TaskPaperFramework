//
//  TaskPaperDocumentTests.swift
//  TaskPaperFrameworkTests
//
//  Created by Riess, Manuel on 20.03.18.
//  Copyright © 2018 kokodev.de. All rights reserved.
//

import XCTest
@testable import TaskPaper

class TaskPaperDocumentTests: XCTestCase {
    
    var document: TaskPaperDocument!
    
    override func setUp() {
        super.setUp()
        
        let path = Bundle(for: TaskPaperDocumentTests.self).path(forResource: "FullDocument", ofType: "taskpaper")!
        document = TaskPaperDocument(taskPaperPath: path)
    }

    override func tearDown() {
        document = nil
    }

    func testLoad() {
        let expect = expectation(description: "Document Loaded")
        
        document.load() {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler:nil)
        
        // FIXME: These tests are very risky. They will eventually not only fail, but crash.
        
        XCTAssertEqual(document.projects.count, 4)
        XCTAssertEqual(document.projects[0].tasks[0].tags.count, 3)
        XCTAssertEqual(document.projects[0].tasks[0].tags[1].values?.count, 2)
        XCTAssertEqual(document.projects[0].tasks[0].tags[1].values![0], "123")
        XCTAssertEqual(document.projects[0].tasks[0].tags[1].values![1], "456")
        XCTAssertEqual(document.projects[0].tasks[0].tags[2].values![0], "123")
        XCTAssertEqual(document.projects[0].tasks[0].projects.count, 1)
        XCTAssertEqual(document.projects[0].tasks[0].projects[0].tasks.count, 1)
        XCTAssertEqual(document.projects[0].tasks.count, 6)
        XCTAssertEqual(document.projects[0].tasks[1].notes.count, 1)
        
        XCTAssertEqual(document.projects[1].projects.count, 2)
        XCTAssertEqual(document.projects[1].projects[0].tasks.count, 3)
        XCTAssertEqual(document.projects[1].projects[1].tasks.count, 3)
        XCTAssertEqual(document.projects[1].projects[1].tasks[1].notes.count, 1)
        XCTAssertEqual(document.projects[1].projects[1].tasks[1].notes[0].title, "Note for task 2-2-2")
        XCTAssertEqual(document.projects[1].tasks.count, 4)

        XCTAssertEqual(document.tasks.count, 1)
        XCTAssertEqual(document.tasks[0].title, "Toplevel Task")

        XCTAssertEqual(document.notes.count, 2)
        XCTAssertEqual(document.notes[0].title, "Toplevel Note")

        XCTAssertEqual(document.searches.count, 1)
    }
        
}
