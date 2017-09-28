//
//  BlePeripheralDelegate.swift
//  sketch
//
//  Created by Adonis Gaitatzis on 1/9/17.
//  Copyright © 2017 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import CoreBluetooth


/**
 BlePeripheralDelegate relays important status changes from BlePeripheral
 */
@objc protocol BlePeripheralDelegate : class {

    /**
     Bluetooth radio state changed
     
     - Parameters:
     - state: the CBManagerState
     */
    @objc optional func blePeripheral(stateChanged state: CBManagerState)

    
    /**
     BlePeripheral statrted adertising
     
     - Parameters:
     - error: the error message, if any
     */
    @objc optional func blePerihperal(startedAdvertising error: Error?)
    
    /**
     Characteristic was read
     
     - Parameters:
     - characteristic: the Characteristic that was read
     */
    @objc optional func blePeripheral(characteristicRead fromCharacteristic: CBCharacteristic)
    
}
