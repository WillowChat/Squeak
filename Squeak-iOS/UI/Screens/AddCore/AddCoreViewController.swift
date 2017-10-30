import UIKit
import RxSwift
import RxCocoa
import Squeak_Core_iOS
import JGProgressHUD

class AddCoreViewController: UIViewController {

    @IBOutlet weak var addressInput: TextInputControl!
    @IBOutlet weak var userInput: TextInputControl!
    @IBOutlet weak var passwordInput: TextInputControl!
    @IBOutlet weak var startChattingButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let networkProvider = NetworkProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }

    private func setUp() {
        self.title = "Get Started"
        
        addressInput.textField.textContentType = UITextContentType.URL
        addressInput.textField.keyboardType = .URL
        addressInput.textField.returnKeyType = .next
        userInput.textField.keyboardType = .asciiCapable
        userInput.textField.returnKeyType = .next
        passwordInput.textField.keyboardType = .asciiCapable
        passwordInput.textField.isSecureTextEntry = true
        passwordInput.textField.returnKeyType = .done
        
        setUpUserInput()
    }
    
    private func setUpUserInput() {
        let formInput = Observable.combineLatest(addressInput.textInput, userInput.textInput, passwordInput.textInput) { (address: $0, user: $1, password: $2) }
        
        let submitFormInput = startChattingButton.rx.tap
            .withLatestFrom(formInput)
            .observeOn(MainScheduler.instance)
            .share()
        
        let hud = JGProgressHUD(style: .dark)
        let fadeAnimation = JGProgressHUDFadeZoomAnimation()
        hud.vibrancyEnabled = true
        hud.animation = fadeAnimation
        hud.square = true
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        hud.parallaxMode = .alwaysOff
        
        submitFormInput.subscribe(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            
                hud.textLabel.text = "Connecting"
                hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
                hud.show(in: self.view)
            })
            .disposed(by: disposeBag)
        
        let networkResult = submitFormInput
            .flatMap { [unowned self] formInput -> Observable<NetworkResult> in
                guard let address = formInput.address, let user = formInput.user, let password = formInput.password else {
                    print("must set core, user and password")
                    return .empty()
                }
                return self.sessionRequest(core: address, user: user, password: password)
            }
            .observeOn(MainScheduler.instance)
            .share()
            
        networkResult
            .subscribe(onNext: { response in
                print(response)
            })
            .disposed(by: disposeBag)
        
        networkResult
            .delay(0.6, scheduler: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .Success(_):
                    UIView.animate(withDuration: 0.1, animations: {
                        hud.textLabel.text = "Connected"
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    })
                case .Failure(_):
                    UIView.animate(withDuration: 0.1, animations: {
                        hud.textLabel.text = "Failed"
                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud.dismiss(afterDelay: 1.0)
                    })
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func sessionRequest(core: String, user: String, password: String) -> Observable<NetworkResult> {
        if !core.starts(with: "http") {
            print("you must specify http or https at the start of the URL")
            return .just(NetworkResult.Failure(NetworkFailure(error: NSError(domain: "", code: -1, userInfo: nil), response: nil)))
        }
        
        guard let url = URL(string: core)?.appendingPathComponent("/session") else {
            print("bad core given")
            return .just(NetworkResult.Failure(NetworkFailure(error: NSError(domain: "", code: -1, userInfo: nil), response: nil)))
        }
        
        var request = URLRequest(url: url)
        
        let json: [String: Any] = ["user": user, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        return networkProvider.fulfil(request: request)
    }

}
