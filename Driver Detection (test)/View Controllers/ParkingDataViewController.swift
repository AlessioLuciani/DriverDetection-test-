//
//  ParkingDataViewController.swift
//  Driver Detection (test)
//
//  Created by Alessio Luciani on 10/10/2019.
//  Copyright © 2019 Alessio Luciani. All rights reserved.
//

import Foundation
import UIKit

class ParkingDataViewController: UIViewController {
    
    var parkDataCollector = ParkDataCollector()
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func onStartPressed(_ sender: Any) {

        parkDataCollector.startCollectingData()
        
    }
    
    @IBAction func onStopPressed(_ sender: Any) {
        parkDataCollector.stopCollectingData()
    }
    
}
