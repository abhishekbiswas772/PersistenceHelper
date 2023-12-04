//
//  AddViewController.swift
//  Data Persistance Helper
//
//  Created by Abhishek Biswas on 04/12/23.
//

import UIKit

protocol sendUser {
    func addUser(name: String, email: String)
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addUserBtn: UIButton!
    var delegate : sendUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addUserBtn.addTarget(self, action: #selector(addAction(_ :)), for: .touchUpInside)
    }
    
    @objc func addAction(_ sender : UIButton){
        if let nameTxt = self.nameField.text, let emailTxt = self.emailField.text {
            if (nameTxt != "" || emailTxt != "") {
                delegate?.addUser(name: nameTxt, email: emailTxt)
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
