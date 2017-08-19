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
        
        snsClient?.publish(message: "TestMsg", topicArn: "arn:aws:sns:us-west-2:487164526243:msokol-test") { success, error in
            XCTAssertTrue(success, "Publish with string failed.")
            XCTAssertNil(error, "Publish returned error.")
            publishExpectation.fulfill()
        }
        waitForExpectations(timeout: 555, handler: nil)
        
        
    }
    
    func testPublishDictionary() {
        let publishExpectation = expectation(description: "PublishExpectation")
        
        snsClient?.publish(message: ["default" : "TestMsg"], topicArn: "arn:aws:sns:us-west-2:487164526243:msokol-test") { success, error in
            XCTAssertTrue(success, "Publish with dictionary failed.")
            XCTAssertNil(error, "Publish returned error.")
            publishExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreatePlatformEndpoint() {
        let createExpectation = expectation(description: "CreateExpectation")
        
        let token = "225EF46104D58C43047A4B7749B41297A3A185CB9D441784AFEB5C2F1405285C"
        
        snsClient?.createPlatformEndpoint(token: token, platformApplicationArn: "arn:aws:sns:us-west-2:487164526243:app/APNS_SANDBOX/Test") { success, endpointArn, error in
            XCTAssertTrue(success, "CreatePlatformEndpoint failed.")
            XCTAssertNotNil(endpointArn)
            XCTAssertNil(error, "CreatePlatformEndpoint returned error.")
            createExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testListPlatformApplications() {
        let recievedListExpectation = expectation(description: "RecievedListExpectation")
        
        snsClient?.listPlatformApplications { (success, response, error) in
            XCTAssertTrue(success, "ListPlatformApplications failed.")
            XCTAssertNotNil(response)
            XCTAssertNil(error, "ListPlatformApplications returned error.")
            recievedListExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testListEndpointsByPlatformApplication() {
        let recievedListExpectation = expectation(description: "RecievedListExpectation")
        
        let platformApplicationArn = "arn:aws:sns:us-west-2:487164526243:app/APNS_SANDBOX/Test"
        
        snsClient?.listEndpoints(for: platformApplicationArn) { (success, response, error) in
            XCTAssertTrue(success, "ListEndpointsByPlatformApplication failed.")
            XCTAssertNotNil(response)
            XCTAssertNil(error, "ListEndpointsByPlatformApplication returned error.")
            recievedListExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeletePlatformEndpoint() {
        let deleteExpectation = expectation(description: "CreateExpectation")
        
        let token = "225EF46104D58C43047A4B7749B41297A3A185CB9D441784AFEB5C2F1405285C"
        
        snsClient?.createPlatformEndpoint(token: token, platformApplicationArn: "arn:aws:sns:us-west-2:487164526243:app/APNS_SANDBOX/Test") { success, endpointArn, error in
            self.snsClient?.deleteEndpoint(endpointArn: endpointArn!) { success, error in
                XCTAssertNil(error, "DeletePlatformEndpoint returned error.")
                deleteExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    static var allTests = [
        ("testPublishString", testPublishString),
        ("testPublishDictionary", testPublishDictionary),
        ("testCreatePlatformEndpoint", testCreatePlatformEndpoint),
        ("testListPlatformApplications", testListPlatformApplications),
        ("testListEndpointsByPlatformApplication", testListEndpointsByPlatformApplication),
        ("testDeletePlatformEndpoint", testDeletePlatformEndpoint),
    ]
}
