//
//  ServiceManager.swift
//  NMBaseService
//
//  Created by Remzi YILDIRIM on 10.02.2020.
//  Copyright © 2020 Turkish Technic. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import TTBaseModel
import TTBaseApp

public protocol ServiceProtocol: AnyObject {
    var authorizationHandler: (() -> ())? { get set }
    /// Used for Alamofire
    func execute<Req, Res>(path: ServicePath, method: HTTPMethod, requestObject:Req, responseType: Res.Type, options: ServiceRoles, completion: @escaping (Swift.Result<Res, BaseError>) -> Void) where Req : RequestModelBase, Res : ResponseModelBase
    /// Used for Alamofire
    func execute<Req, Res>(path: ServicePath, method: HTTPMethod, requestObject:Req, responseType: Res.Type, options: ServiceRoles, completion: @escaping (Swift.Result<ResponseBaseNewModel<Res>, BaseError>) -> Void) where Req : RequestModelBase, Res : Mappable
    
    /// Used for URL Session
    func execute<T>(with urlRequest: URLRequest, options: ServiceRoles, completion: @escaping (Swift.Result<BaseResponse<T>, BaseError>) -> Void) -> Cancelable where T: Model
}

public extension ServiceProtocol {
    func execute<Req, Res>(path: ServicePath, method: HTTPMethod = .post, requestObject:Req, responseType: Res.Type, options: ServiceRoles = [.popUpOnError], completion: @escaping (Swift.Result<Res, BaseError>) -> Void) where Req : RequestModelBase, Res : ResponseModelBase {
        return execute(path: path, method: method, requestObject: requestObject, responseType: responseType, options: options, completion: completion)
    }
    func execute<Req, Res>(path: ServicePath, method: HTTPMethod = .post, requestObject:Req, responseType: Res.Type, options: ServiceRoles = [.popUpOnError], completion: @escaping (Swift.Result<ResponseBaseNewModel<Res>, BaseError>) -> Void) where Req : RequestModelBase, Res : Mappable {
        return execute(path: path, method: method, requestObject: requestObject, responseType: responseType, options: options, completion: completion)
    }
    
    func execute<T>(with urlRequest: URLRequest, options: ServiceRoles = [.popUpOnError], completion: @escaping (Swift.Result<BaseResponse<T>, BaseError>) -> Void) -> Cancelable where T: Model {
        return execute(with: urlRequest, options: options, completion: completion)
    }
}

public struct ServiceRoles: OptionSet {
    public typealias RawValue = Int
    public let rawValue: RawValue
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    public static let debugPrint = ServiceRoles(rawValue: 1)
    public static let popUpOnError = ServiceRoles(rawValue: 2)
//    static let xxxx = ServiceRoles(rawValue: 4)
//    static let xxxx = ServiceRoles(rawValue: 8)
//    static let xxxx = ServiceRoles(rawValue: 32)
}

// MARK: - Implementation
public class ServiceManager: ServiceProtocol {
    
    public static let shared = ServiceManager()
    private let queryProvider: QueryProviderProtocol = QueryProvider.shared
    @Inject var dateFormat: DateFormat
    
    public var authorizationHandler: (() -> ())?
    
    // MARK: - Alamofire Implementation
    public func execute<Req, Res>(path: ServicePath, method: HTTPMethod = .post, requestObject:Req, responseType: Res.Type, options: ServiceRoles, completion: @escaping (Swift.Result<Res, BaseError>) -> Void) where Req : RequestModelBase, Res : ResponseModelBase {
        
        func failed(with error: BaseError) {
            showErrorIfNeeded(error, path: path, request: requestObject, options: options)
            completion(.failure(error))
        }

        let encoding: ParameterEncoding = path.isCore ? JSONEncoding.default : ((method == .get) ? URLEncoding.default : URLEncoding.httpBody)
        let headers: HTTPHeaders = QueryConstant.getHeaders(isCore: path.isCore)
        queryProvider.execute(path: path.description, method: method, encoding: encoding, headers: headers, requestObject: requestObject) { [weak self] in
            guard let `self` = self else { return }
            switch $0 {
            case .success(let value):
                do {
                    self.printResultIfNeeded(options, value)
                    
                    let resultValue = try Mapper<Res>().map(JSONObject: value)
                    /// second condition for handle response without isSucced and message e.g. roster/get
                    if resultValue.isSucceed || (!resultValue.isSucceed && resultValue.message == nil) {
                        completion(.success(resultValue))
                    } else {
                        let businessError = BusinessError(code: resultValue.statusCode, message: resultValue.message)
                        failed(with: .business(error: businessError))
                    }
                } catch let error {
                    failed(with: .deserialization(error: error, value: value))
                }
            case .failure(let error):
                failed(with: error)
            }
        }
    }
    
    public func execute<Req, Res>(path: ServicePath, method: HTTPMethod = .post, requestObject:Req, responseType: Res.Type, options: ServiceRoles, completion: @escaping (Swift.Result<ResponseBaseNewModel<Res>, BaseError>) -> Void) where Req : RequestModelBase, Res : Mappable {
        
        func failed(with error: BaseError) {
            showErrorIfNeeded(error, path: path, request: requestObject, options: options)
            completion(.failure(error))
        }
        
        let encoding: ParameterEncoding = path.isCore ? JSONEncoding.default : ((method == .get) ? URLEncoding.default : URLEncoding.httpBody)
        let headers: HTTPHeaders = QueryConstant.getHeaders(isCore: path.isCore)
        queryProvider.execute(path: path.description, method: method, encoding: encoding, headers: headers, requestObject: requestObject) { [weak self] in
            guard let `self` = self else { return }
            switch $0 {
            case .success(let value):
                do {
                    self.printResultIfNeeded(options, value)
                    
                    let resultValue = try Mapper<ResponseBaseNewModel<Res>>().map(JSONObject: value)
                    if resultValue.status.isSucceed {
                        completion(.success(resultValue))
                    } else {
                        let businessError = BusinessError(code: resultValue.status.statusCode, message: resultValue.status.message)
                        failed(with: .business(error: businessError))
                    }
                } catch let error {
                    failed(with: .deserialization(error: error, value: value))
                }
            case .failure(let error):
                failed(with: error)
            }
        }
    }
    
    // MARK: - URLSession Implementation
    public func execute<T>(with urlRequest: URLRequest, options: ServiceRoles, completion: @escaping (Swift.Result<BaseResponse<T>, BaseError>) -> Void) -> Cancelable where T : Model {
        
        func failed(with error: BaseError) {
            showErrorIfNeeded(error, request: urlRequest, options: options)
            completion(.failure(error))
        }
        
        printRequestIfNeeded(options, urlRequest)
        let task = queryProvider.execute(with: urlRequest) { [weak self] in
            guard let `self` = self else { return }
            switch $0 {
            case .success(let data):
                do {
                    self.printResultIfNeeded(options, data)
                    let decodedObject: BaseResponse<T> = try self.decode(from: data)
                    
                    if decodedObject.status.isSuccess {
                        completion(.success(decodedObject))
                    } else {
                        let businessError = BusinessError(code: decodedObject.status.code, message: decodedObject.status.message)
                        failed(with: .business(error: businessError))
                    }
                    
                } catch let error {
                    failed(with: .deserialization(error: error, value: ""))
                }
            case .failure(let error):
                failed(with: error)
            }
        }
        return Disposables.create(with: task.cancel)
    }
    
    private func decode<R>(from data: Data) throws -> R where R: Model {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(self.dateFormat.apiDateFormatter)
        return try decoder.decode(R.self, from: data)
    }
}

extension ServiceManager {
    // MARK: - Alamofire
    private func printResultIfNeeded(_ options: ServiceRoles, _ result: Any) {
        guard options.contains(.debugPrint), let data = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
        let text = String(data: data, encoding: .utf8) else { return }
        print("RESPONSE DATA:\n\(text)")
    }
    
    enum Deneme {
        case remzi
        case yildirim
    }
    
    /// Show Error and Detail for Alamofire
    private func showErrorIfNeeded(_ error: BaseError, path: ServicePath, request: RequestModelBase, options: ServiceRoles) {
        guard options.contains(.popUpOnError) else { return }
        if case .cancelled = error {
            return
        }
        if case .authorization = error {
            authorizationHandler?()
            return
        }
        
        let detailTitle: String? = QueryConstant.isBeta ? "Detail" : nil
        var errorDescription = error.errorDescription
        if path == .login, case .requestFailed(let response) = error, response.statusCode == 400 {
            errorDescription = "Username or Password incorrect. Please try again."
        }
        QueryAlert.alert(title: "ERROR", description: errorDescription, cancelButtonTitle: detailTitle, okButtonTitle: ConstantManager.ok) { (showDetail) in
            if showDetail {
                let newLine = "\n\n"
                let detail = "Path: \(path)" + newLine + "Request: \(request.dictionaryRepresentation())" + newLine + "Detail: \(error.debugDescription)"
                QueryAlert.alertSingle(title: "ERROR DETAIL", description: detail, buttonTitle: ConstantManager.ok)
            }
        }
    }
    
    // MARK: - URLSession
    private func printRequestIfNeeded(_ options: ServiceRoles, _ request: URLRequest) {
        guard options.contains(.debugPrint), let header = request.allHTTPHeaderFields, let httpMethod = request.httpMethod, let url = request.url, let data = request.httpBody, let body = String(data: data, encoding: .utf8) else { return }
        print("REQUEST:\nHeader: \(header)\nURL: \(httpMethod) - \(url)\nBODY: \(body)")
    }
    private func printResultIfNeeded(_ options: ServiceRoles, _ data: Data) {
        guard options.contains(.debugPrint), let text = String(data: data, encoding: .utf8) else { return }
        print("RESPONSE DATA:\n\(text)")
    }
    
    /// Show Error and Detail for URLRequest
    private func showErrorIfNeeded(_ error: BaseError, request: URLRequest, options: ServiceRoles) {
        guard options.contains(.popUpOnError) else { return }
        if case .cancelled = error {
            return
        }
        if case .authorization = error {
            authorizationHandler?()
            return
        }
        let detailTitle: String? = QueryConstant.isBeta ? "Detail" : nil
        let errorDescription = error.errorDescription
        
        QueryAlert.alert(title: "ERROR", description: errorDescription, cancelButtonTitle: detailTitle, okButtonTitle: ConstantManager.ok) { (showDetail) in
            if showDetail {
                var requestBody = ""
                if let data = request.httpBody, let body = String(data: data, encoding: .utf8) {
                    requestBody = body
                }
                let newLine = "\n\n"
                let detail = "Path: \(request.url!)" + newLine + "Request: \(requestBody)" + newLine + "Detail: \(error.debugDescription)"
                print(detail)
                QueryAlert.alertSingle(title: "ERROR DETAIL", description: detail, buttonTitle: ConstantManager.ok)
            }
        }
    }
}
