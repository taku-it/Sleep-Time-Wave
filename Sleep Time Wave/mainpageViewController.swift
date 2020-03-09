//
//  setteikakuninnViewController.swift
//  Sleep Time Wave
//
//  Created by 生田拓登 on 2020/01/12.
//  Copyright © 2020 IkutaTakuto. All rights reserved.
//

import UIKit
import AVFoundation

class mainpageViewController: UIViewController, UITabBarDelegate{
    var audioPlayerInstance : AVAudioPlayer! = nil
    
    var sleepTime: Int!
    let saveData: UserDefaults = UserDefaults.standard
    var wakeTime: Date!
    @IBOutlet var timeLabel: UILabel!
    var age: Int!
    let formatter = DateFormatter()
    let firstVC = UIViewController()
    var name: String!
    @IBOutlet var osiraseLabel: UILabel!
    var countNum = 0
    @IBOutlet var sleepButton: UIButton!
    var bedtime: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wakeTime = saveData.object(forKey: "wakeTimeKey") as? Date
        //waketime = saveData.object(forKey: "wakeTimeKey") as! String
        sleepButton.setTitle("寝る", for: .normal)
        osiraseLabel.text = "この時間に寝ましょう"
        age = saveData.object(forKey: "AgeKey") as! Int
        sleepButton.layer.cornerRadius = 10
        countNum += 1
        hantei(age: age)
        countHantei()
        sleepButton.setTitle("寝る", for: .normal)
        osiraseLabel.text = "この時間に寝ましょう"
        tuuti(sleeptime: bedtime)
        
        let soundFilePath = Bundle.main.path(forResource: "chicken-cry1", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        // AVAudioPlayerのインスタンスを作成,ファイルの読み込み
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint: nil)
        } catch {
            print("エラー")
        }
        // 再生準備
        audioPlayerInstance.prepareToPlay()
        
    }
    
    @IBAction func neru() {
        countNum += 1
        countHantei()
        if countNum % 2 != 0{
            audioPlayerInstance.play()
        }
    }
    
    func hantei(age: Int){
        
        switch age {
        case (1...2):
            bedtime = SleepTime(wakeTime: wakeTime, sleepingTime: 13)
            
            timeLabel.text = dateformat(sleepTime: bedtime)
        case (3...5):
            bedtime = SleepTime(wakeTime: wakeTime, sleepingTime: 11)
            timeLabel.text = dateformat(sleepTime: bedtime)
        case (6...13):
            bedtime = SleepTime(wakeTime: wakeTime, sleepingTime: 10)
            timeLabel.text = dateformat(sleepTime: bedtime)
        case (14...17):
            bedtime = SleepTime(wakeTime: wakeTime, sleepingTime: 9)
            timeLabel.text = dateformat(sleepTime: bedtime)
        case (18...25):
            bedtime = SleepTime(wakeTime: wakeTime, sleepingTime: 8)
            timeLabel.text = dateformat(sleepTime: bedtime)
        case (26...64):
            bedtime = SleepTime(wakeTime: wakeTime, sleepingTime: 8)
            timeLabel.text = dateformat(sleepTime: bedtime)
        case (65...130):
            bedtime = SleepTime(wakeTime: wakeTime, sleepingTime: 7)
            timeLabel.text = dateformat(sleepTime: bedtime)
        default:  timeLabel.text = String("error")
            break
        }
    }
    func SleepTime(wakeTime: Date, sleepingTime: Int) -> Date {
        let  sleepTime = Calendar.current.date(byAdding: .hour,value: -1 * sleepingTime,to: wakeTime)
        return sleepTime!
    }
    
    func dateformat(sleepTime: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm";
        return dateFormatter.string(from: sleepTime)
    }
    func WakeTime(waketime: Date) -> String{
        let wakeTime = DateFormatter()
        wakeTime.dateFormat = "H:mm";
        return wakeTime.string(from: waketime)
    }
    //    ボタンの押された回数を判定
    func countHantei(){
        if countNum % 2 != 0{
            sleepButton.setTitle("寝る", for: .normal)
            osiraseLabel.text = "この時間に寝ましょう"
            hantei(age: age)
        }else if countNum % 2 == 0{
            osiraseLabel.text = "この時間に起きましょう"
            sleepButton.setTitle("起きる", for: .normal)
            timeLabel.text = String(WakeTime(waketime: wakeTime))
        }
        if countNum > 4{
            countNum *= 0
            countNum += 1
        }
    }
    //    通知メソッド
    func tuuti(sleeptime: Date){
        if countNum % 2 != 0{
            let content = UNMutableNotificationContent()
            content.title = "もうすぐ寝る時間です。"
            content.body = "アラームを\(WakeTime(waketime: wakeTime)) に設定しよう！"
            
            let date = Calendar.current.date(byAdding: .minute, value: -30, to: sleeptime)
            let comp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute ], from: date!)
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: comp, repeats:  true)
            
            let request = UNNotificationRequest(identifier: "CalendarNotification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }else if countNum % 2 == 0{
         let content = UNMutableNotificationContent()
            content.title = "おはようございます！"
            content.body = "今日も頑張りましょう！"
            let wakecomp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute ], from: wakeTime)
            let secondTrigger = UNCalendarNotificationTrigger.init(dateMatching: wakecomp, repeats: true)
             let secondrequest = UNNotificationRequest(identifier: "CalendarNotification", content: content, trigger: secondTrigger)
             UNUserNotificationCenter.current().add(secondrequest, withCompletionHandler: nil)
        }
        

}
}
