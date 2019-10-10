//
//  ParkDataCollector.swift
//  Driver Detection (test)
//
//  Created by Alessio Luciani on 10/10/2019.
//  Copyright © 2019 Sapienza Apps. All rights reserved.
//



// TODO: Da valutare la questione dell'heading iniziale. Nella DriverDetection lo abbiamo fissato a 180°,
// qui facciamo la stessa cosa? In caso, in che momento fissiamo l'heading iniziale?

import Foundation
import CoreMotion

/**
 Class used to collect data of a parking motion.
 */
class ParkDataCollector {
    
    // Work item that collects data
    private var dataCollectionWork = DispatchWorkItem{}
    
    // Collection status
    private var collectingData = false
    
    private var parkSample = ParkSample()
    
    let motion = CMMotionManager()
    
    
    /**
     Starts the data collection.
     */
    func startCollectingData() {
        if (collectingData) {
            return
        }
        collectingData = true
        startProcMotion()
        dataCollectionWork = createWork()
        parkSample = ParkSample()
        
        DispatchQueue.global(qos: .default).async {
            while !self.dataCollectionWork.isCancelled {
                usleep(useconds_t(1000000 * self.parkSample.parkSampleFreq))
                self.dataCollectionWork.perform()
            }
        }
    }
    
    
    /**
     Stops the data collection.
     */
    func stopCollectingData() {
        if (!collectingData) {
            return
        }
        collectingData = false
        dataCollectionWork.cancel()
        let json = parkSample.json()
        // TODO: Inviare l'upload al server
    }
    
    
    func isCollectingData() -> Bool {
        return collectingData
    }
    
    /**
     Creates the executable work.
     */
    private func createWork() -> DispatchWorkItem {
        return DispatchWorkItem {
            if let data = self.motion.deviceMotion {
                let sample = Sample(heading: data.heading, acceleration: data.userAcceleration)
                self.parkSample.add(sample)
            }
        }
    }
    
    /**
     Starts the processed motion data retriever
     */
     private func startProcMotion() {
        if self.motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
             self.motion.showsDeviceMovementDisplay = true
             self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
         }
     }
    
}
