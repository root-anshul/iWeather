
import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func updateweather(_ weatherManager: weather_manager, weather: weather_model)
    func didfailwitherror(error:Error)
}


struct weather_manager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=5aa2383a6e64bc76116666409e8dd09b&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchweather(cityName:String){
        let url="\(weatherURL)&q=\(cityName)"
        perform_request(url:url)
    }
    
    func fetchweather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let url = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        perform_request(url: url)
    }
    

    func perform_request(url:String){
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didfailwitherror(error: error!)
                    return
                }
                
                if let safedata = data {
                    if let weather = self.parseJSON(weatherdata: safedata){
                        self.delegate?.updateweather(self, weather: weather)
                        }
                }
            }
            
            task.resume()
        }
    }
    func parseJSON(weatherdata: Data)-> weather_model?{
        let decoder = JSONDecoder()
        do{
           let decoded_data = try decoder.decode(weather_data.self, from: weatherdata)
          
            let id = decoded_data.weather[0].id
            let temp = decoded_data.main.temp
            let name = decoded_data.name
            
            let weather = weather_model(conditionid: id, cityName: name, temperature: temp)
            return weather
            
        } catch{
            delegate?.didfailwitherror(error: error)
            return nil
        }
    }
   
    
}
