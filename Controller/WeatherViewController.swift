
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
  
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchtextfield: UITextField!
    
    var weather = weather_manager()
    let locationmanager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.requestLocation()
        
       
        weather.delegate = self
        searchtextfield.delegate = self
        
        
    }
    
    @IBAction func locationpressed(_ sender: Any) {
        locationmanager.requestLocation()
    }
    
    
    
}

//MARK: -UITextFieldDelegate



extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchpressed(_ sender: Any) {
        searchtextfield.endEditing(true)
        print(searchtextfield.text!)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchtextfield.endEditing(true)
        print(searchtextfield.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else{
            textField.placeholder = "Type Somethng"
            return false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchtextfield.text{
            weather.fetchweather(cityName: city)
        }
        searchtextfield.text = ""
    }
}


//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func updateweather(_ weatherManager: weather_manager, weather: weather_model){
        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.tempString
            self.conditionImageView.image = UIImage(systemName: weather.condition_name)
            self.cityLabel.text = weather.cityName
        }
    }
    func didfailwitherror(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationmanager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weather.fetchweather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}


