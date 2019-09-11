//
//  ViewController.swift
//  WeatherApp
//
//  Skeleton project Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//
//  Completion of app by Joshua van Niekerk
//  I have an old MacBook Pro and therefor an older version of Xcode -
//  which is why I converted the swift 5 methods to swift 4.1 and commented out the swift 5 code

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID      = "67e98b9c8bbcaf705b0cc55e636f6a77"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    var locationManager  = CLLocationManager()
    var weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon      : UIImageView!
    @IBOutlet weak var cityLabel        : UILabel!
    @IBOutlet weak var temperatureLabel : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Set up the location manager here.
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // this linked to a key value pair in the info.plist file
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String : String]) {
        
        // swift 4.1
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Failed with \(String(describing: response.error))")
                self.cityLabel.text = "Connection Issues."
            }
        }
        
        // swift 5
//        Alamofire.request(url: url, method: .get, parameters: parameters).responseJSON {
//            response in
//            if response.result.isSuccess {
//                let weatherJSON : JSON = JSON(response.result.value!)
//                self.updateWeatherData(json: weatherJSON)
//            } else {
//                print("Failed with \(response.error)")
//                cityLabel.text = "Connection Issues."
//            }
//        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
        
        // fetches temp in Kelvin so we must subtract 273.15 to get the degrees Celsius
        if let tempInKelvin = json["main"]["temp"].double {
            weatherDataModel.temperature     = Int(tempInKelvin - 273.15)
            weatherDataModel.city            = json["name"].stringValue
            weatherDataModel.condition       = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        } else {
            cityLabel.text = "Weather unavailable"
        }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text        = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image     = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude  = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            // swift 5
            // currently not being used
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            // swift 4.1
            // API parameters need to go into the URL because method in swift 4.1 only accepts the URL
            let urlWithParams = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(APP_ID)"
            
            // with swift 5, just replace urlWithParams with WEATHER_URL
            getWeatherData(url: urlWithParams, parameters: params)
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location currently unavailable"
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func newCityName(city: String) {
        
        // swift 5
        // currently not being used
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        // swift 4.1
        // API parameters need to go into the URL because method in swift 4.1 only accepts the URL
        let urlWithParams = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APP_ID)"
        
        // with swift 5, just replace urlWithParams with WEATHER_URL
        getWeatherData(url: urlWithParams, parameters: params)
    }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
}
