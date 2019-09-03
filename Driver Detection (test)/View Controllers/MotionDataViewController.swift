//
//  MotionDataViewController.swift
//  Driver Detection (test)
//
//  Created by Alessio Luciani on 02/07/2019.
//  Copyright © 2019 Alessio Luciani. All rights reserved.
//

import CoreMotion
import UIKit
import Charts

class MotionDataViewController: UIViewController {
    
    
    
    let motion = CMMotionManager()
    
    // Axis settings
    var xActive = true
    var yActive = true
    var zActive = true
    
    
    // Dictionaries of motion values
    var valuesX: [ChartDataEntry] = []
    var valuesY: [ChartDataEntry] = []
    var valuesZ: [ChartDataEntry] = []
    
    // Starting time
    let startTime = Date()
    
    // Executable work
    var work: DispatchWorkItem!
    // Work status
    var workActive = true
    
    
    // Starts the accelererometers
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            
        }
    }
    
    // Starts the gyroscopes
    func startGyroscopes() {
        // Make sure the gyroscope hardware is available.
        if self.motion.isGyroAvailable{
            self.motion.gyroUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startGyroUpdates()
            
        }
    }
    
    // Starts the magnetometer
    func startMagnetometer() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isMagnetometerAvailable {
            self.motion.magnetometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startMagnetometerUpdates()
            
        }
    }
    
    // Starts the processed motion data retriever
    func startProcMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
        }
    }
    
    // To override
    func createWork() -> DispatchWorkItem {
        return DispatchWorkItem {}
    }
    
    
    // Sets the values of the chart
    func setChartValues(refreshUI: (LineChartData) -> Void) {
        
        let tempX = xActive ? valuesX : []
        let tempY = yActive ? valuesY : []
        let tempZ = zActive ? valuesZ : []

        let setX = LineChartDataSet(entries: tempX, label: "X")
        let setY = LineChartDataSet(entries: tempY, label: "Y")
        let setZ = LineChartDataSet(entries: tempZ, label: "Z")
        
        setX.setColor(UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0))
        setX.setCircleColor(UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0))
        setY.setColor(UIColor(red: 0, green: 1.0, blue: 0, alpha: 1.0))
        setY.setCircleColor(UIColor(red: 0, green: 1.0, blue: 0, alpha: 1.0))
        setZ.setColor(UIColor(red: 0, green: 0, blue: 1.0, alpha: 1.0))
        setZ.setCircleColor(UIColor(red: 0, green: 0, blue: 1.0, alpha: 1.0))
        
        
        setX.circleRadius = 3
        setY.circleRadius = 3
        setZ.circleRadius = 3
        
        let data = LineChartData(dataSets: [setX, setY, setZ])
        
        refreshUI(data)
        
        // Deleting previous values
        let maxItemsNum = 30
        if valuesX.count >= maxItemsNum {
            valuesX.removeFirst()
        }
        if valuesY.count >= maxItemsNum {
            valuesY.removeFirst()
        }
        if valuesZ.count >= maxItemsNum {
            valuesZ.removeFirst()
        }
        
    }
    
    // Toggles the X axis
    @objc func toggleX(sender: UITapGestureRecognizer) {
        xActive = xActive ? false : true
    }

    // Toggles the Y axis
    @objc func toggleY(sender: UITapGestureRecognizer) {
        yActive = yActive ? false : true
    }
    
    // Toggles the X axis
    @objc func toggleZ(sender: UITapGestureRecognizer) {
        zActive = zActive ? false : true
    }
    

    
    // Pauses or resumes the refresh
    @objc func pauseResumeRefresh(sender: UITapGestureRecognizer) {
        self.workActive = self.workActive ? false : true
    }
    
}
