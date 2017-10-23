import UIKit

@IBDesignable
class TextInputControl: UIView, ContentViewLoadable {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var helperLabel: UILabel!
    
    @IBInspectable var headerText: String? {
        get {
            return headerLabel.text
        }
        set {
            headerLabel.text = newValue
        }
    }
    
    @IBInspectable var placeholderText: String? {
        get {
            return textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }
    
    @IBInspectable var helperText: String? {
        get {
            return helperLabel.text
        }
        set {
            helperLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadContentViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadContentViewFromNib()
    }
    
    func contentViewDidLoad() {
        print("loaded text input control")
    }
    
}
