//
//  GyroDataViewController.swift
//  Driver Detection (test)
//
//  Created by Alessio Luciani on 01/07/2019.
//  Copyright © 2019 Alessio Luciani. All rights reserved.
//

import UIKit
import CoreMotion
import Charts

class GyroDataViewController: MotionDataViewController {
    
    @IBOutlet weak var labelX: UILabel!
    @IBOutlet weak var labelY: UILabel!
    @IBOutlet weak var labelZ: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        work = createWork()
        
        startGyroscopes()
        
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
        labelX.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleX(sender:))))
        labelY.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleY(sender:))))
        labelZ.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleZ(sender:))))

        
    }
    
    
 
    // Refreshes the labels with current accelerometer data

    override func createWork() -> DispatchWorkItem {
        return DispatchWorkItem {
            if let data = self.motion.gyroData {
                let x = data.rotationRate.x
                let y = data.rotationRate.y
                let z = data.rotationRate.z
                DispatchQueue.main.async {
                    self.labelX.text = "X: \(Double(round(100*x)/100))"
                    self.labelY.text = "Y: \(Double(round(100*y)/100))"
                    self.labelZ.text = "Z: \(Double(round(100*z)/100))"
                    if x >= 0 {
                        self.labelX.textColor = UIColor(red: CGFloat(x/2), green: 0, blue: 0, alpha: 255)
                    } else {
                        self.labelX.textColor = UIColor(red: CGFloat(-x/2), green: 0, blue: 0, alpha: 255)
                    }
                    if y >= 0 {
                        self.labelY.textColor = UIColor(red: 0, green: CGFloat(y/2), blue: 0, alpha: 255)
                    } else {
                        self.labelY.textColor = UIColor(red: 0, green: CGFloat(-y/2), blue: 0, alpha: 255)
                    }
                    if z >= 0 {
                        self.labelZ.textColor = UIColor(red: 0, green: 0, blue: CGFloat(z/2), alpha: 255)
                    } else {
                        self.labelZ.textColor = UIColor(red: 0, green: 0, blue: CGFloat(-z/2), alpha: 255)
                    }
                
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
        self.lineChartView.leftAxis.axisMinimum = -10
        self.lineChartView.leftAxis.axisMaximum = 10
        self.lineChartView.rightAxis.axisMinimum = -10
        self.lineChartView.rightAxis.axisMaximum = 10
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
