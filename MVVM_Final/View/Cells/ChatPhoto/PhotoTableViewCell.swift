//
//  PhotoTableViewCell.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 12.06.2021.
//

import UIKit
import Kingfisher
import Firebase

class PhotoTableViewCell: UITableViewCell {
    public static let id: String = "PhotoTableViewCell"
    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var photoView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    public var message: MessageEntity? {
        didSet {
            if let message = message {
                let url = URL(string: message.message)
                photoView.kf.setImage(with: url)
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
