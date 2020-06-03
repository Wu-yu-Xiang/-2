//
//  File.swift
//  傘2.0
//
//  Created by chang on 2020/6/1.
//  Copyright © 2020 chang. All rights reserved.
//

import UIKit
class imageViewController: UIViewController,UITextFieldDelegate {
    
    

    @IBOutlet weak var myImageView: UIImageView!
    
  
    @IBAction func myPageControl(_ sender: UIPageControl) {
        if sender.currentPage == 0 {
            myImageView.image = UIImage(named: "1")
        } else if sender.currentPage == 1 {
            myImageView.image = UIImage(named: "2")
        }else if sender.currentPage == 2 {
            myImageView.image = UIImage(named: "3")
        }else if sender.currentPage == 3 {
            myImageView.image = UIImage(named: "4")
        }else if sender.currentPage == 4 {
            myImageView.image = UIImage(named: "5")
        }else if sender.currentPage == 5 {
            myImageView.image = UIImage(named: "6")
        }else {
            myImageView.image = UIImage(named: "7")
        }
    }
    
    
      
      override func viewDidLoad() {
          super.viewDidLoad()

      }
      
    

}

