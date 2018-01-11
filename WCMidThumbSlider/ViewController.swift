//
//  ViewController.swift
//  WCMidThumbSlider
//
//  Created by wanchenxie on 03/01/2018.
//  Copyright © 2018 wanchen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WCMidThumbSliderDelegate {

    @IBOutlet var label: UILabel!
    @IBOutlet var midThumbSlider: WCMidThumbSlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        midThumbSlider.minValue = 0
        midThumbSlider.maxValue = 200
        midThumbSlider.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testSliderValueChanged(_ sender: UISlider) {
        
        midThumbSlider.value = sender.value
        
        label.text = "\(Int(sender.value))"

    }
    
    // MARK: WCMidThumbSliderDelegate
    func sliderTouchedDown(sender: WCMidThumbSlider) {
        
    }
    func sliderTouchedUp(sender: WCMidThumbSlider) {
        
    }
    func sliderValueChanged(sender: WCMidThumbSlider) {
         print("sender value \(sender.value)")
        
        label.text = "\(Int(sender.value))"
    }
}

