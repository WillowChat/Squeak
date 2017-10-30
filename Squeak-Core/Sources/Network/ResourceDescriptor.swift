import Foundation

protocol ResourceDescriptor {
    associatedtype NetworkResponseType: Equatable
    associatedtype SuccessResponseType: Equatable

    var route: URLRequest { get }
    var parse: (NetworkResponseType) -> SuccessResponseType? { get }
}
