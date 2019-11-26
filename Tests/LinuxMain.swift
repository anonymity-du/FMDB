import XCTest

import FMDBTests

var tests = [XCTestCaseEntry]()
tests += FMDBTests.allTests()
XCTMain(tests)
