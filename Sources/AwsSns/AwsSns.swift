import Foundation
import AwsSign

public class AwsSns {
    
    private let host: String
    private let session: URLSession
    private let accessKeyId: String
    private let secretAccessKey: String
    
    private let defaultParams = [ "Version" : "2010-03-31" ]
    
    public init(host: String, session: URLSession = URLSession(configuration: .default), accessKeyId: String, secretAccessKey: String) {
        self.host = host.hasSuffix("/") ? host.substring(to: host.index(host.endIndex, offsetBy: -1)) : host
        self.session = session
        self.accessKeyId = accessKeyId
        self.secretAccessKey = secretAccessKey
    }
    
    public func publish(message: String, subject: String? = nil, targetArn: String? = nil, topicArn: String? = nil, structure: String? = nil, completion: @escaping (_ success: Bool,_ error: Error?) -> Void) {
        var params = defaultParams
        params["Action"] = "Publish"
        params["Message"] = message
        params["Subject"] = subject
        params["TargetArn"] = targetArn
        params["TopicArn"] = topicArn
        params["MessageStructure"] = structure
        
        let dataTask = session.dataTask(with: request(with: params), completionHandler: { data, response, error in
            let success = (response as? HTTPURLResponse)?.statusCode ?? 999 <= 299
            completion(success, error)
        })
        dataTask.resume()
    }
    
    public func publish(message: [String : Any], subject: String = "", targetArn: String = "", topicArn: String = "", completion: @escaping (_ success: Bool,_ error: Error?) -> Void) {
        guard let messageData = try? JSONSerialization.data(withJSONObject: message, options: []),
            let jsonString = String(data: messageData, encoding: .utf8) else {
                completion(false, nil)
                return
        }
        publish(message: jsonString, subject: subject, targetArn: targetArn, topicArn: topicArn, structure: "json", completion: completion)
    }
    
    private func request(with urlParams: [String : String?]) -> URLRequest {
        var urlComponents = URLComponents(string: host)!
        urlComponents.queryItems = urlParams.filter{ $0.value != nil && $0.value?.isEmpty == false }
            .map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        try? urlRequest.sign(accessKeyId: accessKeyId, secretAccessKey: secretAccessKey)
        
        return urlRequest
    }
    
}

