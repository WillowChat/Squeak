import UIKit
import RxSwift
import Squeak_Core_iOS

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TestingSharedStuff.stuff
            .debug()
            .subscribe(onNext: { number in
                print("\(number)")
            })
            .disposed(by: disposeBag)
    }

}

