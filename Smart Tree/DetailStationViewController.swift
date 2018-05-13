//
//  DetailStationViewController.swift
//  Smart Tree
//
//  Created by Всеволод on 12.05.2018.
//  Copyright © 2018 me4air. All rights reserved.
//

import UIKit

class DetailStationViewController: UIViewController {
    
    var image = UIImage()
    var water = ""
    var hum = ""
    var light = ""
    var temp = ""
    var label = ""
    var activity = ""
    var date = ""
    @IBOutlet weak var stationImage: UIImageView!
    @IBOutlet weak var stationWater: UILabel!
    @IBOutlet weak var stationHum: UILabel!
    @IBOutlet weak var stationLight: UILabel!
    @IBOutlet weak var stationTemp: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var stationActivity: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        stationImage.image = image
        stationWater.text = water
        stationHum.text = hum
        stationLight.text = temp
        stationLabel.text = label
        stationActivity.text = activity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if checkServerActive(date: date){
           stationActivity.text = "ON"
           stationActivity.backgroundColor = UIColor(red: 126/255, green: 248/255, blue: 173/255, alpha: 1.0)
        } else {
            stationActivity.text = "OFF"
            stationActivity.backgroundColor = UIColor(red: 248/255, green: 127/255, blue: 114/255, alpha: 1.0)
        }
        stationActivity.layer.cornerRadius = 15
        stationActivity.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
