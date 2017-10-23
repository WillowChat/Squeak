import UIKit
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    } 
    
    private func setUp() {
        // todo: hook to use case
        getStartedButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                // todo: wireframe
                let vc = AddCoreViewController()
                
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }

}
