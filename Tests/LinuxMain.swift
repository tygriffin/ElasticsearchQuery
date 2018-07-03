import XCTest

import ElasticsearchQueryTests

var tests = [XCTestCaseEntry]()
tests += ElasticsearchQueryTests.allTests()
XCTMain(tests)