//
//  Network.swift
//  
//
//  Created by Дмитрий Папков on 23.08.2021.
//

import Foundation
import Combine

public class Network {
    var delegate: SharedNetworkDataDelegate?
    
    public init(
        delegate: SharedNetworkDataDelegate? = nil
    ) {
        self.delegate = delegate
    }
    
    public func makeRequest(request: Request) -> Future<(Data, URLResponse), Error> {
        switch request.requestType {
        case .request:
            return makeDefaultRequest(request: request)
        case .upload:
            return makeUploadRequest(request: request)
        }
    }
    
    private func makeDefaultRequest(request: Request) -> Future<(Data, URLResponse), Error> {
        return .init { completion in
            do {
                let request = try self.prepareRequest(request: request)
                
                URLSession.shared.dataTask(with: request) { (data, resp, error) in
                    guard let resp = resp else {
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.failure(NLError.catchResponseError))
                        }
                        
                        return
                    }
                    
                    completion(.success((data ?? Data(), resp)))
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func makeUploadRequest(request: Request) -> Future<(Data, URLResponse), Error> {
        return .init { completion in
            do {
                let urlRequest = try self.prepareRequest(request: request)
                
                URLSession.shared.uploadTask(with: urlRequest, from: request.clearData) { (data, resp, error) in
                    guard let resp = resp else {
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.failure(NLError.catchResponseError))
                        }
                        
                        return
                    }
                    
                    completion(.success((data ?? Data(), resp)))
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Построение и дополнение
    ///
    /// на данном этапе происходит построение запроса на основе функции buildReqeust
    /// и дополнение данными полеченными от делегата SharedNetworkDataDelegate в случае если он
    /// был указан при построении класса Network
    ///
    /// Так же в данной функции происходит вывод информации в консоль в случае если билд отмечен как DEBUG
    private func prepareRequest(request: Request) throws -> URLRequest {
        var request = try buildRequest(request: request)
        
        if let delegate = delegate {
            for header in delegate.sharedHeaders {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        return request
    }
    
    /// Чистое построение запроса.
    ///
    /// В данном методе запрос строится лишь на основе данных полученных из класса Request
    private func buildRequest(request: Request) throws -> URLRequest {
        guard var components = URLComponents(string: request.url) else {
            throw NLError.urlComponentsError
        }
        
        components.queryItems = request.params
        
        guard let url = components.url else {
            throw NLError.buildURLFromComponentsError
        }
        
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: request.cachePolicy,
            timeoutInterval: request.timeoutInterval)
        
        /// дополнение запроса параметрами из класса Request
        urlRequest.httpMethod = request.method.string
        
        for (name, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: name)
        }
        
        switch request.body {
        case .multipartForm(form: let form):
            urlRequest.addValue(
                "multipart/form-data;boundary=\"\(form.boundary)\"",
                forHTTPHeaderField: "Content-Type")
        case .request(data: let data, contentType: let contentType):
            urlRequest.httpBody = data
            urlRequest.addValue(
                contentType,
                forHTTPHeaderField: "Content-Type")
        case .upload(data: _, contentType: let contentType):
            urlRequest.addValue(
                contentType,
                forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}

public protocol SharedNetworkDataDelegate {
    var sharedHeaders: [String: String] { get }
}
