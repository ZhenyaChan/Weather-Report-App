import Foundation

class WeatherReport {
    // MARK: class attributes
    var city:String
    var temperature:Double
    var windSpeed:Double
    var windDirection:String
    var date:String
   
    // MARK: initializer
    init(city:String, temperature:Double, windSpeed:Double, windDirection:String, date:String){
        self.city = city
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.date = date
    }
}
