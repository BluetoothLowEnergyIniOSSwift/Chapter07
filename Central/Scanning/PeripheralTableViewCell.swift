//
//  GattTableViewCell.swift
//  Services
//
//  Created by Adonis Gaitatzis on 11/21/16.
//  Copyright © 2016 Adonis Gaitatzis. All rights reserved.
//

import UIKit
import CoreBluetooth

/**
 Peripheral Table View Cell
 */
class PeripheralTableViewCell: UITableViewCell {
    
    // MARK: UI elements
    @IBOutlet weak var advertisedNameLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
    /**
     Render Cell with Peripheral properties
     */
    func renderPeripheral(_ blePeripheral: BlePeripheral) {
        advertisedNameLabel.text = blePeripheral.advertisedName
        identifierLabel.text = blePeripheral.peripheral.identifier.uuidString
        rssiLabel.text = blePeripheral.rssi.stringValue
        
    }
    
    
}
