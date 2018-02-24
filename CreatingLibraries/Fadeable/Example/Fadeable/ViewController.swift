//
//  ViewController.swift
//  Fadeable
//
//  Created by vijayvepa on 02/24/2018.
//  Copyright (c) 2018 vijayvepa. All rights reserved.
//

import UIKit
import Fadeable

class ViewController: UIViewController {

    @IBOutlet weak var box : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fadeToggleTapped(sender: UIButton){
        if(box.alpha == 0){
            box.fadeIn()
        }else{
            box.fadeOut()
        }
    }
}

