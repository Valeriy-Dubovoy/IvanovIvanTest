//
//  WebAPI.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 16.04.2022.
//

import Foundation

class WebAPI {
    private static let TRIM_LEN: Int = 10000

    static let shared = WebAPI()
    
    static let baseURL = "https://onlym.ru/api_test/test.json"
    
    private var timeout = TimeInterval( 60 )
    private var session: URLSession = URLSession.shared

    // MARK: -  Request creating
    
    private func newRequest(urlString: String,
                            method: HTTPMethod = .Get,
                            headers: [String: String]? = nil,
                            getParams: [String: Any]? = nil,
                            postParams: [String: Any]? = nil) -> URLRequest?
    {
        guard var urlComps = URLComponents(string: urlString) else {
            return nil
        }
        
        if let getParams = getParams {
            if (!getParams.isEmpty) {
                urlComps.queryItems = getParams.map({ key, value in
                    URLQueryItem(name: key, value: "\(value)")
                })
            }
        }
        
        var httpBody: Data? = nil
        
        if let postParams = postParams {
            if (!postParams.isEmpty) {
                switch method {
                case .PostFormData:
                    httpBody = paramsToFormData(params: postParams, percentEncode: true)
                    break
                    
                case .PostJson:
                    httpBody = paramsToJsonData(params: postParams)
                    break
                    
                case .PostMultipartFormData:
                    // TODO: create multipart hhtp body
                    break
                    
                default:
                    break
                }
            }
        }

        guard let url = urlComps.url else {
            return nil
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout )
        request.httpMethod = method.description
        
        if let body = httpBody {
            request.httpBody = body
        }
        
        // Custom headers
        if let headers = headers {
            headers.forEach { (key: String, value: String) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let localeCode = Locale.current.languageCode {
            request.addValue(localeCode, forHTTPHeaderField: "Locale")
        }
        
        return request
    }
    
    private func paramsToFormData(params: [String : Any], percentEncode: Bool) -> Data? {
        var data = [String]()
        for(key, value) in params
        {
            let encodedValue: String
            if (percentEncode) {
                var cs = CharacterSet.urlQueryAllowed
                cs.remove("+")
                
                encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: cs)!
            }
            else {
                encodedValue = "\(value)"
            }
            
            data.append(key + "=\(encodedValue)")
        }
        
        return data.map { String($0) }.joined(separator: "&").data(using: .utf8)
    }
    
    private func paramsToJsonData(params: [String : Any]) -> Data? {
        let data = try? JSONSerialization.data(withJSONObject: params)
        return data
    }
    
    private func paramsToJsonString(params: [String : Any]) -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: params) {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }

    // MARK: Request sending
    
    func HTTPRequest(urlString: String,
                                           method: HTTPMethod = .Get,
                                           headers: [String: String]? = nil,
                                           getParams: [String: Any]? = nil,
                                           postParams: [String: Any]? = nil,
                                           needValidateSession: Bool = true,
                                           completion: @escaping (ResponseData?, Error?) -> Void)
    {
        guard let request = newRequest(urlString: urlString,
                                       method: method,
                                       headers: headers,
                                       getParams: getParams,
                                       postParams: postParams) else {
            completion(nil, NSError(domain: "HTTP", code: 999, userInfo: [NSLocalizedDescriptionKey : "Fail request creation"] ) )
            return
        }
    
        logRequest(request)
        
        sendRequest(request: request, completion: completion)
    }

    private func sendRequest(request: URLRequest,
                                           completion: @escaping (ResponseData?, Error?) -> Void)
    {
        let dataTask = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            let handledResponse: (response: commonResponse?, error: Error?)?
                = self?.handleResponse(methodName: request.url?.absoluteString ?? "",
                                       data: data,
                                       response: response,
                                       error: error
                )
            
            if let data = data, let response = handledResponse?.response {
                completion(
                    ResponseData(response: response, jsonData: data),
                    handledResponse?.error
                )
            }
            else {
                completion(nil,handledResponse?.error)
            }
            
        })
        
        dataTask.resume()
    }
    
    //MARK: - Responce
    
    private func handleResponse(methodName: String,
                                               data: Data?,
                                               response: URLResponse?, error: Error?) -> (commonResponse?, Error?)
    {
        if let response = response {
            logResponse(response, data: data)
        }
        
        if let error = error {
            logError(error as NSError)
            return (nil, error)
        }
        
        guard let data = data else {
            return (nil, nil)
        }
        
        do {
            let responseModel = try JSONDecoder().decode(commonResponse.self, from: data)
            
            return (responseModel, nil)
        }
        catch let error {
            return (nil, error)
        }
    }


    //MARK: - Logging
    
    private func logHeaders(_ headers: [String: AnyObject]) -> String {
        let string = headers.reduce(String()) { str, header in
            let string = "  \(header.0) : \(header.1)"
            return str + "\n" + string
        }
        
        let logString = "[\(string)\n]"
        return logString
    }
    
    private func trimTextOverflow(_ string: String, length: Int) -> String {
        guard string.count > length else {
            return string
        }
        
        let index = string.index(string.startIndex, offsetBy: length)
        return string[..<index] + "…"
    }
    
    private func logError(_ error: NSError) {
        var logString = ""
        logString += "Error: \n\(error.localizedDescription)\n"
        
        if let reason = error.localizedFailureReason {
            logString += "Reason: \(reason)\n"
        }
            
        if let suggestion = error.localizedRecoverySuggestion {
            logString += "Suggestion: \(suggestion)\n"
        }
        
        logString += "\n\n*************************\n\n"
        print(logString)
    }
        
    private func logRequest(_ request: URLRequest) {
        var logString = ""
        if let url = request.url?.absoluteString {
            logString += "Request: \n  \(request.httpMethod!) \(url)\n"
        }
            
        if let headers = request.allHTTPHeaderFields {
            logString += "Header:\n"
            logString += logHeaders(headers as [String : AnyObject]) + "\n"
        }
        
        #if DEBUG
        if let data = request.httpBody,
            let bodyString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                
            logString += "Body:\n"
            logString += trimTextOverflow(bodyString as String, length: WebAPI.TRIM_LEN)
        }
            
        if let dataStream = request.httpBodyStream {
            let bufferSize = 1024
            var buffer = [UInt8](repeating: 0, count: bufferSize)
                
            let data = NSMutableData()
            dataStream.open()
            while dataStream.hasBytesAvailable {
                let bytesRead = dataStream.read(&buffer, maxLength: bufferSize)
                data.append(buffer, length: bytesRead)
            }
                
            if let bodyString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) {
                logString += "Body:\n"
                logString += trimTextOverflow(bodyString as String, length: WebAPI.TRIM_LEN)
            }
        }
        #endif
            
        logString += "\n\n*************************\n\n"
        print(logString)
    }
        
    private func logResponse(_ response: URLResponse, data: Data? = nil) {
        var logString = ""
        if let url = response.url?.absoluteString {
            logString += "Response: \n  \(url)\n"
        }
            
        if let httpResponse = response as? HTTPURLResponse {
            let localisedStatus = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode).capitalized
            logString += "Status: \n  \(httpResponse.statusCode) - \(localisedStatus)\n"
        }
            
        if let headers = (response as? HTTPURLResponse)?.allHeaderFields as? [String: AnyObject] {
            logString += "Header: \n"
            logString += self.logHeaders(headers) + "\n"
        }
            
        #if DEBUG
        guard let data = data else { return }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let pretty = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                
            if let string = NSString(data: pretty, encoding: String.Encoding.utf8.rawValue) {
                logString += "\nJSON: \n\(string)"
            }
        }
        catch {
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                logString += "\nData: \n\(string)"
            }
        }
        #endif
            
        logString += "\n\n*************************\n\n"
        print(logString)
    }
    
    
    // MARK: - Getting site data
    func getSiteData(completion: @escaping (ResponseData?, Error?) -> Void) {
        let urlString = WebAPI.baseURL
        HTTPRequest(urlString: urlString, completion: completion)

    }
}
