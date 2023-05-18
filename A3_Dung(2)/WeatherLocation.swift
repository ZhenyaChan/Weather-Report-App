import Foundation

struct WeatherLocation:Codable{
    
    // the class properties represent the properties from the API response
    var city:String = ""
    
    // mapping between the property in the API response, and the name of class property
    enum CodingKeys: String, CodingKey {
        case city = "name"
    }
    
    // implementation of the encode() --> Codable protocol
    func encode(to encoder:Encoder) throws {
    }
    
    
    init(from decoder:Decoder) throws {
        // 1. try to take the api response and convert it to useable data
        let response = try decoder.container(keyedBy: CodingKeys.self)
        
        // 2. extract the relevant keys from that api response
        self.city = try response.decodeIfPresent(String.self, forKey: CodingKeys.city) ?? "N/A"
    }
}
