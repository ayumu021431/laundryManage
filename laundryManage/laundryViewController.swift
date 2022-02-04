//
//  laundryViewController.swift
//  laundryManage
//
//  Created by asora on 2022/01/22.
//

import UIKit
import MBCircularProgressBar
import UserNotifications

class laundryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var countDownButton: UIButton!
    @IBOutlet weak var resetTimer: UIButton!
    
    var timer = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    
    var timeArray: [Int] = Array(0...100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countDownButton.layer.cornerRadius = 45.0
        resetTimer.layer.cornerRadius = 45.0
        timePickerView.delegate = self
        timePickerView.dataSource = self
        minuteLabel.text = "00"
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        resetTimer((Any).self)
        minutes = timeArray[row]
        print(minutes)
        minuteLabel.text = "\(minutes)"
        
        progressView.value = 0
        progressView.maxValue = CGFloat(minutes * 60)
    }
    
    @IBAction func countDownButton(_ sender: UIButton) {
        setUpTimer()
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func setUpTimer() {
        print(secondLabel.text)
        seconds = 0
        if seconds < 10 {
            secondLabel.text = String("0\(seconds)")
        } else {
            secondLabel.text = String(seconds)
        }
        minuteLabel.text = String(minutes)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        progressView.value += 1
        if seconds <= -1{
            minutes -= 1
            seconds = 59
        }
        if minutes <= 0 && seconds <= 0{
            resetTimer((Any).self)
            let content = UNMutableNotificationContent()
            content.title = "laundlyManage"
            content.body = "洗濯が終わりました！"
            content.sound = UNNotificationSound.default

            // 直ぐに通知を表示
            let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }
        if seconds < 10 { //10秒未満だったら、09, 08という風に表示する。
            secondLabel.text = String("0\(seconds)")
        } else {
            secondLabel.text = String(seconds)
        }
        minuteLabel.text = String(minutes)
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        timer.invalidate()
        setUpTimer()
        progressView.value = 0
        progressView.maxValue = CGFloat(minutes * 60)
        minuteLabel.text = "00"
        secondLabel.text = "00"
    }
    
    
    // PickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // PickerView行の数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?  {
        return String(timeArray[row]) + "分"
    }


}
