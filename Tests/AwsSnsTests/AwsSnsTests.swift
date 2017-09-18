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
        
        let token = "225EF46104D58C43047A4B7749B41297A3185CB9D441784AFEB5C2F1405285C"
        
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
        
        let token = "6110cff81aea420ef5017029ef82dd5b44a018fae1c9a83a6ca8be5b4109bceb"
        
        snsClient?.createPlatformEndpoint(token: token, platformApplicationArn: "arn:aws:sns:us-west-2:487164526243:app/APNS_SANDBOX/Test") { success, endpointArn, error in
            guard let endpointArn = endpointArn else {
                XCTFail("CreatePlatformEndpoint returned nil.")
                return
            }
            self.snsClient?.deleteEndpoint(endpointArn: endpointArn) { success, error in
                XCTAssertNil(error, "DeletePlatformEndpoint returned error.")
                deleteExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetEndpointAttributes() {
        let getAttributesExpectation = expectation(description: "GetAttributesExpectation")
        
        let token = "7c406c64b1e05169e6f3114c0d58ef84b11ad044300f24ca40c7ee544bc61bb8"
        
        snsClient?.createPlatformEndpoint(token: token, platformApplicationArn: "arn:aws:sns:us-west-2:487164526243:app/APNS_SANDBOX/Test") { success, endpointArn, error in
            self.snsClient?.getEndpointAttributes(endpointArn: endpointArn!) { (success, attributes, error) in
                XCTAssertTrue(success, "GetEndpointAttributes failed.")
                XCTAssertNotNil(attributes)
                XCTAssertNil(error, "GetEndpointAttributes returned error.")
                getAttributesExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSetEndpointAttributes() {
        let setAttributesExpectation = expectation(description: "SetAttributesExpectation")
        
        let token = "4a457987158e7703bab15cfa4f8850b469a7c2547fcb477f5c1932d3c21febb4"
        
        var attributes = ["Enabled" : "false", "Token" : token]
        
        snsClient?.createPlatformEndpoint(token: token, platformApplicationArn: "arn:aws:sns:us-west-2:487164526243:app/APNS_SANDBOX/Test") { success, endpointArn, error in
            self.snsClient?.setEndpointAttributes(endpointArn: endpointArn!, attributes: attributes) { (success, error) in
                XCTAssertTrue(success, "SetEndpointAttributes failed.")
                XCTAssertNil(error, "SetEndpointAttributes returned error.")
                
                attributes["Enabled"] = "true"
                attributes["Token"] = "03618de36c572bec302d0d85a24d30cc1cf99c98168a9c8c77653f02221bfad3"
                self.snsClient?.setEndpointAttributes(endpointArn: endpointArn!, attributes: attributes) { (success, error) in
                    XCTAssertTrue(success, "SetEndpointAttributes failed.")
                    XCTAssertNil(error, "SetEndpointAttributes returned error.")
                    self.snsClient?.getEndpointAttributes(endpointArn: endpointArn!, completion: { (success, responseAttributes, error) in
                        XCTAssertTrue(success, "GetEndpointAttributes failed.")
                        XCTAssertNil(error, "GetEndpointAttributes returned error.")
                        XCTAssertEqual(responseAttributes!.attributes["Enabled"], attributes["Enabled"], "Attributes not set properly.")
                        XCTAssertEqual(responseAttributes!.attributes["Token"], attributes["Token"], "Attributes not set properly.")
                        setAttributesExpectation.fulfill()
                    })
                }
            }
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    static var allTests = [
        ("testPublishString", testPublishString),
        ("testPublishDictionary", testPublishDictionary),
        ("testCreatePlatformEndpoint", testCreatePlatformEndpoint),
        ("testListPlatformApplications", testListPlatformApplications),
        ("testListEndpointsByPlatformApplication", testListEndpointsByPlatformApplication),
        ("testDeletePlatformEndpoint", testDeletePlatformEndpoint),
        ("testGetEndpointAttributes", testGetEndpointAttributes),
        ("testSetEndpointAttributes", testSetEndpointAttributes),
    ]
}
