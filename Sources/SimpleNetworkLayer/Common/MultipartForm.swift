//
//  MultipartForm.swift
//  
//
//  Created by Дмитрий Папков on 23.08.2021.
//

import Foundation

public class MultipartForm {
    // Публичные (для чтения) элементы формы
    private(set) public var items: [MultipartFormItem]
    public let boundary: String
    
    // Калькулируемые значения
    private var separator: Data { "--\(self.boundary)".data(using: .utf8)! }
    private var end: Data { "--\(self.boundary)--".data(using: .utf8)! }
    
    public init(boundary: String? = nil) {
        self.items = []
        self.boundary = boundary ?? String("Asrf456BGe4h".shuffled())
    }
    
    public func appendFile(
        fieldname: String,
        fileName: String,
        fileType: String,
        content: Data
    ) {
        self.items.append(
            MultipartFormFileItem(
                fieldname: fieldname,
                filename: fileName,
                file: content,
                type: fileType)
        )
    }
    
    public func appendField(
        fieldName: String,
        fieldValue: String
    ) {
        self.items.append(
            MultipartFormFieldItem(
                fieldname: fieldName,
                value: fieldValue)
        )
    }
    
    func buildForm() -> Data {
        var form = Data()
        
        for item in items {
            form.append(separator)
            form.append(item.buildPart())
        }
        
        form.append(end)
        
        return form
    }
}

public protocol MultipartFormItem {
    var name: String { get }
    var isFile: Bool { get }
    func buildPart() -> Data
}

extension MultipartFormItem {
    var newline: Data {
        "\n".data(using: .utf8)!
    }
}

class MultipartFormFileItem: MultipartFormItem {
    let fieldname: String
    let filename: String
    let file: Data
    let type: String
    
    
    public init(
        fieldname: String,
        filename: String,
        file: Data,
        type: String
    ) {
        self.fieldname = fieldname
        self.filename = filename
        self.file = file
        self.type = type
    }
    
    // Соответствие протоколу MultipartFormItem
    
    var isFile: Bool { true }
    
    var name: String { fieldname }
    
    func buildPart() -> Data {
        var data = Data()
        
        let disp = "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\""
            .data(using: .utf8, allowLossyConversion: false)!
        let type = "Content-Type: \(type)"
            .data(using: .utf8, allowLossyConversion: false)!
        
        data.append(newline)
        data.append(disp)
        data.append(newline)
        data.append(type)
        data.append(newline)
        data.append(newline)
        data.append(file)
        data.append(newline)
        
        return data
    }
}

class MultipartFormFieldItem: MultipartFormItem {
    let fieldname: String
    let value: String
    
    public init(
        fieldname: String,
        value: String
    ) {
        self.fieldname = fieldname
        self.value = value
    }
    
    // Соответствие протоколу MultipartFormItem
    
    var isFile: Bool { true }
    
    var name: String { fieldname }
    
    func buildPart() -> Data {
        var data = Data()
        
        let disp = "Content-Disposition: form-data; name=\"\(name)\""
            .data(using: .utf8, allowLossyConversion: false)!
        let content = value
            .data(using: .utf8, allowLossyConversion: false)!
        
        data.append(newline)
        data.append(disp)
        data.append(newline)
        data.append(newline)
        data.append(content)
        data.append(newline)
        
        return data
    }
}
