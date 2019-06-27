import UIKit
import RealmSwift

var selectedCount: Int!

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    
    var CountArray:Results<CountModel>!
    @IBOutlet var countTextField: UITextField!
    @IBOutlet var memoTextField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CountArray = realm.objects(CountModel.self).sorted(byKeyPath: "today", ascending: true)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
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
        
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil),forCellReuseIdentifier: "historyCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // セクションごとにデータ要素数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CountArray.count
    }
    
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*// セクションヘッダ
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
     return sectionName[section]
     }*/
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    // セル生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        cell.memoLabel!.text = CountArray[indexPath.row].memo
        cell.countLabel!.text = String(CountArray[indexPath.row].count)
        
        return cell
    }
    
    /*// セクションヘッダの高さ
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 50
     }*/
    
    //セル削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(CountArray[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    //選択された日付の買い物を次の画面で表示
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // タップされたセルの行番号を出力
        selectedCount=indexPath.row
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 別の画面に遷移
        performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    
    @objc func done() {
        dateField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    @IBAction func add(){
        if dateField.text != "" {
            if memoTextField.text != ""{

                let count = CountModel()
                count.id = CountArray.count
                count.today = dateField.text!
                count.count = Int(countTextField.text!)!
                count.memo = memoTextField.text!
                count.balance = true
                
                //Answerモデルの登録
                try! realm.write {
                    realm.add(count)
                }
                dateField.text = ""
                memoTextField.text = ""
                countTextField.text = ""
                
            }
        }
        self.tableView.reloadData()
    }
    
    
    
    
}
