//
//  Request.swift
//  
//
//  Created by Дмитрий Папков on 23.08.2021.
//

import Foundation

public class Request {
    let url: String
    let method: Method
    let headers: [String: String]
    let params: [URLQueryItem]
    let body: Body
    let cachePolicy: URLRequest.CachePolicy
    let timeoutInterval: TimeInterval
    
    public init(
        url: String,
        method: Method = .get,
        headers: [String: String] = [:],
        params: [URLQueryItem] = [],
        body: Body = .request(data: nil, contentType: "application/json"),
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 30
    ) {
        self.url = url
        self.method = method
        self.headers = headers
        self.params = params
        self.body = body
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
    }
    
    var requestType: RequestType {
        switch self.body {
        case .request(data: _, contentType: _):
            return .request
        default:
            return .upload
        }
    }
    
    var clearData: Data {
        switch body {
        case .multipartForm(form: let form):
            return form.buildForm()
        case .upload(data: let data, contentType: _):
            return data
        default:
            return Data()
        }
    }
    
    enum RequestType {
        case upload
        case request
    }
}
