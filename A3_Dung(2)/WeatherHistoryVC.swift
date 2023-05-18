import UIKit


class WeatherHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: outlets
    @IBOutlet weak var weatherReportsTableView: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    
    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherReportsTableView.delegate = self
        self.weatherReportsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // reload the table to display updated data
        self.weatherReportsTableView.reloadData()
        
        // display appropriate message based on the total paid
        if (Datasource.shared.weatherReportsList.count > 0) {
            self.lblMessage.text = ""
        } else {
            self.lblMessage.text = "Error: No Weather Reports Saved!"
        }
    }
    
    
    // MARK: tableview functions
    // total number of items to display in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Datasource.shared.weatherReportsList.count
    }
    
    // content that is displayed in each row of the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // getting the cell from tablview as a custom created WeatherReportTableViewCell
        let cell = weatherReportsTableView.dequeueReusableCell(withIdentifier: "weatherReportCell", for: indexPath) as! WeatherReportTableViewCell
        // getting the weather report based on the indexrow id from weather reports list
        let currentWeatherReport:WeatherReport = Datasource.shared.weatherReportsList[indexPath.row]
        
        // finding the range of the time substring inside of the date string
        let start = currentWeatherReport.date.index(currentWeatherReport.date.startIndex, offsetBy: 11)
        let end = currentWeatherReport.date.index(currentWeatherReport.date.endIndex, offsetBy: -3)
        let range = start..<end
        
        // display the weather report on UI
        cell.lblTemperature.text = "\(Int(currentWeatherReport.temperature)) °C"
        cell.lblCityAndDate.text = "\(currentWeatherReport.city) at \(currentWeatherReport.date[range]) on \(currentWeatherReport.date.prefix(10))"
        cell.lblWind.text = "Wind: \(Int(currentWeatherReport.windSpeed)) kph from \(currentWeatherReport.windDirection)"
        
        return cell
    }
    
    // deleting existing reservations
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // output to the console
            print("User wants to delete the weather report number \(indexPath.row) for: \(Datasource.shared.weatherReportsList[indexPath.row].city)")
            
            // delete the selected item from the data source array (weather reports list)
            Datasource.shared.weatherReportsList.remove(at: indexPath.row)
            print("Updated number of reservations in the list: \(Datasource.shared.weatherReportsList.count)")
            
            // update the message in case the weather reports list is empty
            if (Datasource.shared.weatherReportsList.count > 0) {
                lblMessage.text = ""
            } else {
                // No reservations on the list
                lblMessage.text = "Error: No Reservations Made"
            }
            
            // delete the selected weather report from the tableview UI
            weatherReportsTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}
