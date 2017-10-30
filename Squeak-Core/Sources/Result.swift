import Foundation

public enum Result<Value : Equatable, ErrorType : Error & Equatable> : Equatable {
    case Success(Value)
    case Failure(ErrorType)

    public static func ==(lhs: Result<Value, ErrorType>, rhs: Result<Value, ErrorType>) -> Bool {
        switch (lhs, rhs) {
        case let(.Success(l), .Success(r)): return l == r
        case let(.Failure(l), .Failure(r)): return l == r
        default: return false
        }
    }
}
