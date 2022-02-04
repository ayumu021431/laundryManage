//
//  weatherViewController.swift
//  laundryManage
//
//  Created by asora on 2022/01/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class weatherViewController: UIViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var todayWeatherLabel: UILabel!
    @IBOutlet weak var todayHighTempLabel: UILabel!
    @IBOutlet weak var todayLowTempLabel: UILabel!
    
    @IBOutlet weak var chanceOfRain0to6Label: UILabel!
    @IBOutlet weak var chanceOfRain6to12Label: UILabel!
    @IBOutlet weak var chanceOfRain12to18Label: UILabel!
    @IBOutlet weak var chanceOfRain18to24Label: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    //取得した天気予報のデータを入れる
    var city:String = ""
    var date:String = ""
    var weather:String = ""
    var high:String = ""
    var low:String = ""
    var Rain0to6:String = ""
    var Rain6to12:String = ""
    var Rain12to18:String = ""
    var Rain18to24:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chanceOfRain0to6Label.text = ""
        chanceOfRain6to12Label.text = ""
        chanceOfRain12to18Label.text = ""
        chanceOfRain18to24Label.text = ""
        
        getWeatherData(row: 0)
        
    }
    
    private func getWeatherData(row: Int) {
        let url = "http://weather.tsukumijima.net/api/forecast/city/280010"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {(response) in
            switch response.result {
                case .success:
                //jsonを取得します。
                let json:JSON = JSON(response.data as Any)

                //取得したjsonから、必要なデータを取り出す
                let city = json["title"].string
                let date = json["forecasts"][row]["date"].string
                let weather = json["forecasts"][row]["telop"].string
                let high = json["forecasts"][row]["temperature"]["max"]["celsius"].string
                let low = json["forecasts"][row]["temperature"]["min"]["celsius"].string
                let Rain0to6 = json["forecasts"][row]["chanceOfRain"]["T00_06"].string
                let Rain6to12 = json["forecasts"][row]["chanceOfRain"]["T06_12"].string
                let Rain12to18 = json["forecasts"][row]["chanceOfRain"]["T12_18"].string
                let Rain18to24 = json["forecasts"][row]["chanceOfRain"]["T18_24"].string
                
                if city != nil {
                    self.city = city!
                } else {
                    self.city = "--"
                }
                
                if date != nil {
                    self.date = String(date!.suffix(5))  //2022-04-10 -> 04-10
                } else {
                    self.date = "--"
                }

                if weather != nil {
                    self.weather = weather!
                } else {
                    self.weather = "--"
                }
                
                if high != nil {
                    self.high = "\(high!)°C"
                } else {
                    self.high = "--°C"
                }
                
                if low != nil {
                    self.low = "\(low!)°C"
                } else {
                    self.low = "--°C"
                }
                
                if Rain0to6 != nil {
                    self.Rain0to6 = "\(Rain0to6!)"
                } else {
                    self.Rain0to6 = "--%"
                }
                if Rain6to12 != nil {
                    self.Rain6to12 = "\(Rain6to12!)"
                } else {
                    self.Rain6to12 = "--%"
                }
                if Rain12to18 != nil {
                    self.Rain12to18 = "\(Rain12to18!)"
                } else {
                    self.Rain12to18 = "--%"
                }
                if Rain18to24 != nil {
                    self.Rain18to24 = "\(Rain18to24!)"
                } else {
                    self.Rain18to24 = "--%"
                }

                //ラベルに反映させる
                self.setWeatherData(row: row)
            
            case .failure(let error):
                print("-------- エラー ------")
                print(error)
            }
        }
    }
    
    private func setWeatherData(row: Int) {
        cityNameLabel.text = city
        todayWeatherLabel.text = weather
        todayDateLabel.text = date
        todayHighTempLabel.text = high
        todayLowTempLabel.text = low
        chanceOfRain0to6Label.text = Rain0to6
        chanceOfRain6to12Label.text = Rain6to12
        chanceOfRain12to18Label.text = Rain12to18
        chanceOfRain18to24Label.text = Rain18to24
        
        if weather == "晴れ" {
            weatherImageView.image = UIImage(named: "晴れ")
        } else if weather == "雨" {
            weatherImageView.image = UIImage(named: "雨")
        } else if weather == "曇り" {
            weatherImageView.image = UIImage(named: "曇り")
        } else if weather == "晴時々曇" || weather == "曇時々晴" || weather == "晴のち時々曇"{
            weatherImageView.image = UIImage(named: "曇り晴れ")
        } else if weather == "晴時々雨" {
            weatherImageView.image = UIImage(named: "晴れ雨")
        } else if weather == "雨時々晴" {
            weatherImageView.image = UIImage(named: "雨晴れ")
        } else if weather == "曇時々雨" || weather == "雨時々曇"{
            weatherImageView.image = UIImage(named: "曇り雨")
        } else if weather == "雪" {
            weatherImageView.image = UIImage(named: "雪")
        }
        
    }
}
