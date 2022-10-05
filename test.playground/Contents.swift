import Combine
import Foundation

extension Publisher {
    func continuation() -> AnyPublisher<Int, Error> {
        Future { promise in
            promise(.success(1))
        }
        .eraseToAnyPublisher()
    }
}

func recover() -> AnyPublisher<String, Error> {
    fatalError("RECOVER CALLED")
}

let cancellable = Future { promise in
    promise(.failure(NSError(domain: "", code: 1)))
}
.catch { _ in recover() } // Not called
.continuation() // Called
.eraseToAnyPublisher()
.sink(receiveCompletion: { _ in }, receiveValue: { print($0) })
