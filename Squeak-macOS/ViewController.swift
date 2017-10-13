import Cocoa
import RxSwift
import Squeak_Core_macOS

class ViewController: NSViewController {
    
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

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

