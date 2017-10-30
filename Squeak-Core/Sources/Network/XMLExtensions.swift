import Foundation
import RxSwift
import SWXMLHash

extension XMLIndexer: Equatable {
    public static func ==(lhs: XMLIndexer, rhs: XMLIndexer) -> Bool {
        switch (lhs, rhs) {
        case (.element(let lhsElement), .element(let rhsElement)):
            return lhsElement == rhsElement
        case (.list(let lhsList), .list(let rhsList)):
            return lhsList == rhsList
        case (.stream(_), .stream(_)):
            return true // todo: reevaluate
        case (.xmlError(_), .xmlError(_)):
            return true // todo: reevaluate
        default: return false
        }
    }
}

extension XMLElement: Equatable {
    public static func ==(lhs: XMLElement, rhs: XMLElement) -> Bool {
        return lhs.name == rhs.name && lhs.allAttributes == rhs.allAttributes
    }
}

extension XMLAttribute: Equatable {
    public static func ==(lhs: XMLAttribute, rhs: XMLAttribute) -> Bool {
        return lhs.name == rhs.name && lhs.text == rhs.text
    }
}

protocol XMLNetworkProviding {
    func fulfil<ResponseType>(descriptor: XMLResourceDescriptor<ResponseType>) -> Observable<Result<XMLIndexer, NSError>>
}

extension NetworkProvider: XMLNetworkProviding {
    func fulfil<ResponseType>(descriptor: XMLResourceDescriptor<ResponseType>) -> Observable<Result<XMLIndexer, NSError>> {
        return fulfil(request: descriptor.route)
                .flatMap { (networkResult: Result<NetworkSuccess, NetworkFailure>) -> Observable<Result<XMLIndexer, NSError>> in
                    switch (networkResult) {
                    case .Success(let networkSuccess):
                        return .just(.Success(SWXMLHash.parse(networkSuccess.data)))
                    case .Failure(let networkFailure):
                        return .just(.Failure(networkFailure.error))
                    }
                }
    }
}

class XMLResourceDescriptor<ActualSuccessResponseType: Equatable>: ResourceDescriptor {
    typealias NetworkResponseType = XMLIndexer
    typealias SuccessResponseType = ActualSuccessResponseType

    let route: URLRequest
    let parse: (XMLIndexer) -> ActualSuccessResponseType?

    init(route: URLRequest, parse: @escaping (XMLIndexer) -> ActualSuccessResponseType?) {
        self.route = route
        self.parse = parse
    }
}

protocol XMLDeserialisable {
    static func deserialise(fromXml xml: XMLIndexer) -> Self?
}
