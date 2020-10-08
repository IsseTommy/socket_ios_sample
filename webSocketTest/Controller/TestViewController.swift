//
//  TestViewController.swift
//  webSocketTest
//
//  Created by 神原良継 on 2020/10/08.
//  Copyright © 2020 jp.Antony. All rights reserved.
//

import UIKit
import SocketIO

class TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let manager = SocketManager(socketURL: URL(string:"test")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    var dataList: [String] = []
    
    @IBOutlet var testTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTableView.delegate = self
        testTableView.dataSource = self
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ackt in
            print("socket connected!")
        }
        
        socket.on(clientEvent: .disconnect) { data, act in
            print("socket disconnected!")
        }
        
        socket.on("from_sever") { data, act in
            if let message = data as? [String] {
                print(message[0])
                self.dataList.insert(message[0], at: 0)
                self.testTableView.reloadData()
            }
        }
        socket.connect()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = dataList[indexPath.row]
        return cell
    }
    
    //ソケット通信(送信)
    @IBAction func tapBUttonAction(_ sender: Any) {
        socket.emit("from_client", "button pushed!!")
    }
    //ソケット通信(再接続)
    @IBAction func reconnectButtonAction(_ sender: Any) {
        socket.connect()
    }
    //ソケット通信(通信切断)：ずっと繋いでると負担が出る
    @IBAction func desconnectButtonAction(_ sender: Any) {
        socket.disconnect()
    }


}
