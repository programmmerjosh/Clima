//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//
//  Completion of app by Joshua van Niekerk

import UIKit


//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func newCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    var delegate: ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!

    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        //1 Get the city name the user entered in the text field
        if let newCity = (changeCityTextField.text)?.replacingOccurrences(of: " ", with: "%20") {
            
            //2 If we have a delegate set, call the method userEnteredANewCityName
            delegate?.newCityName(city: newCity)
            
            //3 dismiss the Change City View Controller to go back to the WeatherViewController
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
