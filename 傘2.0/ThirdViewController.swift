//
//  ThirdViewController.swift
//  傘2.0
//
//  Created by chang on 2019/10/31.
//  Copyright © 2019 chang. All rights reserved.
//
import UIKit
import CoreBluetooth

class ThirdViewController: UIViewController ,CBCentralManagerDelegate , CBPeripheralDelegate {
    //Central 端需符合 cbcentralmanagerddelegate, cbperipheraldelegate協定//
    
    enum SendDateError: Error {      //自訂錯誤類別
        case CharacteristicNotFound
      }
    
    var centralManager: CBCentralManager!    //這個整體變數管理central端藍芽連線
    
    var connectPeripheral: CBPeripheral!
    var charDictionary = [String: CBCharacteristic]()  //所有Peripheral端掃描的東西都會被放到這個字典物件
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let queue = DispatchQueue.global()                                //在viewDidloads的主程式,主要初始化centralManager這個變數//
            //將觸發1號method//
        centralManager = CBCentralManager (delegate:self ,queue:queue)   //有兩個主要參數queue(佇列)決定是否只在delegate執行 //
    }
    
    //以下為如合與peripheral端執行
    func isPaired() -> Bool{                           //如果central端與peripheral端連線會是true
        let user = UserDefaults.standard
        if let uuidString = user.string(forKey:"KEY_PERIPHERAL_UUID"){
            let uuid = UUID(uuidString: uuidString)
            let list = centralManager.retrievePeripherals(withIdentifiers: [uuid!])
            if list.count > 0{
                connectPeripheral = list.first!
                connectPeripheral.delegate = self
                return true
            }
        }
        return false
    }
    
    // 1號method//
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        //先判斷藍芽是否開啟，如果不是藍芽4.x，也會傳回電源未開啟
        guard central.state == .poweredOn else{
            // iOS 會出現對話框提醒使用者
            return
        }
        if isPaired() {
            //將觸發 3號method//
            centralManager.connect(connectPeripheral, options: nil)
        } else{
            //將觸發2號method                                    // cenctral端掃描附近perripheral端
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        
    }
    
      // 2號method /
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("找到藍芽裝置： \(String(describing: peripheral.name))")     //掃描到的周邊藍牙裝置會存到上面的func，有幾個就會呼叫幾次//
        
        guard peripheral.name != nil else {          //有時候名字會是nil，那不是我們要的所以直接return掉 //
            return
        }
        guard peripheral.name?.range(of: "") != nil else{  //注意這裡    //會掃到上個peripheral程式我們命名的我的裝置，如果peripheral端在mac os上我們掃不
            return                                    //到會印出某某某的iphone//
        }
        
        central.stopScan()                          // 掃描到我們要的了stop scan//
                              //儲存周邊的UUID，重新連線時需要這個值//  //重要//
        let user = UserDefaults.standard                                                                                     //掃描到的peripheral的identifier的uuid//
        user.set(peripheral.identifier.uuidString, forKey: "KEY_PERIPHERAL_UUID")         //字串把它存起來，在檔案裡面，免得重開機後//在記憶體資料消失//        user.synchronize()
            // 這裏的uuid做為重開機或central端跟peripheral端太遠斷線，靠這個uuid字串重新連線
            //for key為這個字串的索引//
        connectPeripheral = peripheral                  //找到的peripheral存到connectPeripheral這個整體變數，這行沒寫找到的peripheral會消失//
        connectPeripheral.delegate = self
        
        //將觸發3號method
        centralManager.connect(connectPeripheral, options: nil)        //我的centralManager要跟我找到的peripheral連線，
    }                                                                    //連線上觸發3號method//
    
    // 3號method//
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        charDictionary = [:]                     //把一開始整體字典裡的物件清掉，主要是用做斷線在連線時不會在重複//
        //將觸發4號method//
        peripheral.discoverServices(nil)       //呼叫discoverservices這個method,呼叫後central端會去掃描peripheral端所有提供出來的
    }                                            //services,之後觸發4號method//
    // 4號method//
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        guard error == nil else {
            print("ERROR: \(#file),\(#function)")
            return
        }
        
        for service in peripheral.services! {
            
            //用這個迴圈掃描peripheral端所有的service,另一個  程式只有一個a001這個service,因為peripheral端是在mac上執行，ｍac不會只有一個service，用這個迴圈會把mac os上所有的service掃描出來，迴圈每跑遍一遍掃描到的service，接著呼叫discoverCharacteristics,就可以把這個service下面所有包含的characteristics全部掃出來
            
            //將觸發5號method//
            connectPeripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    // 5號method//
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error:Error?){
        guard error == nil else {
            print("ERROR: \(#file),\(#function)")
            return
        }
        
        for characteristic in service.characteristics! {          //掃描到的service下面的所有的characteristic全部掃出來
            let uuidString = characteristic.uuid.uuidString       //上面的迴圈跑幾遍這裡就跑幾次//
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
                
                if self.textView.text == ""{      //如果textview的text為空字串
                    self.textView.text = string
                }else{
                    self.textView.text = self.textView.text + "\n" + string
                }
                
                
            }
        }
    }
    
    // 將資料傳送到Peripheral //
    func sendData(_ data: Data, uuidString: String, writeType: CBCharacteristicWriteType) throws {
        guard let characteristic = charDictionary[uuidString] else{
            throw SendDateError.CharacteristicNotFound
        }
        
        connectPeripheral.writeValue(
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
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {        let char = charDictionary["0xFFE0"]!
connectPeripheral.setNotifyValue(sender.isOn, for: char)
    }
    
    @IBAction func sendClick(_ sender: Any) {
        let string = textField.text ?? ""
        if self.textView.text == ""{      //如果textview的text為空字串
            self.textView.text = string
        }else{
            self.textView.text = self.textView.text + "\n" + string
        }
        do{
            try sendData(string.data(using: .utf8)!, uuidString:"0xFFE0",writeType:.withoutResponse)
        } catch{
            print(error)
        }
    }
    
    
    
    
    // 以下處理斷線// //狀況：兩邊有一台關機或距離太遠或解配對//
    func centralManager(_ central: CBCentralManager,didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("連線中斷")
        if isPaired() {
            centralManager.connect(connectPeripheral)
        }
    }
    
    //解配對//
    func unpair() {
        let user = UserDefaults.standard
        user.removeObject(forKey: "KEY_PERIPHERAL_UUID")
        user.synchronize()
        centralManager.cancelPeripheralConnection(connectPeripheral)
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
     }
}
