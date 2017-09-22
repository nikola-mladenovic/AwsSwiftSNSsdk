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
        
        let token = "A6063B1C6612954BEC2A18BDA9FDC17C67E117B40EB61447BCCB4375798A66EF"
        
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
        
        let token = "CE8D38C17B20BCA8566F2FD72CCF06445E6D45271CF4A9ADE0410F4ED85E052D"
        
        snsClient?.createPlatformEndpoint(token: token, platformApplicationArn: "arn:aws:sns:us-west-2:487164526243:app/APNS_SANDBOX/Test") { success, endpointArn, error in
            self.snsClient?.deleteEndpoint(endpointArn: endpointArn!) { success, error in
                XCTAssertNil(error, "DeletePlatformEndpoint returned error.")
                deleteExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetEndpointAttributes() {
        let getAttributesExpectation = expectation(description: "GetAttributesExpectation")
        
        let token = "BB7CDD1A628ABD5DE23EEE41C080751DF6EF166D8C16E2EC782C836D39458A10"
        
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
        
        let token = "4D54202891C45CC4D66EE1010C6A45C2E725433F6D4E5D173A4593E872C6E242"
        
        var attributes = ["Enabled" : "false", "Token" : token]
        
        snsClient?.createPlatformEndpoint(token: token, platformApplicationArn: "arn:aws:sns:us-west-2:487164526243:app/APNS_SANDBOX/Test") { success, endpointArn, error in
            self.snsClient?.setEndpointAttributes(endpointArn: endpointArn!, attributes: attributes) { (success, error) in
                XCTAssertTrue(success, "SetEndpointAttributes failed.")
                XCTAssertNil(error, "SetEndpointAttributes returned error.")
                
                attributes["Enabled"] = "true"
                attributes["Token"] = "7AC47B02ED68B0B0CA7BE04AD6B98635E376BD96620A29379D9F8711BE52AA9D"
                self.snsClient?.setEndpointAttributes(endpointArn: endpointArn!, attributes: attributes) { (success, error) in
                    XCTAssertTrue(success, "SetEndpointAttributes failed.")
                    XCTAssertNil(error, "SetEndpointAttributes returned error.")
                    self.snsClient?.getEndpointAttributes(endpointArn: endpointArn!, completion: { (success, responseAttributes, error) in
                        XCTAssertTrue(success, "GetEndpointAttributes failed.")
                        XCTAssertNil(error, "GetEndpointAttributes returned error.")
                        XCTAssertEqual(responseAttributes!.attributes["Enabled"], attributes["Enabled"], "Attributes not set properly.")
                        XCTAssertEqual(responseAttributes!.attributes["Token"], attributes["Token"]?.lowercased(), "Attributes not set properly.")
                        self.snsClient?.deleteEndpoint(endpointArn: endpointArn!) { _, _ in
                            setAttributesExpectation.fulfill()
                        }
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
