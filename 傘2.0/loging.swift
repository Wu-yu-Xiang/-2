//
//  loging.swift
//  傘2.0
//
//  Created by chang on 2019/12/18.
//  Copyright © 2019 chang. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    //點空白處收起鍵盤
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
       //
    
    @IBAction func canncelButtonTapped(_ sender: Any) {
        print("Canncel button tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signinButtonTapped(_ sender: Any) {
        print("Sign up button tapped")
        
        if (emailTextField.text?.isEmpty)! == true ||
            (passwordTextField.text?.isEmpty)! == true ||
            (repeatPasswordTextField.text?.isEmpty)! == true
        {
            let controllerA = UIAlertController(title: "Alert", message: "All fields are quired to fill in", preferredStyle: .alert)
            let okAction1 = UIAlertAction(title: "OK", style: .default, handler: nil)
            controllerA.addAction(okAction1)
            present(controllerA,animated: true,completion: nil)

            return
        }
        
        if ((passwordTextField.text?.elementsEqual(repeatPasswordTextField.text!))! != true){
            
            //Display alert message and return
            let controllerB = UIAlertController(title: "Alert", message: "Please make sure that passwords match", preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: "ok", style: .default, handler: nil)
            controllerB.addAction(okAction2)
            present(controllerB,animated: true,completion: nil)
            
            
            return
        }
        
        /*// Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(style:UIActivityIndicatorView.Style.gray)
        
        //Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        //If needed, you can prevent Activity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        //Start Activity Indicator
        myActivityIndicator.stopAnimating()
        
        view.addSubview(myActivityIndicator)
        
        //Send HTTP Request to Register user*/
        
        let url = URL(string:"http://kavalanwebservice.niu.edu.tw/megaliu168/WebService2.asmx/App_Number")
        guard let requestUrl = url else{
            fatalError()
        }
        var request = URLRequest(url:requestUrl as URL)
        //Compose a query string
        let  emailop:String = emailTextField.text!
        let  passwordop:String = passwordTextField.text!
        let postString:String = "email=\(emailop)&password=\(passwordop)"
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
        
        
        func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
        {
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
        
        self.performSegue(withIdentifier: "send0", sender: nil)
        emailTextField.text = ""
        passwordTextField.text = ""
       //self.performSegue(withIdentifier: "user", sender: nil)
               
    }
       override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "send0"{
            let secondVC = segue.destination as! MapController
                secondVC.email = emailTextField.text!
        } 
    }
    
   
    
}
