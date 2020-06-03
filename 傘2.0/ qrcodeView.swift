//
//  User.swift
//  傘2.0
//
//  Created by chang on 2019/11/1.
//  Copyright © 2019 chang. All rights reserved.
//

import UIKit



protocol sendtocount: class {
    func receiveData(data:String)
}


class qrcodeViewController:UIViewController {

    var name:String!
    
    ///var receivedText: String = ""
    //var direction: String = ""

    var sendQRimageOutDirectionFinish: String = ""
    
    //var finisha:String = ""
    
    @IBOutlet weak var myTextField: UITextField!
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Button2.isEnabled = false
        
       /// myTextField.text = receivedText + direction
        myTextField.text = sendQRimageOutDirectionFinish
        
    }
    
    
    @IBAction func button(_sender:Any)
    {
        if let myString = myTextField.text
        {
            let data = myString.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "InputMessage")
            
            let ciImage = filter?.outputImage
            
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let transformImage = ciImage?.transformed(by: transform)
            
            
            let image = UIImage(ciImage: transformImage!)
            myImageView.image = image
            
            Button2.isEnabled = true
            
            
            }
            

        
        
    }
    @IBAction func buttonScreenShot(_sender: Any){
        
        screenShotMethod()
        
    }
    func screenShotMethod(){
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
        
    }
    func startTimer(_ sender: UIButton){
        
    }
    
   
  }


