//
//  ViewController.swift
//  sketch
//
//  Created by Adonis Gaitatzis on 1/9/17.
//  Copyright © 2017 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import CoreBluetooth

/**
 This view displays the state of a BlePeripheral
 */
class ViewController: UIViewController, BlePeripheralDelegate {
    
    // MARK: UI Elements
    @IBOutlet weak var advertisingLabel: UILabel!
    @IBOutlet weak var advertisingSwitch: UISwitch!
    @IBOutlet weak var characteristicValueTextField: UITextField!

    // MARK: BlePeripheral
    
    // BlePeripheral
    var blePeripheral:BlePeripheral!
    
    // Interval timer to update Read Characteristic
    var randomTextTimer:Timer!
    
    /**
     UIView loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    /**
     View appeared.  Start the Peripheral
     */
    override func viewDidAppear(_ animated: Bool) {
        blePeripheral = BlePeripheral(delegate: self)
        
        advertisingLabel.text = blePeripheral.advertisingName
    }
    
    /**
     View will appear.  Stop transmitting random data
     */
    override func viewWillDisappear(_ animated: Bool) {
        randomTextTimer.invalidate()
        blePeripheral.stop()
    }
    
    /**
     View disappeared.  Stop advertising
     */
    override func viewDidDisappear(_ animated: Bool) {
        advertisingSwitch.setOn(false, animated: true)
    }
    
    // MARK: Update BlePeripheral Properties
    
    /**
     Generate a random String
     
     - Parameters
     - length: the length of the resulting string
     
     - returns: random alphanumeric string
     */
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    /**
     Set Read Characteristic to some random text value
     */
    func setRandomCharacteristicValue() {
        let stringValue = randomString(
            length: Int(arc4random_uniform(
                UInt32(blePeripheral.readCharacteristicLength - 1))
            )
        )
        let value:Data = stringValue.data(using: .utf8)!
        
        blePeripheral.setCharacteristicValue(
            blePeripheral.readCharacteristic,
            value: value
        )
        
        characteristicValueTextField.text = stringValue
    }


    // MARK: BlePeripheralDelegate
    
    /**
     Bluetooth radio state changed
     
     - Parameters:
     - state: the CBManagerState
     */
    func blePeripheral(stateChanged state: CBManagerState) {
        switch (state) {
        case CBManagerState.poweredOn:
            print("Bluetooth on")
        case CBManagerState.poweredOff:
            print("Bluetooth off")
        default:
            print("Bluetooth not ready yet...")
        }
    }
    
    /**
     BlePeripheral statrted adertising
     
     - Parameters:
     - error: the error message, if any
     */
    func blePerihperal(startedAdvertising error: Error?) {
        if error != nil {
            print("Problem starting advertising: " + error.debugDescription)
        } else {
            print("adertising started")
            advertisingSwitch.setOn(true, animated: true)
            setRandomCharacteristicValue()
            randomTextTimer = Timer.scheduledTimer(
                timeInterval: 5,
                target: self,
                selector: #selector(setRandomCharacteristicValue),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    /**
     Characteristic was read
 
     - Parameters:
     - characteristic: the Characteristic that was read
     */
    func blePeripheral(characteristicRead fromCharacteristic: CBCharacteristic) {
        print("Characteristic read from")
    }

}

