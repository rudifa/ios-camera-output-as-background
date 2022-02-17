//
//  ThirdViewController.swift
//  try-camera-output-as-background
//
//  Created by Rudolf Farkas on 17.02.22.
//

import UIKit

class ThirdViewController: UIViewController {
    var boxView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a box view
        boxView = UIView(frame: CGRect(x: 200, y: 0, width: 100, height: 200))
        boxView.backgroundColor = UIColor.blue
        boxView.alpha = 0.5
        view.addSubview(boxView)

        printClassAndFunc("@")
    }

    override func viewWillAppear(_: Bool) {
        AVCaptureHelper.shared.displayAVCapture(in: view)

        printClassAndFunc("@")
    }

    override func viewDidAppear(_: Bool) {

        printClassAndFunc("@")
    }

    override func viewWillDisappear(_: Bool) {
        printClassAndFunc("@")
    }

    override func viewDidDisappear(_: Bool) {
        printClassAndFunc("@")
    }
}
