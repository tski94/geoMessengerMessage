//
//  ViewController.swift
//  geoMessengerMessage
//
//  Created by Ivor D. Addo on 3/29/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBAction func addUserPressed(_ sender: CustomButton) {
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        let userTable: [String : Any] =
            ["FirstName" :firstName.text!,
             "LastName" : lastName.text!,
             "IsApproved" : false]
      //add to the Firebase JSON node for MyUsers
        ref.child("MyUsers").childByAutoId().setValue(userTable)
        
     //confirmation alert
     
    let ac = UIAlertController(title: "User Saved!", message: "The user has been saved successfully", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title:"Ok", style: .default))
        present(ac, animated: true)
        
        //reset controls
        firstName.text = nil
        lastName.text = nil
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

