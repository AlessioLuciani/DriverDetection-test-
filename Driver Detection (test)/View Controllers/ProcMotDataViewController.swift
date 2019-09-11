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
    
    var motionData: [Int] = []
    
    @IBOutlet weak var lineChartView: LineChartView!
    

    @IBAction func saveToFile(_ sender: UIButton) {
        var text = "{\n"
        for i in 0 ..< motionData.count {
            text += "\"" + String(i) + "\":\"" + String(motionData[i]) + "\",\n"
        }
     
        text += "}\n"
        appendToFile(text)
    }
    
    @IBAction func resetFile(_ sender: UIButton) {
        writeToFile("")
    }
    
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
                        self.motionData.append(Int(x))
               
                        self.setChartValues(refreshUI: self.refreshChart)
                    }
                }
            }
        }
    }
    
    // Refreshes the UI of the chart
    func refreshChart(data: LineChartData) {
        self.lineChartView.data = data
        let val: Double = 360
        self.lineChartView.leftAxis.axisMinimum = -0
        self.lineChartView.leftAxis.axisMaximum = val
        self.lineChartView.rightAxis.axisMinimum = -0
        self.lineChartView.rightAxis.axisMaximum = val
    }

    
}


//////////// Save to file

func writeToFile(_ writeString: String) {

    // Save data to file
    let fileName = "motion_data"
    let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
    print("FilePath: \(fileURL.path)")
    
    
    do {
        // Write to the file
        try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
    }
    
    var readString = "" // Used to store the file contents
    do {
        // Read the file contents
        readString = try String(contentsOf: fileURL)
    } catch let error as NSError {
        print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
    }
    print("File Text: \(readString)")
    
}

func appendToFile(_ writeString: String) {
    
    // Save data to file
    let fileName = "motion_data"
    let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
    
    var readString = "" // Used to store the file contents
    do {
        // Read the file contents
        readString += try String(contentsOf: fileURL)
    } catch let error as NSError {
        print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
    }
    
    readString += writeString + ",\n"
    
    writeToFile(readString)
    
}


/*
//////////// HTTP request

func performRequest(data: String) {
    
    let url = URL(string: "http://www.stackoverflow.com")!
    
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard let data = data else { return }
        print(String(data: data, encoding: .utf8)!)
    }
    
    task.resume()
    
}

*/
