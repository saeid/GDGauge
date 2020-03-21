//
//  ViewController.swift
//  ttt
//
//  Created by Saeid Basirnia on 5/11/18.
//  Copyright © 2018 Saeid Basirnia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionDataDelegate {
    var gaugeView: GDGaugeView!
    var valueLabel: UILabel!
    var valueSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Build and customize gauge view
        gaugeView = GDGaugeView(frame: view.bounds)
        view.addSubview(gaugeView)
        
        // To setup the gauge view
        gaugeView
            .setupGuage(startDegree: 45, endDegree: 315, sectionGap: 20, minValue: 0, maxValue: 300)
            .setupContainer()
            .setupUnitTitle(title: "KM/H")
            .buildGauge()
        
        valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 17)
        valueLabel.textColor = UIColor.black
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(valueLabel)
        
        valueLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        
        valueSlider = UISlider()
        valueSlider.minimumValue = 0
        valueSlider.maximumValue = 300
        valueSlider.isContinuous = true
        valueSlider.translatesAutoresizingMaskIntoConstraints = false
        valueSlider.addTarget(self, action: #selector(valChange(_:)), for: .valueChanged)
        view.addSubview(valueSlider)
        
        valueSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        valueSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        valueSlider.bottomAnchor.constraint(equalTo: valueLabel.topAnchor, constant: -35).isActive = true
    }
    
    /// Moving handle using slider
    @objc func valChange(_ sender: UISlider){
        valueLabel.text = "Current value: \(sender.value)"
        gaugeView.updateValueTo(CGFloat(sender.value))
        
        // To change color when a limit reached use the following methods
        if sender.value > 120 {
            gaugeView.updateColors(containerColor: UIColor.red, indicatorsColor: UIColor.black)
        } else {
            gaugeView.resetColors()
        }
    }
}


