//
//  ChatViewController.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 12.06.2021.
//

import UIKit
import Firebase
import FirebaseStorage

class ChatViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containerViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: UITextField!
    
    private let storage = Storage.storage().reference()
    private let messagesDB = Database.database().reference().child("Messages")
    private var messages: [MessageEntity] = []
    
    private var chatViewModel: ChatViewModel!
    private var messageViewModel: MessageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        callFetchMessages()
    }
    
    private func setupTableView() {
        let tapOnTableView = UITapGestureRecognizer(target: self, action: #selector(tappedOnTableView))
        
        inputTextField.delegate = self

        tableView.addGestureRecognizer(tapOnTableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: ChatTableViewCell.id, bundle: Bundle(for: ChatTableViewCell.self)), forCellReuseIdentifier: ChatTableViewCell.id)
        tableView.register(UINib(nibName: PhotoTableViewCell.id, bundle: Bundle(for: PhotoTableViewCell.self)), forCellReuseIdentifier: PhotoTableViewCell.id)
    }

    @IBAction func photoButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        guard let imageData = image.pngData() else { return }
        
        let email = Auth.auth().currentUser?.email
        
        //Using it for make photoID
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        
        let nameForImage = "V\(dateTimeComponents.year!)\(dateTimeComponents.month!)\(dateTimeComponents.day!)\(dateTimeComponents.hour!)\(dateTimeComponents.minute!)\(dateTimeComponents.second!)__\(email!)"
        storage.child("\(email!)/\(nameForImage).png").putData(imageData, metadata: nil, completion: {_, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            self.storage.child("\(email!)/\(nameForImage).png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteURL
                self.sendImageToFirebase("\(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let message = inputTextField.text else { return }
        callSendMessageToFirebase(message)
    }
    
}
extension ChatViewController {
    @objc private func tappedOnTableView() {
        inputTextField.endEditing(true)
    }
    
    private func sendImageToFirebase(_ url: String) {
        guard let email = Auth.auth().currentUser?.email else { return }
        
        let messagesDict = ["sender": email, "message": url]
        
        sendButton.isEnabled = false;
        inputTextField.text = ""
        
        messagesDB.childByAutoId().setValue(messagesDict){ [weak self] (error, reference) in
            if error != nil {
                print(error!)
            } else {
                self?.sendButton.isEnabled = true
            }
        }
        
    }
    private func scrollToLastMessage() {
        if messages.count - 1 > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
extension ChatViewController {
    private func callFetchMessages() {
        self.chatViewModel = ChatViewModel()
        self.chatViewModel.bindChatViewModelToController = {
            self.setupChatData()
        }
    }
    
    private func setupChatData() {
        self.messages = self.chatViewModel.messages
        self.tableView.reloadData()
        self.scrollToLastMessage()
    }
    
    private func callSendMessageToFirebase(_ message: String) {
        self.sendButton.isEnabled = false;
        self.inputTextField.text = ""
        self.messageViewModel = MessageViewModel(message)
        self.messageViewModel.bindMessageViewModelToController = {
            self.setupSendMessageData()
        }
    }
    
    private func setupSendMessageData() {
        if self.messageViewModel?.errorMessage == "It has error" {
            print(self.messageViewModel.errorMessage ?? "error")
        } else {
            self.sendButton.isEnabled = true
        }
    }
}
extension ChatViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.containerViewHeightConstraints.constant = 50 + 250
            self.view.layoutIfNeeded()
        }
        scrollToLastMessage()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.containerViewHeightConstraints.constant = 50
            self.view.layoutIfNeeded()
        }
        scrollToLastMessage()
    }
}
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photoMessage = messages[indexPath.row].message
        if photoMessage.contains("https://firebasestorage.googleapis.com/v0/b/chat-ios-a24b0.appspot.com/o/") {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.id, for: indexPath) as! PhotoTableViewCell
            let message = messages[indexPath.row]
            cell.message = message
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.id, for: indexPath) as! ChatTableViewCell
            let message = messages[indexPath.row]
            cell.message = message
            return cell
        }
    }
    
}
