//
//  MagDataViewController.swift
//  Driver Detection (test)
//
//  Created by Alessio Luciani on 05/07/2019.
//  Copyright © 2019 Alessio Luciani. All rights reserved.
//

import UIKit
import CoreMotion
import Charts

class MagDataViewController: MotionDataViewController {

    @IBOutlet weak var labelX: UILabel!
    @IBOutlet weak var labelY: UILabel!
    @IBOutlet weak var labelZ: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        work = createWork()
        
        startMagnetometer()
        
        
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
        
        // Axis labels tap
        labelX.isUserInteractionEnabled = true
        labelY.isUserInteractionEnabled = true
        labelZ.isUserInteractionEnabled = true
      //  labelX.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleX(sender:))))
        labelY.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleY(sender:))))
        labelZ.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleZ(sender:))))

        
        
    }
    
    
    
    
    // Refreshes the labels with current accelerometer data
    override func createWork() -> DispatchWorkItem {
        return DispatchWorkItem {
            if let data = self.motion.magnetometerData {
                let x = data.magneticField.x
                let y = data.magneticField.y
                let z = data.magneticField.z
                DispatchQueue.main.async {
                    self.labelX.text = "X: \(Double(round(100*x)/100))"
                    self.labelY.text = "Y: \(Double(round(100*y)/100))"
                    self.labelZ.text = "Z: \(Double(round(100*z)/100))"
                 
                    
                    // Difference of time (now - view opened)
                    let deltaTime = NSDate().timeIntervalSince(self.startTime)
                    
                    // Storing and updating current motion values
                    if self.valuesX.count == 0 ||
                        floor(deltaTime) > floor(self.valuesX[self.valuesX.count-1].x) ||
                        deltaTime > self.valuesX[self.valuesX.count-1].x + 0.5 {
                        self.valuesX.append(ChartDataEntry(x: Double(deltaTime), y: x))
                        self.valuesY.append(ChartDataEntry(x: Double(deltaTime), y: y))
                        self.valuesZ.append(ChartDataEntry(x: Double(deltaTime), y: z))
                        
                        self.setChartValues(refreshUI: self.refreshChart)
                    }
                    
                    
                }
            }
        }
    }
    
    // Refreshes the UI of the chart
    func refreshChart (data: LineChartData) {
        
        self.lineChartView.data = data
        self.lineChartView.leftAxis.axisMinimum = -150
        self.lineChartView.leftAxis.axisMaximum = 150
        self.lineChartView.rightAxis.axisMinimum = -150
        self.lineChartView.rightAxis.axisMaximum = 150
    }
    
    
    override func toggleX(sender: UITapGestureRecognizer) {
        super.toggleX(sender: sender)
        setChartValues(refreshUI: self.refreshChart)
    }
    
    override func toggleY(sender: UITapGestureRecognizer) {
        super.toggleY(sender: sender)
        setChartValues(refreshUI: self.refreshChart)
    }
    
    override func toggleZ(sender: UITapGestureRecognizer) {
        super.toggleZ(sender: sender)
        setChartValues(refreshUI: self.refreshChart)
    }

}
