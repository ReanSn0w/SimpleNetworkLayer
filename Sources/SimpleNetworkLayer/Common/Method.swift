//
//  Method.swift
//  
//  Created by Дмитрий Папков on 23.08.2021.
//

import Foundation

public enum Method {
    case get
    case post
    case put
    case delete
    case other(String)
    
    var string: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .other(let method):
            return method
        }
    }
}
