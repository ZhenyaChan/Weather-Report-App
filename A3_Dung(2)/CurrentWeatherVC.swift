import MapKit
import CoreLocation
import UIKit


class CurrentWeatherVC: UIViewController, CLLocationManagerDelegate {
    
    // MARK: properies
    var locationManager:CLLocationManager!
    let geocoder:CLGeocoder = CLGeocoder()
    var currentWeatherReport:WeatherReport!
    
    // MARK: outlets
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblWindDirection: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure the location manager:
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }

    
    // MARK: functions
    // location manager function that automatically executes anytime the app receives a new location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastKnownLocation:CLLocation = locations.first {
            // receiving the device location coordinates, printing the coordinates to the console
            print("Location update received: \(lastKnownLocation.coordinate.latitude), \(lastKnownLocation.coordinate.longitude)")
            
            print("Attempting to reverse geocode....")
            // creating CLLocation object using received location coordinates
            let locationToGeocode = CLLocation(latitude: lastKnownLocation.coordinate.latitude, longitude: lastKnownLocation.coordinate.longitude)
            // using geocoder object's function to convert coordinates to human-readable address and extracting city name from the address data
            geocoder.reverseGeocodeLocation(locationToGeocode) {
                (resultsList, error) in
                if (error != nil) {
                    print("Error occurred when connecting to geocoding service")
                    print(error ?? "")
                    return
                } else {
                    if (resultsList!.isEmpty) {
                        print("Unable to find address")
                    }
                    else {
                        let placemark = resultsList!.first
                        print("City Found: \(placemark?.locality! ?? "City Not Found")")
                        
                        if let placemark = placemark {
                            //self.lblCity.text = "City: \(placemark.locality!)"
                            let city:String = "\(placemark.locality!)"
                            
                            // inject city name string into api url and connect to api
                            let apiEndpoint = "https://api.weatherapi.com/v1/current.json?key=a61a5ac25ca64462899161221222011&q=\(city)&aqi=no"
                            
                            // convert this string into a URL object
                            guard let apiURL = URL(string:apiEndpoint) else {
                                print("Could not convert the string endpoint to an URL object")
                                return
                            }
                            
                            // function runs in the background
                            URLSession.shared.dataTask(with: apiURL) {
                                (data, response, error) in
                                
                                if let err = error {
                                    print("Error occurred while fetching data from api")
                                    print(err)
                                    return
                                }
                                // decoding the JSON data received from API response
                                if let jsonData = data {
                                    print(jsonData)
                                    do {
                                        let decoder = JSONDecoder()
                                        let decodedItem:APIResponse = try decoder.decode(APIResponse.self, from: jsonData)
                                        
                                        DispatchQueue.main.async {
                                            // display the data to UI
                                            self.lblCity.text = "City: \(decodedItem.weatherLocation?.city ?? "N/A")"
                                            self.lblTemperature.text = "Temperature: \(decodedItem.weatherCurrent?.temperature ?? 0.0)"
                                            self.lblWindSpeed.text = "Wind Speed: \(decodedItem.weatherCurrent?.windSpeed ?? 0.0)"
                                            self.lblWindDirection.text = "Wind Direction: \(decodedItem.weatherCurrent?.windDirection ?? "")"
                                            self.lblDate.text = "Date: \(self.getDate())"
                                            
                                            // creating new WeatherReport object using the received data from API
                                            self.currentWeatherReport = WeatherReport(city: decodedItem.weatherLocation?.city ?? "N/A", temperature: decodedItem.weatherCurrent?.temperature ?? 0.0, windSpeed: decodedItem.weatherCurrent?.windSpeed ?? 0.0, windDirection: decodedItem.weatherCurrent?.windDirection ?? "", date: self.getDate())
                                            print(decodedItem)
                                        }
                                    } catch let error {
                                        print("An error occured during JSON decoding")
                                        print(error)
                                    }
                                }
                            }.resume()
                        }
                    }
                }
            }

        }
    }
    
    //using swift built-in Date() and DateFormatter() objects to return the current time and date
    func getDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    

    // MARK: actions
    @IBAction func saveReportBtnPressed(_ sender: Any) {
        // adding the current weather report to the list of weatherReport objects in singleton class.
        Datasource.shared.weatherReportsList.append(currentWeatherReport)
        print("\(Datasource.shared.weatherReportsList[Datasource.shared.weatherReportsList.count-1].city) is saved!")
    }
}

