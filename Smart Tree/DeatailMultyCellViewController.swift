//
//  DeatailMultyCellViewController.swift
//  Smart Tree
//
//  Created by Всеволод on 14.05.2018.
//  Copyright © 2018 me4air. All rights reserved.
//
struct StationDataForCollectionView {
    var data: String
    var image: String
}

struct ModsData: Decodable {
    var mod_id: String?
    var status: String?
    var name: String?
}

import UIKit

class DeatailMultyCellViewController: UIViewController, UICollectionViewDelegate, CellButtonDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var image = UIImage()
    var water = ""
    var hum = ""
    var light = ""
    var temp = ""
    var label = ""
    var activity = ""
    var date = ""
    var stationId = ""
    var modsData: [ModsData] = []
    var userId = ""
    var parsingData : [StationDataForCollectionView] = []
    
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stationActivity: UILabel!
    var serverResponceTimer : Timer?
    
    func startTimer () {
        
        if serverResponceTimer == nil {
            serverResponceTimer =  Timer.scheduledTimer(
                timeInterval: TimeInterval(5.0),
                target      : self,
                selector    : #selector(self.timerAction),
                userInfo    : nil,
                repeats     : true)
        }
    }
    
    @objc func timerAction() {
        self.getDataFromServer()
    }
    
    func stopTimer() {
        serverResponceTimer?.invalidate()
        serverResponceTimer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getModsFromServer()
        collectionView.dataSource = self
        collectionView.delegate = self
        stationLabel.text = label
        imageView.image = image
        stationActivity.text = activity
        if (temp != "ND"){
            parsingData.append(StationDataForCollectionView(data: temp , image: "temperarure"))}
        if (hum != "ND %"){
            parsingData.append(StationDataForCollectionView(data: hum , image: "hum"))}
        if (water != "ND%"){
            parsingData.append(StationDataForCollectionView(data: water, image: "water"))}
        if (light != "ND%"){
            parsingData.append(StationDataForCollectionView(data: light , image: "light"))}
        if checkServerActive(date: date){
            stationActivity.text = "ON"
            stationActivity.backgroundColor = UIColor(red: 126/255, green: 248/255, blue: 173/255, alpha: 1.0)
        } else {
            stationActivity.text = "OFF"
            stationActivity.backgroundColor = UIColor(red: 248/255, green: 127/255, blue: 114/255, alpha: 1.0)
        }
        stationActivity.layer.cornerRadius = 15
        stationActivity.clipsToBounds = true
        stationActivity.layer.borderWidth = 2.0
        stationActivity.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        startTimer()
        /* Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true){_ in
            self.getDataFromServer()
        }*/
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
        return parsingData.count }
        return modsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "modCell", for: indexPath) as! ModCollectionViewCell
            cell.modButton.layer.cornerRadius = 15
            cell.modButton.clipsToBounds = true
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.delegate = self
            cell.indexPath = indexPath
            cell.modLabel.text = modsData[indexPath.row].name
            cell.mod_id = modsData[indexPath.row].mod_id
            if (modsData[indexPath.row].status == "send_on" || modsData[indexPath.row].status == "get_on") {
                cell.modButton.backgroundColor = UIColor(red: 224/255, green: 68/255, blue: 98/255, alpha: 1.0)
                cell.modButton.setTitle("Выключить", for: .normal)
                cell.status = "send_off"
            } else {
            if (modsData[indexPath.row].status == "send_off" || modsData[indexPath.row].status == "get_off") {
                cell.modButton.backgroundColor = UIColor(red: 62/255, green: 224/255, blue: 114/255, alpha: 1.0)
                cell.modButton.setTitle("Включить", for: .normal)
                cell.status = "send_on"
                } }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "datchikCell", for: indexPath) as! DatchikCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.datchikData.text = parsingData[indexPath.row].data
        cell.datchikImage.image = UIImage(named: parsingData[indexPath.row].image)
        return cell
    }
    
    func modButtonPresed(at index: IndexPath, modId: String, status: String) {
        print (index.row)
        sendButtonPresed(status: status, mod: modId)
        modsData[index.row].status = status
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeder = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "heder", for: indexPath) as! HeaderCollectionReusableView
        
        if indexPath.section == 0 {
            sectionHeder.headerLabel.text = "Данные со станции"
        }
        if indexPath.section == 1 {
            sectionHeder.headerLabel.text = "Управление станцией"
        }
        return sectionHeder
    }
    
    func sendButtonPresed(status: String, mod: String) {
        guard let url = URL(string: "http://me4air.fvds.ru/comandsapi.php") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "mod="+mod+"&station_id="+stationId+"&sender=IOS&status="+status;
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, erroe) in
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                if let response = response {
                    print(response)
                }
            }
            }.resume()
    }
    
    func getModsFromServer() {
        guard let url = URL(string: "http://me4air.fvds.ru/getmodsapi.php") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "station_id="+stationId;
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
                        let modsData = try JSONDecoder().decode(Array<ModsData>.self, from: data)
                        self.modsData = modsData
                        print(modsData)
                        self.collectionView?.reloadData()
                    } catch {
                        print(error)
                    }
                }
                
            }
            }.resume()
    }
    
    
    func getDataFromServer() {
        guard let url = URL(string: "http://me4air.fvds.ru/getdetaildata.php") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "station_id="+stationId;
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
                        self.parsingData = []
                        if (arduinoData[0].tem != "ND"){
                            let tem = arduinoData[0].tem! + "°C"
                            self.parsingData.append(StationDataForCollectionView(data: tem , image: "temperarure"))}
                        if (arduinoData[0].hum != "ND"){
                            var hum = arduinoData[0].hum!
                            if (hum.count > 4) {
                                hum = String(hum.prefix(4))
                            }
                            hum = hum + " %"
                            self.parsingData.append(StationDataForCollectionView(data: hum , image: "hum"))}
                        if (arduinoData[0].water != "ND"){
                            var water = arduinoData[0].water!
                            if (water.count > 4) {
                                water = String(water.prefix(4))
                            }
                            water = water + "%"
                            self.parsingData.append(StationDataForCollectionView(data: water, image: "water"))}
                        if (arduinoData[0].light != "ND"){
                            var light = arduinoData[0].light!
                            if (light.count > 4) {
                                light = String(light.prefix(4))
                            }
                            light = light + "%"
                            self.parsingData.append(StationDataForCollectionView(data: light , image: "light"))}
                        print(arduinoData)
                        self.date = arduinoData[0].time!
                        self.collectionView?.reloadData()
                    } catch {
                        print(error)
                    }
                }
                
            }
            }.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func checkServerActive(date: String) -> Bool{
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
}

