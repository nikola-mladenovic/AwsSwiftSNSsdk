import XCTest
@testable import AwsSns

class AwsSnsTests: XCTestCase {
    static let key = ProcessInfo.processInfo.environment["AWS_KEY"]!
    static let secret = ProcessInfo.processInfo.environment["AWS_SECRET"]!
    static let host = "https://sns.us-west-2.amazonaws.com/"
    
    var snsClient: AwsSns?
    
    override func setUp() {
        super.setUp()
        
        snsClient = AwsSns(host: AwsSnsTests.host, accessKeyId: AwsSnsTests.key, secretAccessKey: AwsSnsTests.secret)
    }
    
    func testPublishString() {
        let publishExpectation = expectation(description: "PublishExpectation")
        var success = false
        var error: Error?
        
        snsClient?.publish(message: "TestMsg", topicArn: "arn:aws:sns:us-west-2:487164526243:msokol-test", completion: { (rSuccess, rError) in
            success = rSuccess
            error = rError
            publishExpectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(success, "Publish with string failed.")
        XCTAssertNil(error, "Publish returned error.")
    }
    
    func testPublishDictionary() {
        let publishExpectation = expectation(description: "PublishExpectation")
        var success = false
        var error: Error?
        
        snsClient?.publish(message: ["default" : "TestMsg"], topicArn: "arn:aws:sns:us-west-2:487164526243:msokol-test", completion: { (rSuccess, rError) in
            success = rSuccess
            error = rError
            publishExpectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(success, "Publish with dictionary failed.")
        XCTAssertNil(error, "Publish returned error.")
    }


    static var allTests = [
        ("testPublishString", testPublishString),
        ("testPublishDictionary", testPublishDictionary),
    ]
}
