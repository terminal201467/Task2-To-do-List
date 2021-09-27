//
//  MyView.swift
//  Task2：To-do list
//
//  Created by Jhen Mu on 2021/7/27.
//

import UIKit
// 
class MyView: UIView {
    //MARK:-Properties
    var theTableView : UITableView! //定義一個格框
    
    //MARK:-LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK:-TableView
    //表格的外觀
    //設定private的理由是不讓人再去動到它裡面的設計了
    private func commonInit(){
        let fullScreenSize = UIScreen.main.bounds.size
        theTableView = UITableView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: fullScreenSize.width,
                                                 height: fullScreenSize.height), style: .plain)
        theTableView.register(UITableViewCell.self,
                              forCellReuseIdentifier: "Cell")//註冊cell
        theTableView.separatorStyle = .singleLine //分隔線的風格
        theTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        theTableView.allowsSelection = true //可否被選取
        theTableView.allowsMultipleSelection = true
        //開啟編輯模式
        theTableView.isEditing = true
        //開放編輯時可以選擇
        theTableView.allowsSelectionDuringEditing = true
        self.addSubview(theTableView)
    }

}




