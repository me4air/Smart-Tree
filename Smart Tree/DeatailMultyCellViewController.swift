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

import UIKit

class DeatailMultyCellViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var image = UIImage()
    var water = ""
    var hum = ""
    var light = ""
    var temp = ""
    var label = ""
    var activity = ""
    var date = ""
    
    var parsingData : [StationDataForCollectionView] = []
    
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stationActivity: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        stationLabel.text = label
        imageView.image = image
        stationActivity.text = activity
        parsingData.append(StationDataForCollectionView(data: temp, image: "temperarure"))
        parsingData.append(StationDataForCollectionView(data: hum, image: "hum"))
        parsingData.append(StationDataForCollectionView(data: water, image: "water"))
        parsingData.append(StationDataForCollectionView(data: light, image: "light"))
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
        // Do any additional setup after loading the view.
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
        return 4 }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "modCell", for: indexPath) as! ModCollectionViewCell
            cell.modButton.layer.cornerRadius = 15
            cell.modButton.clipsToBounds = true
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            return cell }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "datchikCell", for: indexPath) as! DatchikCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.datchikData.text = parsingData[indexPath.row].data
        cell.datchikImage.image = UIImage(named: parsingData[indexPath.row].image)
        return cell
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

