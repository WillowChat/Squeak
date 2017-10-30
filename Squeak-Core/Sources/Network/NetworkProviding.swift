import Foundation
import RxSwift

public protocol NetworkProviding {
   func fulfil(request: URLRequest) -> Observable<NetworkResult>
}
