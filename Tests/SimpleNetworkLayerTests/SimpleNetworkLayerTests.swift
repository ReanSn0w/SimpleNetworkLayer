import XCTest
import Combine
@testable import SimpleNetworkLayer

final class SimpleNetworkLayerTests: XCTestCase {
    static let network = Network()
    
    var cancellable: AnyCancellable? = nil
    
    func testNetwork() {
        // Данный тест получает задачу из jsonplaceholder'а от Typicode.com
        //
        // Ответ от сети по запросу "https://jsonplaceholder.typicode.com/todos/1":
        // {
        //   "userId": 1,
        //   "id": 1,
        //   "title": "delectus aut autem",
        //   "completed": false
        // }
        
        cancellable = Self.network.makeRequest(request: .init(url: "https://jsonplaceholder.typicode.com/todos/1"))
            .tryMap({ (data, response) throws -> Data in
                guard response is HTTPURLResponse else {
                    throw TestError()
                }
                
                return data
            })
            .decode(type: Task.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { val in
                switch val {
                case .failure(_):
                    XCTFail()
                case .finished:
                    break
                }
            }, receiveValue: { val in
                XCTAssertEqual(val.id, 1)
                XCTAssertEqual(val.userId, 1)
                XCTAssertEqual(val.completed, false)
                XCTAssertEqual(val.title, "delectus aut autem")
            })
    }
}
