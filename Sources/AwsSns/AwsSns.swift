import Foundation
import AwsSign

public class AwsSns {
    private let host: String
    private let session: URLSession
    private let accessKeyId: String
    private let secretAccessKey: String
    
    private let defaultParams = [ "Version" : "2010-03-31" ]
    
    /// Initializes a new AwsSns client, using the specified host, session, and access credentials.
    ///
    /// - Parameters:
    ///   - host: The host for the SNS, e.g `https://sns.us-west-2.amazonaws.com/`
    ///   - session: Optional parameter, specifying a `URLSession` to be used for all SNS related requests. If not provided, `URLSession(configuration: .default)` will be used.
    ///   - accessKeyId: The access key for using the SNS.
    ///   - secretAccessKey: The secret access key for using the SNS.
    public init(host: String, session: URLSession = URLSession(configuration: .default), accessKeyId: String, secretAccessKey: String) {
        self.host = host.hasSuffix("/") ? host.substring(to: host.index(host.endIndex, offsetBy: -1)) : host
        self.session = session
        self.accessKeyId = accessKeyId
        self.secretAccessKey = secretAccessKey
    }
    
    
    /// Method used for publishing `String` messages.
    ///
    /// - Parameters:
    ///   - message: The message in string format.
    ///   - subject: The subject to be published.
    ///   - targetArn: The target ARN.
    ///   - topicArn: The topic ARN.
    ///   - structure: String specifying message structure.
    ///   - completion: Completion handler, providing a `Bool` parameter specifying whether the publish operation was successful, and an optional error in case the operation failed.
    public func publish(message: String, subject: String? = nil, targetArn: String? = nil, topicArn: String? = nil, structure: String? = nil, completion: @escaping (Bool, Error?) -> Void) {
        var params = defaultParams
        params["Action"] = "Publish"
        params["Message"] = message
        params["Subject"] = subject
        params["TargetArn"] = targetArn
        params["TopicArn"] = topicArn
        params["MessageStructure"] = structure
        
        let request: URLRequest
        do {
            request = try self.request(with: params)
        } catch {
            completion(false, error)
            return
        }
        
        let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            let success = (response as? HTTPURLResponse)?.statusCode ?? 999 <= 299
            completion(success, error)
        })
        dataTask.resume()
    }
    
    /// Method used for publishing messages in dictionary (JSON) format.
    ///
    /// - Parameters:
    ///   - message: The message in in dictionary (JSON) format.
    ///   - subject: The subject to be published.
    ///   - targetArn: The target ARN.
    ///   - topicArn: The topic ARN.
    ///   - completion: Completion handler, providing a `Bool` parameter specifying whether the publish operation was successful, and an optional error in case the operation failed.
    public func publish(message: [String : Any], subject: String = "", targetArn: String = "", topicArn: String = "", completion: @escaping (Bool, Error?) -> Void) {
        let messageData: Data
        do {
            messageData = try JSONSerialization.data(withJSONObject: message, options: [])
        } catch {
            completion(false, error)
            return
        }
        guard let jsonString = String(data: messageData, encoding: .utf8) else {
            completion(false, AwsSnsError.generalError(reason: "Initializing string from message data failed."))
            return
        }
        
        publish(message: jsonString, subject: subject, targetArn: targetArn, topicArn: topicArn, structure: "json", completion: completion)
    }
    
    private func request(with urlParams: [String : String?]) throws -> URLRequest {
        var urlComponents = URLComponents(string: host)!
        urlComponents.queryItems = urlParams.filter { $0.value != nil && $0.value?.isEmpty == false }
            .map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        try urlRequest.sign(accessKeyId: accessKeyId, secretAccessKey: secretAccessKey)
        
        return urlRequest
    }
}

public enum AwsSnsError: Error {
    case generalError(reason: String?)
}

extension AwsSnsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .generalError(let reason):
            return "AWS SNS SDK error " + (reason ?? "No failure reason available")
        }
    }
    public var localizedDescription: String {
        return errorDescription!
    }
}