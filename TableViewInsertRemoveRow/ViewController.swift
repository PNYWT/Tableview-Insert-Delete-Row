//
//  ViewController.swift
//  TableViewInsertRemoveRow
//
//  Created by CallmeOni on 29/8/2566 BE.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var insertBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var tbvShow: UITableView!
    private var arrUUID:[String] = []
    
    var timerRemove:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeData()
        setBtn()
        setupTable()
    }
    
    //MARK: makeData
    private func makeData(){
        for _ in stride(from: 0, to: 5, by: 1){
            arrUUID.append(UUID().uuidString)
        }
    }
    
    //MARK: setupTable
    private func setupTable(){
        tbvShow.dataSource = self
        tbvShow.delegate = self
        tbvShow.register(UINib(nibName: "TableShowViewCell", bundle: nil), forCellReuseIdentifier: "ShowViewCell")
    }
    
    //MARK: setBtn
    private func setBtn(){
        insertBtn.setTitle("Insert", for: .normal)
        insertBtn.backgroundColor = .blue
        insertBtn.setTitleColor(.white, for: .normal)
        insertBtn.layer.cornerRadius = insertBtn.frame.height/2
        insertBtn.layer.masksToBounds = true
        insertBtn.addTarget(self, action: #selector(actionAdd), for: .touchUpInside)
        
        
        removeBtn.setTitle("Delete", for: .normal)
        removeBtn.backgroundColor = .red
        removeBtn.setTitleColor(.white, for: .normal)
        removeBtn.layer.cornerRadius = insertBtn.frame.height/2
        removeBtn.layer.masksToBounds = true
        removeBtn.addTarget(self, action: #selector(actionRemove), for: .touchUpInside)
    }
    
    //MARK: actionAdd
    @objc func actionAdd(){
        let random = arrUUID.count == 0 ? 0:arrUUID.count
        var index = 0
        if random != 0{
            index = Int.random(in: 0..<random)
        }
        self.tbvShow.beginUpdates()
        self.arrUUID.insert(UUID().uuidString, at: index)
        self.tbvShow.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
//        self.tbvShow.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        self.tbvShow.endUpdates()
        self.tbvShow.reloadData()
        
        if timerRemove == nil{
            setupTimer()
        }
    }
    
    //MARK: actionRemove
    @objc func actionRemove(){
        let alert = UIAlertController(title: nil, message: "Input Index to Remove", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Input Index"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let textAlert = alert.textFields?[0], let text = textAlert.text else{
                return
            }
            if let index = Int(text), index <= self.arrUUID.count {
                self.tbvShow.beginUpdates()
                self.arrUUID.remove(at: index)
                self.tbvShow.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.tbvShow.endUpdates()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    //MARK: Special content Remove by Timer
    func setupTimer(){
        print("Start Timer")
        timerRemove?.invalidate()
        timerRemove = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerActionRemove), userInfo: nil, repeats: true)
    }
    
    @objc func timerActionRemove(){
        if self.arrUUID.count > 0 {
            let lastIndexPath = IndexPath(row: self.arrUUID.count - 1, section: 0)
            self.tbvShow.beginUpdates()
            self.arrUUID.remove(at: self.arrUUID.count - 1)
            self.tbvShow.deleteRows(at: [lastIndexPath], with: .fade)
            self.tbvShow.endUpdates()
        }else{
            print("Stop Timer")
            timerRemove?.invalidate()
            timerRemove = nil
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUUID.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowViewCell") as! TableShowViewCell
        cell.lbUUID.text = String(format: "Index :%d\nUUID: %@", indexPath.row,arrUUID[indexPath.row])
        cell.lbUUID.numberOfLines = 2
        cell.lbUUID.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didselectIndex -> \(indexPath.row)")
    }
}

