//
//  CharacteristicViewController.swift
//  ReadCharacteristic
//
//  Created by Adonis Gaitatzis on 11/22/16.
//  Copyright © 2016 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import CoreBluetooth

/**
 This view talks to a Characteristic
 */
class CharacteristicViewController: UIViewController, CBCentralManagerDelegate, BlePeripheralDelegate {
    
    // MARK: UI elements
    @IBOutlet weak var advertizedNameLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var characteristicUuidlabel: UILabel!
    @IBOutlet weak var readCharacteristicButton: UIButton!
    @IBOutlet weak var characteristicValueText: UITextView!
    
    
    // MARK: Connected devices
    
    // Central Bluetooth Radio
    var centralManager:CBCentralManager!
    
    // Bluetooth Peripheral
    var blePeripheral:BlePeripheral!
    
    // Connected Characteristic
    var connectedService:CBService!
    
    // Connected Characteristic
    var connectedCharacteristic:CBCharacteristic!
    

    /**
     UIView loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Will connect to device \(blePeripheral.peripheral.identifier.uuidString)")
        print("Will connect to characteristic \(connectedCharacteristic.uuid.uuidString)")
        
        centralManager.delegate = self
        blePeripheral.delegate = self
        
        loadUI()
        
    }
    
    /**
     Load UI elements
     */
    func loadUI() {
        advertizedNameLabel.text = blePeripheral.advertisedName
        identifierLabel.text = blePeripheral.peripheral.identifier.uuidString
        
        characteristicUuidlabel.text = connectedCharacteristic.uuid.uuidString
        readCharacteristicButton.isEnabled = true
        
        // characteristic is not readable
        if !BlePeripheral.isCharacteristic(isReadable: connectedCharacteristic) {
            readCharacteristicButton.isHidden = true
            characteristicValueText.isHidden = true
        }
    }

    
    /**
     User touched Read button.  Request to read the Characteristic
     */
    @IBAction func onReadCharacteristicButtonTouched(_ sender: UIButton) {
        print("pressed button")
        
        readCharacteristicButton.isEnabled = false
        blePeripheral.readValue(from: connectedCharacteristic)

    }    
    
    // MARK: BlePeripheralDelegate
    
    /**
     Characteristic was read.  Update UI
     */
    func blePeripheral(characteristicRead stringValue: String, characteristic: CBCharacteristic, blePeripheral: BlePeripheral) {
        print(stringValue)
        
        readCharacteristicButton.isEnabled =  true
        characteristicValueText.insertText(stringValue + "\n")
        
        let stringLength = characteristicValueText.text.characters.count
        characteristicValueText.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }

    
    
    // MARK: CBCentralManagerDelegate
    
    /**
     Peripheral disconnected
     
     - Parameters:
     - central: the reference to the central
     - peripheral: the connected Peripheral
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // disconnected.  Leave
        print("disconnected")
        if let navController = navigationController {
            navController.popToRootViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    /**
     Bluetooth radio state changed
     
     - Parameters:
     - central: the reference to the central
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central Manager updated: checking state")
        
        switch (central.state) {
        case .poweredOn:
            print("bluetooth on")
        default:
            print("bluetooth unavailable")
        }
    }
    

    
    
    // MARK: - Navigation
    
    /**
     Animate the segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let connectedBlePeripheral = blePeripheral {
            centralManager.cancelPeripheralConnection(connectedBlePeripheral.peripheral)
        }
    }
    

}
