//
//  ViewController.swift
//  try-camera-output-as-background
//
//  Created by Rudolf Farkas on 10.01.22.
//

import UIKit

class ViewController: UIViewController {
    var boxView: UIView!

    var avCaptureHelper = AVCaptureHelper()

    override func viewDidLoad() {
        super.viewDidLoad()

        printClassAndFunc("@")

        // Add a box view
        boxView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        boxView.backgroundColor = UIColor.green
        boxView.alpha = 0.5
        view.addSubview(boxView)

        avCaptureHelper.setupAVCaptureAndDisplay(in: view)

        view.bringSubviewToFront(boxView)
    }

    override func viewDidAppear(_: Bool) {
        presentSecondViewController()
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

extension ViewController {
    func presentSecondViewController() {
        printClassAndFunc("@")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SecondViewController")

        // show(secondVC, sender: self)
        present(secondVC, animated: true)
    }
}
