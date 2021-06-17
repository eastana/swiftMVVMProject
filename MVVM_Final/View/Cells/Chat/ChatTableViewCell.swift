//
//  ChatTableViewCell.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 12.06.2021.
//

import UIKit
import Firebase

class ChatTableViewCell: UITableViewCell {
    
    public static let id: String = "ChatTableViewCell"
    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    public var message: MessageEntity? {
        didSet {
            if let message = message {
                messageLabel.text = message.message
                senderLabel.text = message.sender
                if Auth.auth().currentUser?.email == message.sender {
                    containerView.backgroundColor = .systemGreen
                } else {
                    containerView.backgroundColor = .systemOrange
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        containerView.layer.cornerRadius = 4
        containerView.layer.masksToBounds = true
    }
    
}
