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
    
    var aryGroup : [String?]  = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // add right navigation button
        let button = UIBarButtonItem(title: "Set Groups", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onAddStudent(_:)))
        self.navigationItem.rightBarButtonItem = button
        
        self.getGroupData()
     
    }
    
    @IBAction func onAddStudent(_ sender: Any) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: GroupTableViewController.self)) as! GroupTableViewController
//        registerVC.isEdit = false
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
//    func getGroupData() {
//        let refGroup = Database.database().reference().child("group")
//        refGroup.queryOrdered(byChild: "name")
//            .observe( .value, with: { (snapshot) in
//            for group  in snapshot.children.allObjects as! [DataSnapshot] {
//                let dicGroup = group.value as! [String: AnyObject]
//                let groupName = dicGroup["name"] as? String
//                self.aryGroup.append(groupName);
//            }
//            self.tableView.reloadData()
//        })
//    }
    
    func getGroupData() {
        let refGroup = Database.database().reference().child("messages")
        refGroup.queryOrdered(byChild: "created")
            .observe( .value, with: { (snapshot) in
            for group  in snapshot.children.allObjects as! [DataSnapshot] {
                let dicGroup = group.value as! [String: AnyObject]
                let content = dicGroup["content"] as? String
                self.aryGroup.append(content);
            }
            self.tableView.reloadData()
        })
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aryGroup.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? MessageTableViewCell {
            cell.lblContent.text = aryGroup[indexPath.row]
//            cell.lblSender.text = aryGroup[4 - indexPath.row]
            return cell
        }
        
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? GroupTableViewCell {
//            cell.lblGroupName.text = aryGroup[indexPath.row]
//            return cell
//        }
//
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
