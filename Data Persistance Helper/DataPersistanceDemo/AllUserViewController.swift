//
//  AllUserViewController.swift
//  DataPersistanceDemo
//
//  Created by Abhishek Biswas on 04/12/23.
//

import UIKit

class AllUserViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var dataArray : [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UserAllTableViewCell.nib(), forCellReuseIdentifier: UserAllTableViewCell.cellId)
        
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AllUserViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier:
                                                        UserAllTableViewCell.cellId, for: indexPath) as? UserAllTableViewCell
        cell?.nameLabel.text = dataArray[indexPath.row].name
        cell?.emailLabel.text = dataArray[indexPath.row].email
        return cell ?? UITableViewCell()
    }
}
