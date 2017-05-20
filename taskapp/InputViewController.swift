//
//  InputViewController.swift
//  taskapp
//
//  Created by Masashi Motohashi on 2017/05/13.
//  Copyright © 2017 masashi.motohashi. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var task: Task!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismisKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date as Date
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date as NSDate
            self.realm.add(self.task, update: true)
        }
        
        setNotification(task: task)
        super.viewWillDisappear(animated)
    }
    
    func setNotification(task: task){
        let content = UNMutableNotificationContent()
        content.tile = task.title
        content.body = task.contents
        content.sound = UNNotificationSound.default()
    
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date as Date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        let request = UNNotoficationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) {(error) in
            print(error)
        }
        
        center.getPendingNotificationRequests {(requests: [UNNotificationRequest]) in
            for request in requests {
                print ("/----------")
                print (request)
                print ("----------/")
            }
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
}
