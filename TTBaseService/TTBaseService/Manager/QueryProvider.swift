//
//  QueryProvider.swift
//  NMBaseService
//
//  Created by Remzi YILDIRIM on 10.02.2020.
//  Copyright © 2020 Turkish Technic. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import TTBaseModel
import TTBaseApp

public protocol QueryProviderProtocol: AnyObject {
    /// Alamofire
    func execute<Req: RequestModelBase>(path:String, method: HTTPMethod, encoding: ParameterEncoding, headers: HTTPHeaders, requestObject:Req, completion: @escaping (Swift.Result<Any, BaseError>) -> Void)
    /// URLSession
    func execute(with urlRequest: URLRequest, completion: @escaping (Swift.Result<Data, BaseError>) -> Void) -> URLSessionDataTask
}

public class QueryProvider: QueryProviderProtocol {
    
    public static let shared = QueryProvider()
    
    // MARK: - Alamofire Implementation
    public func execute<Req:RequestModelBase>(path:String,
                                              method: HTTPMethod,
                                              encoding: ParameterEncoding,
                                              headers: HTTPHeaders,
                                              requestObject:Req,
                                              completion: @escaping (Swift.Result<Any, BaseError>) -> Void) {
        
        debugPrint(requestObject.dictionaryRepresentation())
        Alamofire.request(path,
                          method: method,
                          parameters: requestObject.dictionaryRepresentation(),
                          encoding: encoding, headers: headers).responseJSON { (response) in

                            if let error = response.result.error {
                                if (error as NSError).code == NSURLErrorCancelled {
                                    return completion(.failure(.cancelled))
                                }
                                return completion(.failure(.connection(error: error)))
                            }

                            guard let httpResponse = response.response else {
                                return completion(.failure(.missingResponseData))
                            }
                            
                            guard 200..<300 ~= httpResponse.statusCode else {
                                if [401, 403].contains(httpResponse.statusCode) {
                                    return completion(.failure(.authorization))
                                } else {
                                    return completion(.failure(.requestFailed(response: httpResponse)))
                                }
                            }
                            
                            switch response.result {
                            case .success(let value):
                                completion(.success(value))
                            case .failure(let error):
                                completion(.failure(.connection(error: error)))
                            }
        }
    }
    
    // MARK: - URLSession Implementation
    public func execute(with urlRequest: URLRequest, completion: @escaping (Swift.Result<Data, BaseError>) -> Void) -> URLSessionDataTask {
        let dateStart = Date()
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            debugPrint("Response Time: \(Date().timeIntervalSince(dateStart))")
            if let error = error {
                if (error as NSError).code == NSURLErrorCancelled {
                    return completion(.failure(.cancelled))
                }
                completion(.failure(.connection(error: error)))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.missingResponseData))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                if [401, 403].contains(httpResponse.statusCode) {
                    completion(.failure(.authorization))
                } else {
                    completion(.failure(.requestFailed(response: httpResponse)))
                }
                return
            }
            
            completion(.success(data))
        }
        task.resume()
        return task
    }
}
