import Foundation
import SWXMLHash

public struct PlatformApplications {
    public let nextToken: String?
    public let applicationArns: [String]
    
    init?(xml: XMLIndexer) {
        let responseXml = xml["ListPlatformApplicationsResponse"]["ListPlatformApplicationsResult"]
        let optionalArns = responseXml["PlatformApplications"]["member"].all.map { $0["PlatformApplicationArn"].element?.text }
        
        guard let applicationArns = optionalArns as? [String] else { return nil }
        self.applicationArns = applicationArns
        nextToken = responseXml["NextToken"].element?.text
    }
}

public struct PlatformApplicationEnpoints {
    public let nextToken: String?
    public let endpoints: [Endpoint]
    
    init?(xml: XMLIndexer) {
        let responseXml = xml["ListEndpointsByPlatformApplicationResponse"]["ListEndpointsByPlatformApplicationResult"]
        let optionalEndpoints = responseXml["Endpoints"]["member"].all.map { endpointXml in
            return Endpoint(xml: endpointXml)
        }
        
        guard let endpoints = optionalEndpoints as? [Endpoint] else { return nil }
        self.endpoints = endpoints
        nextToken = responseXml["NextToken"].element?.text
    }
}

public struct Endpoint {
    public let arn: String
    public let enabled: Bool
    public let token: String
    
    init?(xml: XMLIndexer) {
        let enabledXml = xml["Attributes"]["entry"].all.filter { $0["key"].element?.text == "Enabled" }
        let tokenXml = xml["Attributes"]["entry"].all.filter { $0["key"].element?.text == "Token" }
        guard let arn = xml["EndpointArn"].element?.text,
            let enabled = enabledXml.first?["value"].element?.text,
            let token = tokenXml.first?["value"].element?.text else { return nil }
        
        self.arn = arn
        self.enabled = enabled == "true"
        self.token = token
    }
}

public struct EndpointAttributes {
    public let attributes: [String : String]
    
    init?(xml: XMLIndexer) {
        let attributesXml = xml["GetEndpointAttributesResponse"]["GetEndpointAttributesResult"]["Attributes"]
        var attributes = [String : String]()
        attributesXml["entry"].all.forEach {
            guard let key = $0["key"].element?.text,
                let value = $0["value"].element?.text else { return }
            attributes[key] = value
        }
        self.attributes = attributes
    }
}
