//
//  File.swift
//  傘2.0
//
//  Created by chang on 2019/11/21.
//  Copyright © 2019 chang. All rights reserved.
//

import UIKit
class Registerfirst:UIViewController{
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func nextButtonTrapped(_ sender: Any) {
         
        }
        
        
        
        if(userEmailTextField.text?.isEmpty)!{
            
            print("All fields are required")
            displayMessage(userMessage:"One of the required fields is missing")
            
            return
        }
        
        
        // Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(style:UIActivityIndicatorView.Style.gray)
        
        //Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        //If needed, you can prevent Activity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        //Start Activity Indicator
        myActivityIndicator.stopAnimating()
        
        view.addSubview(myActivityIndicator)
        
        //Send HTTP Request to Register user//要摳的資料url
        
        
        let postString = ["email": userEmail!,] as [String:String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong..." )
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (date: Data?, response: URLResponse? , error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            //Let's convert response sent from a server side code to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: date!, options: .mutableContainers) as? NSDictionary
                
                if let parseJson = json {
                    
                    //Now we can access value of First Name by its key
                    let accessToken = parseJson["token"] as? String
                    let userId = parseJson["id"] as? String
                    print("Access token: \(String(describing: accessToken!))")
                    
                    if (accessToken?.isEmpty)!
                    {
                        //Display an Alert dialog with a friendly error message
                     self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                        return
                    }
                    
                }else {
                    //Display an Alert dialog with a friendly error message
                     self.displayMessage(userMessage: "Could not successfully perform this request.Please try again later")
                }
            } catch{
                
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                
                //Display an Alert dialog with a friendly error message
                self.displayMessage(userMessage: "Could not successfully perform this request.Please try again later")
                print(error)
            }
            
        }
        task.resume()
        
    }
    
}
