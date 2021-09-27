//
//  ViewController.swift
//  Task2：To-do list
//
//  Created by Jhen Mu on 2021/7/23.
//

import UIKit

class ViewController: UIViewController{
    //MARK:-Properties
    let myView : MyView = .init()
    lazy var tableView : UITableView = myView.theTableView

    var info = [String]() {
        didSet {
            saveData() //只要info更新後，這裡就會自動儲存，像是響應一樣。
            tableView.reloadData()//表格也會隨著info的更新而更新表格的內容
        }
        
    }
    

    //MARK:-LifeCycle
    override func loadView(){
        super.loadView()
        view = myView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        setTableView()
    }
    
    //MARK:-setUpTableView
    func setTableView() {
        myView.theTableView.dataSource = self
        myView.theTableView.delegate = self
    }
    //MARK:-Methods for loading
    //點擊createButton後會產生一個新的cell，並跳出鍵盤以供編輯
    @objc func create(){
        textFieldAlert(title: "Input the word", message: nil, text: nil) { string in
            self.info.append(string)
        }
    }
    //MARK:-UserDefault
    //儲存資料
    let userDefault = UserDefaults()
    func saveData(){
        UserDefaults.standard.set(self.info, forKey: "someItem")//設定要儲存的值與鍵
    }
    //讀取資料
    func readData(){
        info = UserDefaults.standard.stringArray(forKey: "someItem") ?? [] //取出資料，且轉為String
    }
    //MARK:-TableViewEditAndDelete
    //點選到table的時候，就會跳出點擊框
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = info[indexPath.row]
        textFieldAlert(title: "Edit this field", text: text) { string in
            self.info[indexPath.row] = string
        }
    }
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //修改鍵
        let editAction = UITableViewRowAction(style: .default, title: "Edit") {
        // 按下 Edit 之後要執行的動作
            (editAction: UITableViewRowAction, indexPath: IndexPath) in
            self.textFieldAlert(title: "Edit this Field",text: self.info[indexPath.row]){ string in
                self.info[indexPath.row] = string
            }
        }
        editAction.backgroundColor = .gray
        
        //刪除鍵
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {
        // 按下 Delete 之後要執行的動作
            (deleteAction: UITableViewRowAction, indexPath: IndexPath) in
            self.info.remove(at: indexPath.row)
        }
        deleteAction.backgroundColor = .red
        errorAlert(message: "輸入錯誤")
        return [deleteAction, editAction]
    }

    
    //MARK:-NavigationBar
    func navigationBar(){
        self.view.backgroundColor = UIColor.white
        self.title = "To do list"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        
        //createButton
        let createButton = UIBarButtonItem(title: "Create",
                                           style: .plain,
                                           target: self,
                                           action: #selector(ViewController.create))
        self.navigationItem.rightBarButtonItem = createButton
        self.navigationItem.leftBarButtonItem = self.editButtonItem //多出一個編輯鈕
    }


    //MARK:-ShowUpAlert
    func textFieldAlert(title: String? , message: String? = nil, text: String? = nil, okAction: ((String) -> Void)? = nil){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert) //輸入框設定，會在輸入框裡面的功能是一個UITextField
        alertController.addTextField(configurationHandler: {(inputTextField: UITextField) in
            
            inputTextField.placeholder = "Add somthing" //先預設在輸入框內的字樣
            inputTextField.text = text //輸入的字樣
        })
        //創建ok鍵
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            let text = alertController.textFields?.first?.text ?? ""
            okAction?(text)
        }
        //創建cancel鍵
        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    func errorAlert(message: String? = nil){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        //讓跳出視窗有ok、cancel兩鍵
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }


}
//MARK:-UITableViewDelegation,UITableView
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    //設置回傳每一組有幾個cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    //設置回傳多少cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //取得tableView目前取用的cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = info[indexPath.row] //cell的文字標籤等於陣列的行數
        return cell //回傳文字
    }
    //真正反映在資料的調換順序moveRowAt
    func tableView(_ tableView:UITableView, moveRowAt sourceIndexPath:IndexPath,to destinationIndexPath:IndexPath){
        let moveInfo = info.remove(at: sourceIndexPath.row)
        //並在資料中插入資料
        info.insert(moveInfo,at:destinationIndexPath.row)
    }
    
    //Table的編輯模式editingStyleForRowAt
    func tableView(_ tableView:UITableView,editingStyleForRowAt indexPath:IndexPath)->UITableViewCell.EditingStyle{
        return .delete
    }
    //可以編輯滑動canMoveRowAt
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //可以編輯表格列canEditRowAt
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else if editingStyle == .insert{
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
}


