import Foundation
import RxSwift

// a session is a user, on a particular core, with a particular auth token
struct Session {
    let user: String
    let token: String
    let core: URL
}

class SessionUseCase {

    public let session = BehaviorSubject<Session?>(value: nil)

    // what does the API look like?
    // make a session request - thing using this use case should be in charge of switching an authenticated nav stack on
    //  multiple authenticated nav stacks? switching between cores? probably later on

    public func startNewSession(core: URL, user: String, password: String) {
    }

    // borrow the networking stack from EDCH
}
