//
//  SecondViewController.swift
//  傘2.0
//
//  Created by chang on 2019/10/31.
//  Copyright © 2019 chang. All rights reserved.
//

import UIKit
class FirstViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var uitextfield: UITextField!
    
   
    
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
      }
      
      override func viewDidLoad() {
          super.viewDidLoad()
          
          //讓鍵盤下拉
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
          
          
      }
      
      @objc func dismissKeyBoard(){
          self.view.endEditing(true)
      }

}

