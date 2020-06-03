//
//  ViewController.swift
//  傘2.0
//
//  Created by chang on 2019/10/31.
//  Copyright © 2019 chang. All rights reserved.
//
import UIKit
import Foundation
import CoreBluetooth


class ItemsViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    enum SendDateError: Error {      //自訂錯誤類別
          case CharacteristicNotFound
        }
    
    
    var manager: CBCentralManager!
    var peripheral: CBPeripheral!
    var charDictionary = [String:CBCharacteristic]()
    
   
    
    
    let scanningDelay = 1.0
    var items = [String: [String: Any]]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.keys.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        if let item = itemForIndexPath(indexPath){
            cell.textLabel?.text = item["name"] as? String
            
            if let rssi = item["rssi"] as? Int {
                cell.detailTextLabel?.text = "\(rssi.description) dBm"
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
        
        return cell
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> [String: Any]?{
        
        if indexPath.row > items.keys.count{
            return nil
        }
        
        return Array(items.values)[indexPath.row]
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        if central.state == .poweredOn{
            manager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        guard peripheral.name != nil
            else {
            return
        }
        print("找到藍牙裝置: \(peripheral)")
        central.stopScan()
        didReadPeripheral(peripheral, rssi: RSSI)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        
        didReadPeripheral(peripheral, rssi: RSSI)
        
        delay(scanningDelay){
            peripheral.readRSSI()
        }
    }
    
    func didReadPeripheral(_ peripheral: CBPeripheral, rssi: NSNumber){
        
        if let name = peripheral.name{
            
            items[name] = [
                "name":name,
                "rssi":rssi
            ]
        }
        tableView.reloadData()
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        print("裝置連線")
        charDictionary = [:]
     
        peripheral.readRSSI()
        
        
        
    }


func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        guard error == nil else {
            print("ERROR: \(#file),\(#function)")
            return
        }
        
        for service in peripheral.services! {
            //將觸發5號method//
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    // 5號method//
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error:Error?){
        guard error == nil else {
            print("ERROR: \(#file),\(#function)")
            return
        }
        
        for characteristic in service.characteristics! {          //掃描到的service下面的所有的characteristic全部掃出來
            let uuidString = characteristic.uuid.uuidString
            charDictionary[uuidString] = characteristic
            print("找到： \(uuidString)")
        }
    }
    //以上是central端跟peripheral端的連線//
    
    
    //取得Peripheral送過來的資料//
    func peripheral(_ peripheral:CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error:Error?) {
        guard error == nil else {
            print("ERROR: \(#file),\(#function)")
            print(error!)
            return
        }
        if characteristic.uuid.uuidString == "0xFFE0" {
            let data = characteristic.value! as NSData
            DispatchQueue.main.async {
                var string = String(data: data as Data, encoding: .utf8)!
                string = "> " + string
                print(string)        //central端收到peripheral端送過來的資料，要送到畫面上的textview
        
            }
        }
    }
    
    // 將資料傳送到Peripheral //
    func sendData(_ data: Data, uuidString: String, writeType: CBCharacteristicWriteType) throws {
        guard let characteristic = charDictionary[uuidString] else{
            throw SendDateError.CharacteristicNotFound
        }
        
        peripheral.writeValue(
            data,
            for: characteristic,
            type: writeType
        )
    }

    // 如果Peripheral端有 respons時呼叫//
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error:Error?){
        if error != nil {
            print("寫入資料錯誤: \(String(describing: error))")
        }
    }

}
