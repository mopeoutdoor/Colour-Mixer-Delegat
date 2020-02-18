//
//  StartViewController.swift
//  Colour Mixer
//
//  Created by Irina Kopchenova on 14.02.2020.
//  Copyright © 2020 Mikhail Scherbina. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToStart(unwindSegue: UIStoryboardSegue) {
    
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ColorMixerViewController
        destinationVC.color = view.backgroundColor
        destinationVC.delegate = self
    }

}

extension StartViewController: ColorMixerViewControllerDelegate {
    func updateColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) {
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
