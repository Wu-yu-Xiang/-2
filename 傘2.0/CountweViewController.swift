//
//  File.swift
//  傘2.0
//
//  Created by chang on 2020/5/15.
//  Copyright © 2020 chang. All rights reserved.
//

import UIKit
import AudioToolbox


  var progressBar: ProgressBar!


  var days: UILabel!
  var hours: UILabel!
  var minutes: UILabel!
  var seconds: UILabel!


  var counterView: UIStackView = UIStackView()
  var stopBtn: UIButton = UIButton()
  var startBtn: UIButton = UIButton()


//MARK - Vars

var countdownTimerDidStart = false

 var countdownTimer: CountdownTimer = {
    let countdownTimer = CountdownTimer()
    return countdownTimer
}()


// Test, for dev
//let selectedSecs:Int = 120
let selectedSecs:Int = 86400 * 2

 var messageLabel: UILabel = {
    let label = UILabel(frame:CGRect.zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.light)
    label.textColor = UIColor.white
    label.textAlignment = .center
    label.text = "Done!"
    
    return label
}()

 var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
}


//MARK: - Countdown Timer Delegate

func countdownTime(time: (days: String, hours: String, minutes: String, seconds: String)) {
    days.text = time.days
    hours.text = time.hours
    minutes.text = time.minutes
    seconds.text = time.seconds
}


func countdownTimerDone() {
    
    counterView.isHidden = true
    messageLabel.isHidden = false
    seconds.text = String(selectedSecs)
    countdownTimerDidStart = false
    stopBtn.isEnabled = false
    stopBtn.alpha = 0.5
    startBtn.setTitle("START",for: .normal)
    
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    
    print("countdownTimerDone")
}

//MARK: - Actions

    func startTimer() {
    
    messageLabel.isHidden = true
    counterView.isHidden = false
    
     stopBtn.isEnabled = true
     stopBtn.alpha = 1.0
    
    if !countdownTimerDidStart{
        countdownTimer.start()
        progressBar?.start()
        countdownTimerDidStart = true
        startBtn.setTitle("PAUSE",for: .normal)
        
    }else{
        countdownTimer.pause()
        progressBar?.pause()
        countdownTimerDidStart = false
        startBtn.setTitle("RESUME",for: .normal)
    }
}







class CountweViewController: UIViewController, CountdownTimerDelegate {



    //MARK - Outlets
    
    @IBOutlet weak var progressBar: ProgressBar!
    
    
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var seconds: UILabel!
    
    
    @IBOutlet weak var counterView: UIStackView!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    
    
    //MARK - Vars
    
    var countdownTimerDidStart = false
    
    lazy var countdownTimer: CountdownTimer = {
        let countdownTimer = CountdownTimer()
        return countdownTimer
    }()
    
    
    // Test, for dev
    //let selectedSecs:Int = 120
    let selectedSecs:Int = 86400 * 2
    
    lazy var messageLabel: UILabel = {
        let label = UILabel(frame:CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.light)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Done!"
        
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countdownTimer.delegate = self
        countdownTimer.setTimer(days: 0,hours: 0, minutes: 0, seconds: selectedSecs)
        progressBar.setProgressBar(days: 0,hours: 0, minutes: 0, seconds: selectedSecs)
        stopBtn.isEnabled = false
        stopBtn.alpha = 0.5

        view.addSubview(messageLabel)
        
        var constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(constraintCenter)
        constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(constraintCenter)
        
        messageLabel.isHidden = true
        counterView.isHidden = false
    }
    
    /*override func viewDidDisappear(_ animated: Bool) {
        super.viewDidLoad()
              
              countdownTimer.delegate = self
              countdownTimer.setTimer(days: 0,hours: 0, minutes: 0, seconds: selectedSecs)
              progressBar.setProgressBar(days: 0,hours: 0, minutes: 0, seconds: selectedSecs)
              stopBtn.isEnabled = false
              stopBtn.alpha = 0.5

              view.addSubview(messageLabel)
              
              var constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
              self.view.addConstraint(constraintCenter)
              constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
              self.view.addConstraint(constraintCenter)
              
              messageLabel.isHidden = true
              counterView.isHidden = false
    }*/
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - Countdown Timer Delegate
    
    func countdownTime(time: (days: String, hours: String, minutes: String, seconds: String)) {
        days.text = time.days
        hours.text = time.hours
        minutes.text = time.minutes
        seconds.text = time.seconds
    }
    
    
    func countdownTimerDone() {
        
        counterView.isHidden = true
        messageLabel.isHidden = false
        seconds.text = String(selectedSecs)
        countdownTimerDidStart = false
        stopBtn.isEnabled = false
        stopBtn.alpha = 0.5
        startBtn.setTitle("START",for: .normal)
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        print("countdownTimerDone")
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Timer Finished", message: "Your countdown has finished.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    @IBAction func startTimer(_ sender: UIButton) {
        
        messageLabel.isHidden = true
        counterView.isHidden = false
        
        stopBtn.isEnabled = true
        stopBtn.alpha = 1.0
        
        if !countdownTimerDidStart{
            countdownTimer.start()
            progressBar.start()
            countdownTimerDidStart = true
            startBtn.setTitle("PAUSE",for: .normal)
            
        }else{
            countdownTimer.pause()
            progressBar.pause()
            countdownTimerDidStart = false
            startBtn.setTitle("RESUME",for: .normal)
        }
    }
    
    
    @IBAction func stopTimer(_ sender: UIButton) {
        countdownTimer.stop()
        progressBar.stop()
        countdownTimerDidStart = false
        stopBtn.isEnabled = false
        stopBtn.alpha = 0.5
        startBtn.setTitle("START",for: .normal)
    }
    
    
    


}
