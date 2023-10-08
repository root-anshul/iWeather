

import Foundation

struct weather_model{
    let conditionid:Int
    let cityName:String
    let temperature:Double
    
    var tempString:String{
        return String(format: "%.1f",temperature)
    }
    
    
    
    var condition_name:String{
        switch conditionid{
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.raim"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    
 
    
    
}




