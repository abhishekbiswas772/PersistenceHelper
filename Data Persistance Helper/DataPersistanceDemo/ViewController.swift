//
//  ViewController.swift
//  DataPersistanceDemo
//
//  Created by Abhishek Biswas on 04/12/23.
//

import UIKit
import Data_Persistance_Helper


class ViewController: UIViewController {
    
    var dbName : String?
    var queryTableString : String?
    var dbHelperGlobal : PersistenceHelper?
    
    
    @IBOutlet weak var addUserBtn: UIButton!
    @IBOutlet weak var seeAllUserBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addUserBtn.addTarget(self, action: #selector(addAction(_ :)), for: .touchUpInside)
        self.seeAllUserBtn.addTarget(self, action: #selector(watchAction(_ :)), for: .touchUpInside)
        createDBAndTable()
    }
    
    @objc func addAction(_ sender: UIButton) {
        let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddViewController") as? AddViewController
        addVC?.delegate = self
        addVC?.modalPresentationStyle = .fullScreen
        self.present(addVC ?? UIViewController(), animated: true)
    }
    
    @objc func watchAction(_ sender: UIButton) {
        guard let allModelArray = self.getAllDataFromDb() else {return}
        let allVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllUserViewController") as? AllUserViewController
        allVc?.modalPresentationStyle = .fullScreen
        allVc?.dataArray = allModelArray
        self.present(allVc ?? UIViewController(), animated: true)
    }
    
    private func createDBAndTable() {
        dbName = "MyApp.db"
        queryTableString = """
            CREATE TABLE IF NOT EXISTS Users(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                email TEXT
            );
        """
        
        do {
            
            let dbHelper = try PersistenceHelper(dbName: dbName ?? "", createTableQuery: queryTableString ?? "")
            self.dbHelperGlobal = dbHelper
        } catch {
            print("Database initialization failed: \(error)")
        }
    }
    
    private func getAllDataFromDb() -> [UserModel]? {
        let selectQuery = "SELECT * FROM Users;"
        let selectResult = dbHelperGlobal?.executeQuery(selectQuery)
        var allModel : [UserModel] = []
        switch selectResult {
            case .success:
                print("Query executed successfully but no rows to fetch in a non-select query.")
                return nil
            case .failure(let error):
                print("Failed to fetch users: \(error)")
                return nil
            case .rows(let rows):
                for row in rows {
                    if let name = row["name"] as? String, let email = row["email"] as? String {
                        print("User: \(name), Email: \(email)")
                        let singleUser = UserModel(name: name, email: email)
                        allModel.append(singleUser)
                    }
                }
                return allModel
            case .none:
                return nil
        }
    }
    
    private func insertIntoDb(withName name: String, withEmail email: String) -> Bool {
        let insertQuery = "INSERT INTO Users (name, email) VALUES ('\(name)', '\(email)');"
        let result = self.dbHelperGlobal?.executeQuery(insertQuery)

        switch result {
            case .success:
                print("User inserted successfully.")
                return true
            case .failure(let error):
                print("Failed to insert user: \(error)")
                return false
            case .rows(_):
                print("Received rows, which is unexpected for an insert query.")
                return false
            case .none:
                return false
        }
    }

}

extension ViewController : sendUser {
    func addUser(name: String, email: String) {
        let _ : Bool = self.insertIntoDb(withName: name, withEmail: email)
    }
}

