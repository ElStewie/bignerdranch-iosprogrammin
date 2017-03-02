//
//  ViewController.swift
//  Buggy
//
//  Created by Hisham Abraham on 2/24/17.
//  Copyright © 2017 Hisham Abraham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        print("Method: \(#function) in file: \(#file) line: \(#line) called.")

        badMethod()


 
    }
    
    func badMethod() {
        let array = NSMutableArray()
        
        for i in 0..<10 {
            array.insert( i, at: i)
        } // Go one step too far emptying the array (notice the range change): 
        for _ in 0...10 {
            array.remove( at: 0)
        }
    }
  

}

