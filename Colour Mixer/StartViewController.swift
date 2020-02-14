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
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ColorMixerViewController
        destinationVC.color = view.backgroundColor
    
    }
    

}
