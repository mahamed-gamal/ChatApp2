//
//  HomeViewController.swift
//  chat App 2
//
//  Created by Mohamed Gamal on 6/17/19.
//  Copyright © 2019 ME. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var Rooms: [Room] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadRooms()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = self.Rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell") as! RoomCell
        
        cell.lbl.text = room.roomName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = self.Rooms[indexPath.row]
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        view.room = room
        
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rooms.count
    }
    
    
    @IBAction func didPressAddChatRoom(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Name Chat Room", message: "please enter your name chat room", preferredStyle: .alert)
        
        let addButton = UIAlertAction(title: "Add", style: .cancel) { (alertx) in
            guard let roomName = alert.textFields![0].text else {
                return
            }
           self.createChatRoom(name: roomName)
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { (alertx) in
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Room Name"
        }
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadRooms(){
        let database = Database.database().reference()
        database.child("Rooms").observe(.childAdded) { (response) in
            if let responsedata = response.value as? [String: Any]{
                guard let roomName = responsedata["name"] as? String else {
                    return
                }
                
                let room = Room.init(roomId: response.key, roomName: roomName)
                self.Rooms.append(room)
                self.tableView.reloadData()
            }
        }
    }
    
    func createChatRoom(name: String){
        let dataRoom: [String: String] = ["name": name]
        let database = Database.database().reference()
        database.child("Rooms").childByAutoId().setValue(dataRoom)
    }
   
    @IBAction func didPressLogOut(_ sender: Any) {
       try! Auth.auth().signOut()
       self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
