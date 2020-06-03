//
//  Map.swift
//  傘2.0
//
//  Created by chang on 2019/10/31.
//  Copyright © 2019 chang. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

import CoreBluetooth



class MapController: UIViewController, CLLocationManagerDelegate{
    


    var email : String = ""
    
    @IBOutlet weak var user: UITextField!
    
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager?
    var myLocationMgr :CLLocationManager!
    
    //放目標位子的經緯度
    var xPosition:Double?
    var yPosition:Double?
    //這個常數用來管理手機位子
    var nowUserLocation :CLLocationCoordinate2D!
    
    var lat:Double? = 1
    var long:Double? = 1
    
    
    
    @IBOutlet weak var text: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //------------------顯示圖書管位置---------------------
        let L = MKPointAnnotation()//宣告一個大頭針
        L.coordinate = CLLocationCoordinate2D(latitude: xPosition ?? 24.747329, longitude:yPosition ?? 121.747301)//設定大頭針經緯度
        L.title = "圖書館" //目標名字
        map.addAnnotation(L)//把大頭針加入地圖
        map.setCenter(L.coordinate, animated: false)//設定大頭針在地圖中間
        //-----------------顯示格致位置-----------------------
        let G = MKPointAnnotation()//宣告一個大頭針
        G.coordinate = CLLocationCoordinate2D(latitude: xPosition ?? 24.7453, longitude:yPosition ?? 121.7454)//設定大頭針經緯度
        G.title = "格致大樓" //目標名字
        map.addAnnotation(G)//把大頭針加入地圖
        map.setCenter(G.coordinate, animated: false)//設定大頭針在地圖中間
        
        
        
       /* //let me = locations[0] as! locationManager
        let nowme = CLLocationCoordinate2D(latitude: L.coordinate.latitude, longitude: L.coordinate.longitude)
        let _span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        self.map.setRegion(MKCoordinateRegion(center: nowme, span: _span),animated: true)*/
        
       /* //-------------使用者座標
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()//詢問是否給app定位功能
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.activityType = .automotiveNavigation
        locationManager?.startUpdatingLocation()//開始接收目前位置資訊
        //---------------大頭針---------------
        //詢問使用著位置，在目的位子加入圖釘
        let annotation = MKPointAnnotation()//宣告一個大頭針
        annotation.coordinate = CLLocationCoordinate2D(latitude: xPosition ?? 24.747329, longitude:yPosition ?? 121.747301)//設定大頭針經緯度
        annotation.title = "測試位置" //目標名字
        map.addAnnotation(annotation)//把大頭針加入地圖
        map.setCenter(annotation.coordinate, animated: false)//設定大頭針在地圖中間




        if let coordinate = locationManager?.location?.coordinate{
            let xScale:CLLocationDegrees = 0.009
            let yScale:CLLocationDegrees = 0.009
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: yScale, longitudeDelta:xScale)
             let region = MKCoordinateRegion(center: coordinate, span: span)
              map.setRegion(region, animated: true)
        }
         map.userTrackingMode = .followWithHeading*/
        
      
        /*if isStop == true{
                print("斷線")
                text.text = op
            }else{
                print("連上")
                text.text = "連上"
            }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
     text.text = op

    }
    
    
    func goToMap(){
    //-------------使用者座標
     locationManager = CLLocationManager()
     locationManager?.requestWhenInUseAuthorization()//詢問是否給app定位功能
     locationManager?.delegate = self
     locationManager?.desiredAccuracy = kCLLocationAccuracyBest
     locationManager?.activityType = .automotiveNavigation
     locationManager?.startUpdatingLocation()//開始接收目前位置資訊
     //---------------大頭針---------------
     //詢問使用著位置，在目的位子加入圖釘
     let annotation = MKPointAnnotation()//宣告一個大頭針
     annotation.coordinate = CLLocationCoordinate2D(latitude: xPosition ?? 24.747329, longitude:yPosition ?? 121.747301)//設定大頭針經緯度
     annotation.title = "測試位置" //目標名字
     map.addAnnotation(annotation)//把大頭針加入地圖
     map.setCenter(annotation.coordinate, animated: false)//設定大頭針在地圖中間
     
    
     
     
     if let coordinate = locationManager?.location?.coordinate{
         let xScale:CLLocationDegrees = 0.009
         let yScale:CLLocationDegrees = 0.009
         let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: yScale, longitudeDelta:xScale)
         let region = MKCoordinateRegion(center: coordinate, span: span)
         map.setRegion(region, animated: true)
     }
     map.userTrackingMode = .followWithHeading
    }
    
    
    @IBAction func button1(_ sender: UIButton) {
        //locationManager(manager:locationManager, didUpdateLocations: [])
        goToMap()
        
    }
         //跑完viewDidLoad跳進這個函式
          func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
              
              //---------取得目前座標位置------------
              let c = locations[0] //c.coordinate.latitude目前緯度。//c.coordinate.longitude目前經度
              print("_____________________________")
              print(c.coordinate.latitude)
              print(c.coordinate.longitude)
              nowUserLocation = CLLocationCoordinate2D(latitude: c.coordinate.latitude, longitude: c.coordinate.longitude)
              
              //--------------導航--------------
              let pstartCoor = CLLocationCoordinate2D(latitude: nowUserLocation!.latitude, longitude: nowUserLocation!.longitude)
              let pstart = MKPlacemark(coordinate: pstartCoor)//根據使用者座標得到使用者地標
              let pendCoor = CLLocationCoordinate2D(latitude: xPosition ?? 24.747329, longitude: yPosition ?? 121.747301)//將經緯度放入pendCoor
              let pend = MKPlacemark(coordinate: pendCoor)//根據目標坐標得到目標地標
              let mistart = MKMapItem(placemark: pstart)//根據地標建立項目
              let misend = MKMapItem(placemark: pend)
              mistart.name = "使用者位置"
              misend.name = "目標位置"
              let routes = [mistart,misend]//將起始結尾放入陣列
              let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
                                           //設定到達的方法為走路
              MKMapItem.openMaps(with: routes, launchOptions: options)//開始導航
            
              //---------------------------------------------
                   //取得location的最後座標
            let location:CLLocation = locations[locations.count-1]
            let currLocation = locations.last!
                   //判斷是否為空
            if (location.horizontalAccuracy > 0){
               //lat = Double(String(format: "%.1f", location.coordinate.latitude))
               //long = Double(String(format: "%.1f", location.coordinate.longitude))
                
                lat = Double(String(location.coordinate.latitude))
                long = Double(String(location.coordinate.longitude))
                
                print("緯度:\(long!)")
                print("精度:\(lat!)")
                LonLatTO()
                locationManager?.stopUpdatingLocation()
                
            }
              
          }
          
          
    func  LonLatTO(){
        //---------------------------------------------
          //let coord :String = " \(long.coordinate.latitude),\(c.coordinate.longitude)"
          let coord :String = "\(long),\(lat)"
        print("斷線\(long),\(lat)")
          //傳送斷線資訊
          let url = URL(string:"http://kavalanwebservice.niu.edu.tw/megaliu168/WebService2.asmx/App_newwhere")
          
          guard let requestUrl = url else{
              fatalError()
          }
          var request = URLRequest(url:requestUrl as URL)
          //Compose a query string
          
          let postString:String = "unmail=\(email)&unid=3&address=\(coord)"
          
          print("Send data-",postString)
          
          request.httpBody = postString.data(using: .utf8)
          request.httpMethod = "POST"
          
          let task = URLSession.shared.dataTask(with: request){
              date, response, error in
              
              guard let _ = date,error == nil else{
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
          //
           
    }
   
    override func viewDidDisappear(_ animated: Bool) {    //離開這畫面就不用更新地址//
        locationManager?.stopUpdatingLocation()
        
        //因為執行GPS很耗電，所以被執行時關閉定位功能
        //locationManager?.stopUpdatingLocation()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "send1"{
            let secondVC = segue.destination as! borrowViewController
            secondVC.emailToborrowViewController = email
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
}









//第二次地圖
/*import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, CLLocationManagerDelegate {
    

    var email : String = ""
    
    @IBOutlet weak var user: UITextField!
    
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.activityType = .automotiveNavigation
        locationManager?.startUpdatingLocation()
        
        /*let myLocation = locationManager?.location?.coordinate
         print(myLocation?.latitude as Any)
         print(myLocation?.longitude as Any)*/
        
        
        
        if let coordinate = locationManager?.location?.coordinate{
            let xScale:CLLocationDegrees = 0.009
            let yScale:CLLocationDegrees = 0.009
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: yScale, longitudeDelta:xScale)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            map.setRegion(region, animated: true)
        }
        map.userTrackingMode = .followWithHeading
      
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("_____________________________")
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
        
        let coord :String = " \(locations[0].coordinate.latitude),\(locations[0].coordinate.longitude)"
        
        
        
        //傳送斷線資訊
        let url = URL(string:"http://kavalanwebservice.niu.edu.tw/megaliu168/WebService2.asmx/App_newwhere")
        
        guard let requestUrl = url else{
            fatalError()
        }
        var request = URLRequest(url:requestUrl as URL)
        //Compose a query string
        
        let postString:String = "unmail=\(email)&unid=3&address=\(coord)"
        
        print("Send data-",postString)
        
        request.httpBody = postString.data(using: .utf8)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request){
            date, response, error in
            
            guard let _ = date,error == nil else{
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
        //
         
        
        if isStop{
            print("連上")
        }else{
            print("斷線")
        }
        //self.performSegue(withIdentifier: "send1", sender: nil)
        
    }
    
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {    //離開這畫面就不用更新地址//
        locationManager?.stopUpdatingLocation()
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "send1"{
            let secondVC = segue.destination as! borrowViewController
            secondVC.emailToborrowViewController = email
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    
    
}*/





//原始地圖
/*import UIKit
 import MapKit
 import CoreLocation
 
 class MapController: UIViewController, CLLocationManagerDelegate {
 
 @IBOutlet weak var map: MKMapView!
 var locationManager: CLLocationManager?
 
 override func viewDidLoad() {
 super.viewDidLoad()
 locationManager = CLLocationManager()
 locationManager?.requestWhenInUseAuthorization()
 locationManager?.delegate = self
 locationManager?.desiredAccuracy = kCLLocationAccuracyBest
 locationManager?.activityType = .automotiveNavigation
 locationManager?.startUpdatingLocation()
 
 
 
 if let coordinate = locationManager?.location?.coordinate{
 let xScale:CLLocationDegrees = 0.009
 let yScale:CLLocationDegrees = 0.009
 let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: yScale, longitudeDelta:xScale)
 let region = MKCoordinateRegion(center: coordinate, span: span)
 map.setRegion(region, animated: true)
 }
 map.userTrackingMode = .followWithHeading
 }
 
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 
 print("_____________________________")
 print(locations[0].coordinate.latitude)
 print(locations[0].coordinate.longitude)
 }
 
 override func viewDidDisappear(_ animated: Bool) {    //離開這畫面就不用更新地址//
 locationManager?.stopUpdatingLocation()
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 }
 }*/
