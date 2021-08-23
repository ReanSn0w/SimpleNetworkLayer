//
//  NLError.swift
//  
//
//  Created by Дмитрий Папков on 23.08.2021.
//

import Foundation

public enum NLError: Error {
    case urlComponentsError
    case buildURLFromComponentsError
    case catchResponseError
    case requestBuildError
}

extension NLError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlComponentsError:
            return "Не удалось создать класс URLComponens на основе указанного URL"
        case .buildURLFromComponentsError:
            return "Не удалось развернуть поле url из URLComponets"
        case .catchResponseError:
            return "Из запроса не вернулся URLResponse, а также не была передана ошибка."
        case .requestBuildError:
            return "Ошибка в построении запроса к серверу"
        }
    }
    
    public var helpAnchor: String? {
        switch self {
        case .urlComponentsError:
            return "В указанном в качестве строки url в классе Request присутствует ошибка, которя мешает инициализировать класс URLComopnents из пакета Foundation. Следует проверить правильность указанного url."
        case .buildURLFromComponentsError:
            return "Не удалось развернуть опциональное проперти url из класса URLComponts. Класс был создан на основе url и query параметров переданных в классе Request"
        case .catchResponseError:
            return "Исключительная ситуация, когда в замыкании dataTask или uploadTask одновременно в значении nil вернулиь URLResponse и Error"
        case .requestBuildError:
            return "На данном этапе запрос еще не был отправлен на сервер. В качестве быстрого решения следует изменить параметры запроса, а так же описать issue в репозиторий проекта для исправления ошибки"
        }
    }
}
