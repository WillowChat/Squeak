import UIKit

class AddCoreViewController: UIViewController {

    @IBOutlet weak var addressInput: TextInputControl!
    @IBOutlet weak var userInput: TextInputControl!
    @IBOutlet weak var passwordInput: TextInputControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }

    private func setUp() {
        self.title = "Add Core"
        
        addressInput.textField.textContentType = UITextContentType.URL
        addressInput.textField.keyboardType = .URL
        addressInput.textField.returnKeyType = .next
        userInput.textField.textContentType = UITextContentType.username
        userInput.textField.keyboardType = .asciiCapable
        userInput.textField.returnKeyType = .next
        passwordInput.textField.textContentType = UITextContentType.password
        passwordInput.textField.keyboardType = .asciiCapable
        passwordInput.textField.isSecureTextEntry = true
        passwordInput.textField.returnKeyType = .done
    }

}
