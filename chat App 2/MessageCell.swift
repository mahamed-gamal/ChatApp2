//
//  MessageCell.swift
//  chat App 2
//
//  Created by Mohamed Gamal on 6/22/19.
//  Copyright © 2019 ME. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    enum bubbleType {
        case incoming
        case outgoing
    }
    
    @IBOutlet weak var chatTextBubble: UIView!
    
    @IBOutlet weak var chatStack: UIStackView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var messageTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        chatTextBubble.layer.cornerRadius = 6
        // Initialization code
    }
    
    func setMessageData(message: Message){
        userNameLabel.text = message.userName
        messageTextView.text = message.messageText
        
    }
    
    func setBubbleType(type: bubbleType){
        if(type == .incoming){
            chatStack.alignment = .leading
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            messageTextView.textColor = .black
        } else if (type == .outgoing){
            chatStack.alignment = .trailing
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.07703859807, green: 0.2999484454, blue: 0.1008764973, alpha: 1)
            messageTextView.textColor = .white
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
