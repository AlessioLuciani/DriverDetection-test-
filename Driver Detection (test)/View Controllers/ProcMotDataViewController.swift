//
//  ProcMotDataViewController.swift
//  Driver Detection (test)
//
//  Created by Alessio Luciani on 19/07/2019.
//  Copyright © 2019 Alessio Luciani. All rights reserved.
//

import UIKit
import CoreMotion
import Charts

class ProcMotDataViewController: MotionDataViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating executable work
        self.work = createWork()
        
        // Starting processed motion data retriever
        startProcMotion()
        
        // Execution thread
        DispatchQueue.global(qos: .default).async {
            while !self.work.isCancelled {
                usleep(100000)
                if self.workActive {
                    self.work.perform()
                }
            }
        }
        
        // Chart tap
        lineChartView.isUserInteractionEnabled = true
        lineChartView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pauseResumeRefresh(sender:))))
        
        
    }
    
    // Refreshes the labels with current accelerometer data
    override func createWork() -> DispatchWorkItem {
        return DispatchWorkItem {
            if let data = self.motion.deviceMotion {
                let x = data.heading
                //let y = data.acceleration.y
                //let z = data.acceleration.z
                DispatchQueue.main.async { // Executing on UI Thread
                    
                    // Difference of time (now - view opened)
                    let deltaTime = NSDate().timeIntervalSince(self.startTime)
                    
                    // Storing and updating current motion values
                    if self.valuesX.count == 0 ||
                        floor(deltaTime) > floor(self.valuesX[self.valuesX.count-1].x) ||
                        deltaTime > self.valuesX[self.valuesX.count-1].x + 0.5 {
                        self.valuesX.append(ChartDataEntry(x: Double(deltaTime), y: x))
                       // self.valuesY.append(ChartDataEntry(x: Double(deltaTime), y: y))
                       // self.valuesZ.append(ChartDataEntry(x: Double(deltaTime), y: z))
                        
                        self.setChartValues(refreshUI: self.refreshChart)
                    }
                }
            }
        }
    }
    
    // Refreshes the UI of the chart
    func refreshChart(data: LineChartData) {
        self.lineChartView.data = data
        let val: Double = 2
        self.lineChartView.leftAxis.axisMinimum = -val
        self.lineChartView.leftAxis.axisMaximum = val
        self.lineChartView.rightAxis.axisMinimum = -val
        self.lineChartView.rightAxis.axisMaximum = val
    }

    
}
