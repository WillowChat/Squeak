import Foundation
import RxSwift

public struct NetworkSuccess : Equatable {
    public let data: Data
    public let response: HTTPURLResponse?
    
    public init(data: Data, response: HTTPURLResponse?) {
        self.data = data
        self.response = response
    }

    public static func ==(lhs: NetworkSuccess, rhs: NetworkSuccess) -> Bool {
        return lhs.data == rhs.data && lhs.response == rhs.response
    }
}

public struct NetworkFailure: Error, Equatable {
    public let error: NSError
    public let response: HTTPURLResponse?
    
    public init(error: NSError, response: HTTPURLResponse?) {
        self.error = error
        self.response = response
    }

    public static func ==(lhs: NetworkFailure, rhs: NetworkFailure) -> Bool {
        return lhs.error == rhs.error && lhs.response == rhs.response
    }
}

public typealias NetworkResult = Result<NetworkSuccess, NetworkFailure>

public class NetworkProvider: NetworkProviding {

    private let session: URLSessionProtocol
    
    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    public func fulfil(request: URLRequest) -> Observable<NetworkResult> {
        return Observable.create { observer in
            let dataTask = self.session.dataTask(with: request) { (data, response, error) in
                let httpResponse = response as? HTTPURLResponse

                // TODO: Pass through networking errors via userinfo?
                if let error = error {
                    observer.onNext(.Failure(NetworkFailure(error: error as NSError, response: httpResponse)))
                    return
                } else {
                    guard let data = data else {
                        observer.onNext(.Failure(NetworkFailure(error: NSError(domain: "", code: -1), response: httpResponse)))
                        return
                    }

                    observer.onNext(.Success(NetworkSuccess(data: data, response: httpResponse)))
                    observer.onCompleted()
                }

            }
            
            dataTask.resume()
            
            return Disposables.create(with: {
                dataTask.cancel()
            })
        }
    }

}
