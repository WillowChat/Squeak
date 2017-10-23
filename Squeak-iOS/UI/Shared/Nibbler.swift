// Derived from Nibbler by Josh Heald and Matthew Healy

import UIKit

public protocol NibLoadable : class {
    static func fromNib(name: String, owner: AnyObject?, bundle: Bundle) -> UIView?
}

extension UIView : NibLoadable {}

extension NibLoadable where Self : UIView {
    /**
     Loads a view from a nib.
     - Parameters:
     - name: The name of the nib to load. Defaults to the name of the class you're calling this method on.
     - owner: The object to set as the File's Owner of the nib. Optional.
     - bundle: The bundle containing the nib. Defaults to the bundle returned by `NSBundle:forClass:` for the class you're calling this method on.
     N.B. if you pass in a bundle, ensure it contains the nib both at runtime and at in Interface Builder, or the nib won't load for IBDesignable purposes.
     - Returns: A UIView loaded from a nib, with outlets connected to the owning class.
     */
    public static func fromNib(name: String = String(describing: Self.self), owner: AnyObject? = nil, bundle: Bundle = Bundle(for: Self.self)) -> UIView? {
        let nib = UINib(nibName: name, bundle: bundle)
        let views = nib.instantiate(withOwner: owner, options: nil)
        return views.last as? UIView
    }
}

/**
 A `UIView` subclass implementing `ContentViewLoadable` can load its content view from a nib
 
 To load the content view, call `loadContentViewFromNib()` in your `init(frame:)` and `init(coder:)` methods. Both are required, particularly in order for `IBDesignable` views and `IBInspectable` properties to function correctly in Interface Builder.
 
 Your nib should be set up as follows:
 - Its name should exactly match the name of the class which will load it.
 - It should contain one top level view.
 - The top level view should not have a Custom Class set.
 - The nib's File's Owner property should be set to the class which will load it.
 - Outlets and actions should be set on the File's Owner.
 */
public protocol ContentViewLoadable : class {
    /**
     Called after the view has been loaded from the nib, had its outlets set, and added to the view heirarchy. Optional, the default implementation does nothing.
     */
    func contentViewDidLoad()
}

extension ContentViewLoadable where Self : UIView {
    /**
     Loads the content view for this class, sets its outlets and actions, and adds it to the view heirarchy with the constraints of this object.
     
     `contentViewWasLoaded()` is called when this is finished, and should be used to customise the view if required.
     */
    public func loadContentViewFromNib() {
        if let view = Self.fromNib(owner: self) {
            view.frame = bounds
            view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            addSubview(view)
            contentViewDidLoad()
        }
    }
    
    public func contentViewDidLoad() {}
}
