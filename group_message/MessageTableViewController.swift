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
    
    var aryMessage : [[String: Any?]]  = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tmpMessage = [["title": "title1", "content": "message1", "created":"2020-03-20, 16:48:37", "group" : "Adult"],
//                          ["title": "title2", "content": "message2", "created":"2020-03-20, 18:48:37", "group" : "Middle School"],
//                          ["title": "title3", "content": "message3", "created":"2020-03-20, 16:48:37", "group" : "Adult"],
//                          ["title": "title4", "content": "message4", "created":"2020-03-20, 18:48:37", "group" : "Middle School"],
//                          ["title": "title5", "content": "message5", "created":"2020-03-20, 16:48:37", "group" : "Adult"],
//                          ["title": "title6", "content": "message6", "created":"2020-03-20, 18:48:37", "group" : "Middle School"],
//                          ["title": "title7", "content": "message7", "created":"2020-03-20, 16:48:37", "group" : "Adult"],
//                          ["title": "title8", "content": "message8", "created":"2020-03-20, 18:48:37", "group" : "Middle School"]]
//        Utility.saveDictionaryToUserDefaults(value: tmpMessage, key: USER_MESSAGE)

        // Add left navigation button
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Add right navigation button
        let button = UIBarButtonItem(title: "Set Groups", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.goGroup(_:)))
        self.navigationItem.rightBarButtonItem = button
        
        self.getMessageData()
    }
    
    @IBAction func goGroup(_ sender: Any) {
        let groupVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: GroupTableViewController.self)) as! GroupTableViewController
        navigationController?.pushViewController(groupVC, animated: true)
    }

    func getMessageData() {
        aryMessage = Utility.getDictionaryFromUserDefaults(key: USER_MESSAGE)
        self.tableView.reloadData()
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
            let dicMessage = aryMessage[indexPath.row]
            cell.lblTitle.text = (dicMessage["title"] as? String ?? "")
            cell.txtMessage.text = (dicMessage["content"] as? String ?? "")
            cell.lblTime.text = (dicMessage["created"] as? String ?? "")
            cell.lblSender.text = (dicMessage["group"] as? String ?? "")
            
            return cell
        }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicMessage = aryMessage[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: DetailViewController.self)) as! DetailViewController
        detailVC.dicMessage = dicMessage
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.aryMessage.remove(at: indexPath.row)
            Utility.saveDictionaryToUserDefaults(value: aryMessage, key: USER_MESSAGE)
            tableView.deleteRows(at: [indexPath], with: .fade)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
