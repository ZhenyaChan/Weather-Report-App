import Foundation

// singleton class
class Datasource {
    static let shared = Datasource()
    private init() {}
    
    // saved weather reports list
    var weatherReportsList:[WeatherReport] = []
}
