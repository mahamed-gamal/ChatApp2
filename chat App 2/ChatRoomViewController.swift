//
//  ChatRoomViewController.swift
//  chat App 2
//
//  Created by Mohamed Gamal on 6/19/19.
//  Copyright © 2019 ME. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var room = Room()
    var messages = [Message]()
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = room.roomName
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        observeMessages()
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        cell.setMessageData(message: message)
        if(message.userId == Auth.auth().currentUser?.uid ){
            cell.setBubbleType(type: .outgoing)
        } else {
            cell.setBubbleType(type: .incoming)
        }
        
        return cell
    }
    
    func observeMessages(){
        guard let roomId = room.roomId else {
            return
        }
        let database = Database.database().reference()
        database.child("Rooms").child(roomId).child("messages").observe(.childAdded) { (snapshot) in
            if let messages = snapshot.value as? [String: Any]{
                guard let userName = messages["username"] as? String , let messageText = messages["text"] as? String , let userId = messages["userId"] as? String else {
                    return
                }
                let messages = Message.init(messageId: snapshot.key, userName: userName, messageText: messageText, userId: userId)
                self.messages.append(messages)
                self.chatTableView.reloadData()
            }
        }
        
    }
    
    @IBAction func didPressOnSend(_ sender: Any) {
        if let message = messageTextField.text , message.isEmpty == false {
            getUserName { (username) in
                self.sendMessage(message: message, username: username)
            }
            
        }
    }
    
    func sendMessage(message: String , username: String){
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let data: [String: String] = ["text": message , "username": username , "userId": userId ]
        let database = Database.database().reference()
        if let roomId = room.roomId {
        database.child("Rooms").child(roomId).child("messages").childByAutoId().setValue(data)
        }
              messageTextField.text = ""
    }
    
    func getUserName( completion: @escaping (String) -> ()){
        if let currentUserId = Auth.auth().currentUser?.uid {
            let database = Database.database().reference()
            database.child("users").child(currentUserId).child("username").observeSingleEvent(of: .value) { (response) in
                if let username = response.value as? String{
                    completion(username)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}
