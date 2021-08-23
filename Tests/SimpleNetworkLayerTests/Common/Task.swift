//
//  Task.swift
//
//  Структура для проведения теста
//
//  Created by Дмитрий Папков on 24.08.2021.
//

import Foundation

class Task: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
