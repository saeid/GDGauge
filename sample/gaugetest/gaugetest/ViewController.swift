//
//  ViewController.swift
//  ttt
//
//  Created by Saeid Basirnia on 5/11/18.
//  Copyright © 2018 Saeid Basirnia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionDataDelegate {
    var speed: GDGaugeView!
    var speedLabel: UILabel!
    var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and instatiate the view and set parameters
        speed = GDGaugeView(frame: view.bounds)
        // Set main gauge view color
        // -> speed.baseColor = UIColor.cyan
        
        // Show circle border
        // -> speed.showBorder = false
        
        // Show full circle border if .showBorder is set to true
        // -> speed.fullBorder = true
        
        // Set starting degree based on zero degree on bottom center of circle space
        // -> speed.startDegree = 45.0
        
        // Set ending degree based on zero degree on bottom center of circle space
        // -> speed.endDegree = 270.0
        
        // Minimum value
        // -> speed.min = 0.0
        
        // Maximum value
        // -> speed.max = 16.0
        
        // Determine each step value
        // -> speed.stepValue = 4.0
        
        // Color of handle
        // -> speed.handleColor = UIColor.cyan
        
        // Color of seprators
        // -> speed.sepratorColor = UIColor.black
        
        // Color of texts
        // -> speed.textColor = UIColor.black
        
        // Center indicator text
        // -> speed.unitText = "mb/s"
        
        // Center indicator font
        // -> speed.unitTextFont = UIFont.systemFont(ofSize: 10)
        
        // Indicators text
        // -> speed.textFont = UIFont.systemFont(ofSize: 20)
        view.addSubview(speed)
        
        /// After configuring the component, call setupView() method to create the gauge view
        speed.setupView()
        
        speedLabel = UILabel()
        speedLabel.font = UIFont.systemFont(ofSize: 17)
        speedLabel.textColor = UIColor.black
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(speedLabel)
        
        speedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        
        slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 220
        slider.isContinuous = true
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(valChange(_:)), for: .valueChanged)
        view.addSubview(slider)
        
        slider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        slider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        slider.bottomAnchor.constraint(equalTo: speedLabel.topAnchor, constant: -35).isActive = true
        
//        checkForSpeedTest()
    }
    
    /// Moving handle using slider
    @objc func valChange(_ sender: UISlider){
        // Set .currentValue of GDGaugeView to move the handle
        print(sender.value)
        speed.currentValue = CGFloat(sender.value)
    }
    
    //// Testing with download file. showing download speed
    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!
    
    func checkForSpeedTest() {
        testDownloadSpeedWithTimout(timeout: 50)
    }
    
    func testDownloadSpeedWithTimout(timeout: TimeInterval) {
        guard let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/cellinfoapp.appspot.com/o/download-test.file.dmg?alt=media&token=046d7f63-208e-4566-b8d3-f5800ad84d6e") else { return }
        
        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        let session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
        session.dataTask(with: url).resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bytesReceived! += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
        
        let elapsed = stopTime - startTime
        let mbits = (Double(bytesReceived) / 1024 / 1024) * 8
        let speed = elapsed != 0 ? mbits / elapsed : -1
        
        DispatchQueue.main.async {
            self.speedLabel.text = String(speed) + " mb/s"
            self.speed.currentValue = CGFloat(speed)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let elapsed = stopTime - startTime
        
        if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
            return
        }
        let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
        DispatchQueue.main.async {
            self.speed.currentValue = 0
            self.speedLabel.text = String(speed)
        }
    }
}


