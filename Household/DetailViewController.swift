//
//  DetailViewController.swift
//  Household
//
//  Created by 林香穂 on 2019/06/27.
//  Copyright © 2019 林香穂. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {

    let realm = try! Realm()
    
    var CountArray:Results<CountModel>!
    @IBOutlet var countTextField: UITextField!
    @IBOutlet var memoTextField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    var datePicker: UIDatePicker = UIDatePicker()
    
    var count = CountModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        dateField.inputView = datePicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定(紐づいているUITextfieldへ代入)
        dateField.inputView = datePicker
        dateField.inputAccessoryView = toolbar
        
        CountArray = realm.objects(CountModel.self).sorted(byKeyPath: "today", ascending: true)
        count = CountArray[selectedCount]
        
        countTextField!.text = String(CountArray[selectedCount].count)
        memoTextField!.text = CountArray[selectedCount].memo
        dateField!.text = CountArray[selectedCount].today
        // Do any additional setup after loading the view.
    }
    
    @objc func done() {
        dateField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    @IBAction func save(){
        try! realm.write {
            count.count = Int(countTextField.text!)!
            count.memo = memoTextField.text!
            count.today = dateField.text!
        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func del() {
        try! realm.write {
            realm.delete(CountArray[selectedCount])
        }
        self.navigationController?.popViewController(animated: true)
    }
}
