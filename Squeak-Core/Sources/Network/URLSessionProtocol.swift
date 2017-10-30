import Foundation

public typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

public protocol URLSessionDataTaskProtocol {

    func resume()
    func cancel()

}

public protocol URLSessionProtocol {

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol

}

extension URLSession: URLSessionProtocol {

    public func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }

}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
