//
//  File.swift
//  傘2.0
//
//  Created by chang on 2020/6/1.
//  Copyright © 2020 chang. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController {
    var timerSche: Timer?
    var timerMove: Timer?
    let formatter = DateFormatter()
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var sec: UILabel!
    @IBOutlet weak var mins: UILabel!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var doomsButton: UIButton!
    @IBOutlet weak var nowDate: UILabel!
    @IBOutlet weak var datePicher: UIDatePicker!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    
    
    func doomsFunc() {
        
        let dateFormatter = DateFormatter()//
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        
        let doomsTime = datePicher.date
        let doomsLabel = formatter.string(from: doomsTime)
        doomsButton.setTitle(doomsLabel, for: UIControl.State.normal)
    }
    
    
    func timeSche(repeats: Bool, runtime: TimeInterval){
        timerSche = Timer.scheduledTimer(withTimeInterval: runtime, repeats: repeats, block: { (_) in
            let nowTime = Date()
            let doomsTime = self.datePicher.date
            let interval = doomsTime.timeIntervalSince(nowTime)
            let secInt = Int(interval)%60
            let dayInt = Int(interval/86400)
            self.sec.text = ("\(secInt)")
            self.mins.text = String(Int(interval/60)%60)
            self.hour.text = String(Int(interval/3600)%24)
            self.day.text = ("\(dayInt)")
        })
    }
    
    
    func timemove(){
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timerMove = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            let nowTime = Date()
            let time = self.formatter.string(from: nowTime)
            self.nowDate.text = time
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timemove()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func funcDooms(_ sender: UIButton) {
        sendButton.isHidden = false
        datePicher.isHidden = false
        closeView.isHidden = false
        
    }
    @IBAction func funcButton(_ sender: UIButton) {
        sendButton.isHidden = true
        datePicher.isHidden = true
        closeView.isHidden = true
        timemove()
        doomsFunc()
        
    }
    @IBAction func funcDatePicher(_ sender: UIDatePicker) {
      sender.minimumDate = Date()
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        if sender.currentTitle == "開始倒數" {
            timeSche(repeats: true, runtime: 1)
            sender.setTitle("暫停倒數", for: UIControl.State.normal)
        }
        else if sender.currentTitle == "暫停倒數" {
            timerSche?.invalidate()
            sender.setTitle("開始倒數", for: UIControl.State.normal)
        }
        
    }
}

