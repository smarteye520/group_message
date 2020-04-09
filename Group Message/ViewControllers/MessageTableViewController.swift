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

class MessageTableViewController: UITableViewController, MessageTableViewCellDelegate {
    
    var aryMessage : [[String: Any?]]  = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let arymessage = [["title": "Welcome", "body": "Welcome joined to this group.", "created":"2020-03-27 16:20", "group": "Adult"], ["title": "Scott", "body": "Scott.\n \n \nBadger Creek closed today due to", "created":"2020-03-26 16:24", "group": "Academy/Select"]]
//        Utility.saveDictionaryToUserDefaults(value: arymessage, key: USER_MESSAGE)

        // Add left navigation button
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Add right navigation button
        let button = UIBarButtonItem(title: "Set Groups", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.goGroup(_:)))
        self.navigationItem.rightBarButtonItem = button
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMoveToForeGround), name: NSNotification.Name(rawValue: "Add Message"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMessageData()
    }
    
    @objc func appMoveToForeGround() {
        self.viewWillAppear(true)
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
    
    func goAddOnStudent(index: Int?) {
        let dicMessage = aryMessage[index!]
        let detailVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: DetailViewController.self)) as! DetailViewController
        detailVC.dicMessage = dicMessage
        navigationController?.pushViewController(detailVC, animated: true)
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
            cell.txtMessage.text = (dicMessage["body"] as? String ?? "")
            cell.lblTime.text = (dicMessage["created"] as? String ?? "")
            cell.lblSender.text = (dicMessage["group"] as? String ?? "")
            cell.cellIndex = indexPath.row
            cell.delegate = self
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
