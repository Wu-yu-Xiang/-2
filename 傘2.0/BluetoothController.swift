//
//  File.swift
//  傘2.0
//
//  Created by chang on 2020/5/4.
//  Copyright © 2020 chang. All rights reserved.
//

import CoreBluetooth
import UIKit


class BluetoothController: UIViewController {
    
    var Informationget:Information?

    
    @IBOutlet weak var tableView: UITableView!
    var items = [String: [String:Any]]()
    var devices: Dictionary<String, CBPeripheral> = [:]
    var activeCentralManager: CBCentralManager?
    var connectPeripheral: CBPeripheral!
    
    var ary: [String] = ["um5"]
    var count = 1
    //多加
    //var service : CBService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        activeCentralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "send3"{
            let secondVC = segue.destination as! qrcodeViewController
            secondVC.sendQRimageOutDirectionFinish = Informationget!.sendQRimageOut

        }
    }
    
}

extension BluetoothController: UITableViewDelegate, UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return devices.count
        //return 0
       // return ary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothCell", for: indexPath) as! BluetoothCell
        let discoveredPeripherals = Array(devices.values)
        //let discoveredPeripherals = ary
        
        /* if let name1 = discoveredPeripherals.name{
         print(name)
         }*/
        
        if let name = discoveredPeripherals[indexPath.row].name{
             //if ary.contains(name){
                 cell.signalLabel.text = name
                
                //umstand=string&YN=string&bluetooth=string
                let url2 = URL(string:"http://kavalanwebservice.niu.edu.tw/megaliu168/WebService2.asmx/App_standchange")
                     
                     guard let requestUr2 = url2 else{
                         fatalError()
                     }
                     var request1 = URLRequest(url:requestUr2 as URL)
            
            let postString1:String = "\(Informationget!.sendYNumstandpost)&bluetooth=\(name)"
                     print("Send data-",postString1)
                     request1.httpBody = postString1.data(using: .utf8)
                     request1.httpMethod = "POST"
                     let task2 = URLSession.shared.dataTask(with: request1){
                         date, response, error in
                         guard let data1 = date,error == nil else{
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
                
        }
        
        cell.layer.cornerRadius = 15
        return cell
    }
    
    
    //這個是連線，重要
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let discoveredPeripherals = Array(devices.values)
        print(devices.values)
        activeCentralManager?.connect(discoveredPeripherals[indexPath.row], options: nil)
        
        self.performSegue(withIdentifier: "send3", sender: nil)
        
        
        
    }
    
    
    
}
var op:String = ""
extension BluetoothController: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Searching for BLE Devices")
        } else {
            print("Bluetooth switched off")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            if (devices[name] == nil) {
                devices[name] = peripheral
                self.tableView.reloadData()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.readRSSI()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let name = peripheral.name {
            items[name] = [
                "name": name,
                "rssi": RSSI
            ]
        }
        
        tableView.reloadData()
    }
    
    
    
    
    //如果central端與peripheral端連線會是true
    
    func isPaired() -> Bool{
        let user = UserDefaults.standard
        if let uuidString = user.string(forKey:"KEY_PERIPHERAL_UUID"){
            let uuid = UUID(uuidString: uuidString)
            let list = activeCentralManager?.retrievePeripherals(withIdentifiers: [uuid!])
            if list!.count > 0{
                connectPeripheral = list?.first!
                connectPeripheral.delegate = self
                return true
            }
        }
        return false
    }
    
    
    
    // 以下處理斷線// //狀況：兩邊有一台關機或距離太遠或解配對//
    func centralManager(_ central: CBCentralManager,didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("連線中斷")
        op = "連線"
        if isPaired() {
            activeCentralManager?.connect(connectPeripheral)
        }
    }
    
  
         
    
    
    //解配對//
    func unpair() {
        let user = UserDefaults.standard
        user.removeObject(forKey: "KEY_PERIPHERAL_UUID")
        user.synchronize()
        activeCentralManager?.cancelPeripheralConnection(connectPeripheral)
    }
    
    
    
}


//umstand=string&YN=string&bluetooth=string
   /*let url2 = URL(string:"http://kavalanwebservice.niu.edu.tw/megaliu168/WebService2.asmx/App_standchange")
        
        guard let requestUr2 = url2 else{
            fatalError()
        }
        var request1 = URLRequest(url:requestUr2 as URL)
        //Compose a query string
        

        //umstand=string&YN=string&bluetooth=string
        //let postString1:String = "umstand=\(plus)&YN=\(YN)&bluetooth=\(name)"
        let postString1:String = "umstand=stroe&YN=\(YN)&bluetooth=rrr"
        print("Send data-",postString1)
        request1.httpBody = postString1.data(using: .utf8)
        request1.httpMethod = "POST"
        let task2 = URLSession.shared.dataTask(with: request1){
            date, response, error in
            guard let data1 = date,error == nil else{
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
            
        */
