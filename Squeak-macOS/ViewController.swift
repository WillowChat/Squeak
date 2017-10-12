//
//  ViewController.swift
//  Squeak-macOS
//
//  Created by Sky Welch on 12/10/2017.
//

import Cocoa
import Squeak_Core

class ViewController: NSViewController {
    
    let testSharedStuff = TestSharedStuff.sharedThing

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

