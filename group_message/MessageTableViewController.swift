//
//  MessageTableViewController.swift
//  group_message
//
//  Created by SmartEye on 3/20/20.
//  Copyright © 2020/Users/smarteye/Development/AYM_Kids/AYM personal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MessageTableViewController: UITableViewController {
    
    var aryMessage : [String?]  = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // add right navigation button
        let button = UIBarButtonItem(title: "Set Groups", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.goGroup(_:)))
        self.navigationItem.rightBarButtonItem = button
        
        self.getMessageData()
    }
    
    @IBAction func goGroup(_ sender: Any) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: GroupTableViewController.self)) as! GroupTableViewController
        navigationController?.pushViewController(registerVC, animated: true)
    }

    func getMessageData() {

    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aryMessage.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell {
            
            
            return cell
        }

        return UITableViewCell()

    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
