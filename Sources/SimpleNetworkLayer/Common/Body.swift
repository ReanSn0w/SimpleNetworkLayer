//
//  Body.swift
//  
//
//  Created by Дмитрий Папков on 23.08.2021.
//

import Foundation

public enum Body {
    case request(data: Data?, contentType: String)
    case upload(data: Data, contentType: String)
    case multipartForm(form: MultipartForm)
}
