//
//  TimerViewController.swift
//  Stop Watch Nurtilek
//
//  Created by Nurtilek Nurbekov on 4/5/20.
//  Copyright © 2020 neobis. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var timeScreen: UILabel!
    
    
    @IBOutlet weak var sliderOutlet: UISlider!
    
    
    @IBOutlet weak var stopOutlet: UIButton!
    
    
    @IBOutlet weak var pauseOutlet: UIButton!
    
    
    @IBOutlet weak var startOutlet: UIButton!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    pauseOutlet.isEnabled = false
    stopOutlet.isEnabled = false
    timeScreen.text = timeString(time: TimeInterval(seconds))
    sliderOutlet.isContinuous = false
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
}

var seconds = 30
var timer = Timer()


    
    @IBAction func slider(_ sender: UISlider) {
        seconds = Int(sender.value)
        timeScreen.text = timeString(time: TimeInterval(seconds))
    }
    
    
    @IBAction func startButton(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.counter), userInfo: nil, repeats: true)
        
        sliderOutlet.isHidden = true
        startOutlet.isEnabled = false
        stopOutlet.isEnabled = true
        pauseOutlet.isEnabled = true
    }
    
    
    @IBAction func pauseButton(_ sender: UIButton) {
        stop()
        sliderOutlet.setValue(Float(seconds), animated: true)
    }
    
    
    @IBAction func stopButton(_ sender: UIButton) {
        stop()
        stopOutlet.isEnabled = false
        seconds = 30
        timeScreen.text = timeString(time: TimeInterval(seconds))
        sliderOutlet.setValue(30, animated: true)
    }
    
    func stop()
        {
            timer.invalidate()
            sliderOutlet.isHidden = false
            pauseOutlet.isEnabled = false
            startOutlet.isEnabled = true
        }
        
        
        @objc func counter()
        {
            if (seconds == 0)
            {
                seconds = 0
                sliderOutlet.setValue(0, animated: true)
                
                stop()
            } else {
                seconds -= 1
            }
            timeScreen.text = timeString(time: TimeInterval(seconds))
        }
        
        func timeString(time:TimeInterval) -> String
        {
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
    }

