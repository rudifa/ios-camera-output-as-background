//
//  ViewController.swift
//  try-camera-output-as-background
//
//  Created by Rudolf Farkas on 10.01.22.
//

import UIKit

class FirstViewController: UIViewController {
    var boxView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a box view
        boxView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        boxView.backgroundColor = UIColor.green
        boxView.alpha = 0.5
        view.addSubview(boxView)


        view.bringSubviewToFront(boxView)

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var shouldAutorotate: Bool {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight ||
            UIDevice.current.orientation == UIDeviceOrientation.unknown
        {
            return false
        } else {
            return true
        }
    }
}

extension FirstViewController {
//    func presentSecondViewController() {
//        printClassAndFunc("@")
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let secondVC = storyboard.instantiateViewController(identifier: "SecondViewController")
//
//        // show(secondVC, sender: self)
//        present(secondVC, animated: true)
//    }

    /// Target action for unwind segue.
    @IBAction func unwindToFirstViewController(_: UIStoryboardSegue) {
        printClassAndFunc("@")
    }
}
