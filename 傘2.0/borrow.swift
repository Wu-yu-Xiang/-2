//
//  borrow.swift
//  傘2.0
//
//  Created by chang on 2019/12/18.
//  Copyright © 2019 chang. All rights reserved.
//

import UIKit
import CoreFoundation


struct Information {
    var  sendQRimageOut: String = ""
    var  sendYNumstandpost:String = ""
}


class borrowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    var emailToborrowViewController: String = ""
    
    var buttonOut: String = ""
    var buttonIn: String = ""
    var stationScoll: String = ""
    var umbrellaScoll: String = ""
   
    
    /*var  sendQRimageOut: String = ""
    var  sendYNumstandpost:String = ""*/

    @IBAction func borrowButton(_ sender: Any) {
          print("borrow")
          buttonOut = "out"
         
          //let sendQRimageOut: String = "\(emailToborrowViewController) \(buttonOut)\(buttonIn) \(stationScoll) \(umbrellaScoll)"
          //self.performSegue(withIdentifier: "send2", sender: sendQRimageOut)
                                                
          let umstand = "\(stationScoll),\(umbrellaScoll)"
          let YN = "0"
          //let sendYNumstandpost: String = "umstand=\(umstand)&YN=\(YN)"
          //self.performSegue(withIdentifier: "send2", sender: sendYNumstandpost)
        
         //傳送產生QRcode的資料 傳送standchange
        var param:Information = Information(sendQRimageOut: "\(emailToborrowViewController) \(buttonOut)\(buttonIn) \(stationScoll) \(umbrellaScoll)", sendYNumstandpost: "umstand=\(umstand)&YN=\(YN)")
        
       
        //傳送appQRcode
             let url = URL(string:"http://kavalanwebservice.niu.edu.tw/megaliu168/WebService2.asmx/APP_QR")
             guard let requestUrl = url else{
                 fatalError()
             }
             var request = URLRequest(url:requestUrl as URL)
             //Compose a query string
             
             let postString:String = "qremail=\(emailToborrowViewController)&qrwhere=\(stationScoll)&umwhere=\(umbrellaScoll)"
             print("Send data-",postString)
             request.httpBody = postString.data(using: .utf8)
             request.httpMethod = "POST"
             let task = URLSession.shared.dataTask(with: request){
                 date, response, error in
                 guard let data = date,error == nil else{
                     print("error=\(String(describing: error))")
                     return
                 }
                 if let httpStatus = response as? HTTPURLResponse,httpStatus.statusCode != 200{
                     print("statusCode should be 200,but is\(httpStatus.statusCode)")
                     print("response=\(String(describing: response))")
                 }
                 let responseString = String(data: date!, encoding: .utf8)
                 print("response",responseString ?? "rest")
             }
             task.resume()
        
         self.performSegue(withIdentifier: "send2", sender: param)
      }
      
    
    
      @IBAction func returnButton(_ sender: Any) {
          print("return")
          buttonIn = "in"
          let umstand2 = "\(stationScoll),\(umbrellaScoll)"
          let YN2 = "1"
      //傳送產生QRcode的資料 傳送standchange
        let param1:Information = Information(sendQRimageOut:"\(emailToborrowViewController) \(buttonOut)\(buttonIn) \(stationScoll) \(umbrellaScoll)", sendYNumstandpost: "umstand=\(umstand2)&YN=\(YN2)")
        
        let url = URL(string:"http://kavalanwebservice.niu.edu.tw/megaliu168/WebService2.asmx/APP_QR")
             guard let requestUrl = url else{
                 fatalError()
             }
             var request = URLRequest(url:requestUrl as URL)
             //Compose a query string
             let postString:String = "qremail=\(emailToborrowViewController)&qrwhere=\(stationScoll)&umwhere=\(umbrellaScoll)"
             print("Send data-",postString)
             request.httpBody = postString.data(using: .utf8)
             request.httpMethod = "POST"
             let task = URLSession.shared.dataTask(with: request){
                 date, response, error in
                 guard let data = date,error == nil else{
                     print("error=\(String(describing: error))")
                     return
                 }
                 if let httpStatus = response as? HTTPURLResponse,httpStatus.statusCode != 200{
                     print("statusCode should be 200,but is\(httpStatus.statusCode)")
                     print("response=\(String(describing: response))")
                 }
                 let responseString = String(data: date!, encoding: .utf8)
                 print("response",responseString ?? "rest")
             }
             task.resume()
        
            self.performSegue(withIdentifier: "sendfk", sender: param1)

      }
      
 
    
    //地點下拉選單

    @IBAction func startSelect1(_ sender: UIButton) {
        for option in options1 {
            UIView.animate(withDuration: 0.3, animations: {
            option.isHidden =  !option.isHidden
                self.view.layoutIfNeeded()
         })
        }
    }
    @IBOutlet var  options1: [UIButton]!
    @IBAction func optionPressed1(_ sender: UIButton) {
        let location = sender.currentTitle ?? ""
        if location == "格致大樓"{
            stationScoll = "G"
        } else {
            stationScoll = "L"
        }
        print((location))
        //sendc = "\(location)"
        
    }
    
    
    
    //雨傘編號下拉選單
    @IBAction func startSelect2(_ sender: UIButton) {
        for option in option2 {
            UIView.animate(withDuration: 0.3, animations: {
            option.isHidden =  !option.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBOutlet var option2: [UIButton]!
    
    @IBAction func optionPressed2(_ sender: UIButton) {
        let umbrella = sender.currentTitle ?? ""
        print((umbrella))
        umbrellaScoll = "\(umbrella) "

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
       if segue.identifier == "send2"{
                   let secondVC = segue.destination as! BluetoothController
                       secondVC.Informationget = sender as? Information
       }else{
                   let secondVC1 = segue.destination as! BluetoothController
                       secondVC1.Informationget = sender as? Information
        }
        
        
     
        //產生警告讓他點選
        /*let destinationb = segue.destination as! BluetoothController
        destinationb.umbrellaNumber = umbrellaScoll*/
     
        
        startTimer()
    }
    
}
    


