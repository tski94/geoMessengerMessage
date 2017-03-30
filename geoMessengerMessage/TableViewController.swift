//
//  TableViewController.swift
//  geoMessengerMessage
//
//  Created by Ivor D. Addo on 3/29/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {

    var items: [userItem] = []
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
    }
    
    func loadDataFromFirebase() {
        ref.child("MyUsers").observe(.value, with: { snapshot in
            var newItems: [userItem] = []
            
            for dbItem in snapshot.children.allObjects {
                let gItem = (snapshot: dbItem as! FIRDataSnapshot)
                let newValue = userItem(snapshot: gItem) //Convert JSON Snapshot to struct type
                newItems.append(newValue)
            }
            self.items = newItems.sorted{$0.lastName < $1.lastName}
            self.tableView.reloadData()
            
            })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.contentInset = UIEdgeInsets(top: 40,left: 0,bottom: 0,right: 0)
        loadDataFromFirebase()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        let userItem = items[indexPath.row]
        cell.textLabel?.text = userItem.firstName
        cell.textLabel?.text = userItem.lastName
        
        toggleCellCheckbox(cell, isCompleted: userItem.isApproved)
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        var userItem = items[indexPath.row]
        let toggledCompletion = !userItem.isApproved
        
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        userItem.isApproved = toggledCompletion
        tableView.reloadData()
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
            
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
    


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pk = items[indexPath.row].key
            ref.child("MyUsers").child(pk).removeValue()
            
            items.remove(at: indexPath.row)
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


}
