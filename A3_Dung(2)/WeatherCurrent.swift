import Foundation

struct WeatherCurrent:Codable{
    // the class properties represent the properties from the API response
    var temperature:Double = 0.0
    var windSpeed:Double = 0.0
    var windDirection:String = ""
    
    
    // mapping between the name of the property in the API response, and the name of class property
    enum CodingKeys: String, CodingKey {
        case temperature = "feelslike_c"
        case windSpeed = "wind_kph"
        case windDirection = "wind_dir"
    }
    
    // implementation of the encode() --> Codable protocol
    func encode(to encoder:Encoder) throws {
    }
    
    
    init(from decoder:Decoder) throws {
        // 1. try to take the api response and convert it to useable data 
        let response = try decoder.container(keyedBy: CodingKeys.self)
        
        // 2. extract the relevant keys from that api response
        self.temperature = try response.decodeIfPresent(Double.self, forKey: CodingKeys.temperature) ?? 0.0
        self.windSpeed = try response.decodeIfPresent(Double.self, forKey: CodingKeys.windSpeed) ?? 0.0
        self.windDirection = try response.decodeIfPresent(String.self, forKey: CodingKeys.windDirection) ?? "N/A"
    }
}
