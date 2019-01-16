//
//  ViewController.swift
//  BruRestaurant
//
//  Created by Simon Mc Neil on 2018-11-15.
//  Copyright © 2018 Simon Mc Neil. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Kingfisher


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference?

    
    var beverages: [Beverages] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("Users/\(Auth.auth().currentUser?.uid ?? "no id")/Items")
        loadDB()
        
        self.title = "Items"
        let nib = UINib(nibName: "BeverageTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "beverageCell")
        
        let addProduct = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBeverage))
        self.navigationItem.rightBarButtonItem = addProduct
        
        let logUserOut = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(logOut))
        self.navigationItem.leftBarButtonItem = logUserOut
    }
    
    func loadDB() {
        
        ref?.observe(DataEventType.value, with: { (snapshot) in
            
            var newInformation: [Beverages] = []
            let beverageRoot = snapshot.value as? [String: AnyObject] ?? [:]
            
            for key in Array(beverageRoot.keys) {
                let beverageDetails = Beverages(dictionary: beverageRoot[key] as! [String : AnyObject])
                newInformation.append(beverageDetails)
                newInformation.append(beverageDetails)
                //newInformation.append(beverageDetails)
            }
            
            self.beverages = newInformation
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beverages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beverageCell", for: indexPath) as! BeverageTableViewCell
        cell.selectionStyle = .none
        cell.beverageTitle.text = beverages[indexPath.row].title
        cell.beverageDescription.text = beverages[indexPath.row].desctription
        
        let url = URL(string: beverages[indexPath.row].image)
        if url == nil {
            cell.beverageImage.image = UIImage(named: "white")
        } else {
            //let data = try? Data(contentsOf: url!)
            cell.beverageImage.kf.setImage(with: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationtransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationtransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.beverages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // share item at indexPath
            print("I want to share: \(self.beverages[indexPath.row])")
        }
        
        share.backgroundColor = UIColor.lightGray
        
        return [delete, share]
        
    }
    
    @objc func addBeverage() {
        self.performSegue(withIdentifier: "addItem", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let refToDetailVc: AddProductViewController = segue.destination as? AddProductViewController else {
            print("Error occured")
            return
        }
        guard let userSignedInId: String = Auth.auth().currentUser?.uid else {
            return
        }
        refToDetailVc.userID = userSignedInId
    }
    
    @objc func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginScreen") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
}

