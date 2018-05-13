//
//  StationsCollectionViewController.swift
//  Smart Tree
//
//  Created by Всеволод on 11.05.2018.
//  Copyright © 2018 me4air. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

struct ArduinoData: Decodable {
    var time: String?
    var tem: String?
    var hum: String?
    var water: String?
    var light: String?
    var station_id: String?
    var name: String?
    var image: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        time = try values.decode(String.self, forKey: .time)
        tem = try values.decode(String.self, forKey: .tem)
        hum = try values.decode(String.self, forKey: .hum)
        water = try values.decode(String.self, forKey: .water)
        light = try values.decode(String.self, forKey: .light)
        station_id = try values.decode(String.self, forKey: .station_id)
        name = try values.decode(String.self, forKey: .name)
        image = try values.decode(String.self, forKey: .image)
    }
    
    enum CodingKeys: String, CodingKey {
        case time
        case tem
        case hum
        case water
        case light
        case station_id
        case name
        case image
    }
    
    
}



class StationsCollectionViewController: UICollectionViewController {
    
    var userId = 1
    var arduinoData: [ArduinoData] = []
    var imagesArray: [UIImage] = []
    @IBAction func unwindFromScaner(segue:UIStoryboardSegue) {
        getDataFromServer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
        Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true){_ in
            self.getDataFromServer()
        }
       // getDataFromServer()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arduinoData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StationCollectionViewCell
        /*if arduinoData[indexPath.row].imageData != nil {
            cell.stationImage.image = arduinoData[indexPath.row].imageData
        } else {
            cell.stationImage.image = #imageLiteral(resourceName: "plant_placeholder")
        }*/
        cell.stationImage.loadImageWithURLString(url: arduinoData[indexPath.row].image!)
        cell.stationImage.clipsToBounds = true
        cell.stationLabel.text = arduinoData[indexPath.row].name! + " #" + arduinoData[indexPath.row].station_id!
        cell.stationHum.text = arduinoData[indexPath.row].hum! + " %"
        if ((arduinoData[indexPath.row].tem?.count)!<4){
            cell.stationTemperature.text = arduinoData[indexPath.row].tem! + "°C"} else {
            cell.stationTemperature.text = String((arduinoData[indexPath.row].tem?.prefix(4))! + "°C")
        }
        cell.stationImage.image = UIImage(named: "plant_placeholder")
        if ((arduinoData[indexPath.row].water?.count)!<4){
            cell.stationWater.text = arduinoData[indexPath.row].water! + "%"} else {
            cell.stationWater.text = String((arduinoData[indexPath.row].water?.prefix(4))! + "%")
        }
        if ((arduinoData[indexPath.row].light?.count)!<4){
            cell.stationLight.text = arduinoData[indexPath.row].light! + "%"} else {
            cell.stationLight.text = String((arduinoData[indexPath.row].light?.prefix(4))! + "%")
        }
        cell.stationActivity.layer.cornerRadius = 15
        cell.stationActivity.clipsToBounds = true
        if(arduinoData[indexPath.row].time != nil){
            if ( checkServerActive(date: arduinoData[indexPath.row].time!)){
                cell.stationActivity.text = "ON"
                cell.stationActivity.backgroundColor = UIColor(red: 126/255, green: 248/255, blue: 173/255, alpha: 1.0)
            } else {
                cell.stationActivity.text = "OFF"
                cell.stationActivity.backgroundColor = UIColor(red: 248/255, green: 127/255, blue: 114/255, alpha: 1.0)
            }
        }
    
        // Configure the cell
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    
        return cell
    }
    
    func getDataFromServer() {
        guard let url = URL(string: "http://me4air.fvds.ru/getdatafromserver.php") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "id="+String(userId);
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, erroe) in
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                if let response = response {
                    print(response)
                }
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do{
                        let arduinoData = try JSONDecoder().decode(Array<ArduinoData>.self, from: data)
                        self.arduinoData = arduinoData
                        print(arduinoData)
                        self.collectionView?.reloadData()
                    } catch {
                        print(error)
                    }
                }

            }
            }.resume()
    }
    
    
    
   
    
    func checkServerActive(date: String) -> Bool{
        if (date != ""){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3:00") //Current time zone
        let date = dateFormatter.date(from: date) //according to date format your date string
        if((date?.timeIntervalSinceNow)! * -1 / 60 < 2) {
            return true
            
        }
        else {return false
        }
        }
        else {return false}
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailStation" {
            let dvc = segue.destination as! DetailStationViewController
            if let indexPath = collectionView?.indexPathsForSelectedItems {
                
                if let cell = (collectionView?.cellForItem(at: indexPath[0]) as? StationCollectionViewCell){
                    dvc.label = cell.stationLabel.text!
                    dvc.activity = cell.stationActivity.text!
                    dvc.hum = cell.stationHum.text!
                    dvc.light = cell.stationLight.text!
                    dvc.temp = cell.stationTemperature.text!
                    dvc.water = cell.stationWater.text!
                    dvc.image = cell.stationImage.image!
                    dvc.date = arduinoData[indexPath[0].row].time!
                }
            }
        }
    }
    
   
    


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

let imageCach = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageWithURLString(url: String){
        let url = URL(string: url)
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
        if let imageFromaCash = imageCach.object(forKey: url! as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                self.image = imageFromaCash
                
            }
            return
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            let imageToCahe = UIImage(data: data!)
            imageCach.setObject(imageToCahe!, forKey: url! as AnyObject)
            DispatchQueue.main.async {
                self.image = imageToCahe
            }
            }.resume()
        }
        
    }
    
}
