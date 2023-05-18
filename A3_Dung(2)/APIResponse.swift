import Foundation

struct APIResponse:Codable{
    // the class properties represent the properties from the API response
    var weatherLocation:WeatherLocation? = nil
    var weatherCurrent:WeatherCurrent? = nil
    
    // mapping between the name of the property in the API response, and the name of class property
    enum CodingKeys: String, CodingKey {
        case weatherLocation = "location"
        case weatherCurrent = "current"
    }
    
    // implementation of the encode() --> Codable protocol
    func encode(to encoder:Encoder) throws {
    }

    
    init(from decoder:Decoder) throws {
        // 1. try to take the api response and convert it to useable data
        let response = try decoder.container(keyedBy: CodingKeys.self)
        
        // 2. extract the relevant keys from that api response
        self.weatherLocation = try response.decodeIfPresent(WeatherLocation.self, forKey: CodingKeys.weatherLocation) ?? nil
        self.weatherCurrent = try response.decodeIfPresent(WeatherCurrent.self, forKey: CodingKeys.weatherCurrent) ?? nil
    }
}
