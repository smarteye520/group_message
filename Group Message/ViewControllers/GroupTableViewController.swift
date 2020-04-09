//
//  GroupTableViewController.swift
//  group_message
//
//  Created by SmartEye on 3/20/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GroupTableViewController: UITableViewController {
    
    var aryGroup: [[String: String?]] = []
    var aryLocalGroup : [[String: String?]] = []
    var aryTmpGroupId : [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Select Groups"
        let button = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onDone(_:)))
        self.navigationItem.rightBarButtonItem = button
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getGroupData()
    }
    
    func getGroupData() {
        let deviceToken = Utility.getStringFromUserDefaults(key: DEVICE_TOKEN)
        var iRequest = 0
                
        aryGroup.removeAll()
        aryLocalGroup.removeAll()
        aryTmpGroupId.removeAll()
        
        let refGROUP = Database.database().reference().child("group")
        refGROUP.queryOrdered(byChild: "name")
            .observe( .value, with: { (snapshot) in
            for group  in snapshot.children.allObjects as! [DataSnapshot] {
                let dicGroup = group.value as! [String: AnyObject]
                let id = group.key
                let content = dicGroup["name"] as? String
                self.aryGroup.append(["id": id, "name": content])
                                
                iRequest += 1
                let refUSER = Database.database().reference().child("users").child(id)
                let query = refUSER.queryOrdered(byChild: "usertoken").queryEqual(toValue: deviceToken)
                query.observe( .value, with: { (snapshot) in
                    iRequest -= 1
                    for child  in snapshot.children.allObjects as! [DataSnapshot] {
                        let childkey = child.key
                        self.aryLocalGroup.append(["groupId": id, "childId": childkey])
                        self.aryTmpGroupId.append(id)
                    }
                    
                    if iRequest == 0 {
                        self.tableView.reloadData()
                    }
                })
            }
                
            Utility.saveDictionaryToUserDefaults(value: self.aryGroup, key: GROUP_DATA)
        })
    }
    
    @IBAction func onDone(_ sender: Any) {
        self.saveGroup()
    }
    
    func saveGroup() {
        let deviceToken = Utility.getStringFromUserDefaults(key: DEVICE_TOKEN)
        let userData = ["username": "iPhone User", "usertoken": deviceToken]

        if aryTmpGroupId.count > 0 {
            for i in 0 ... aryTmpGroupId.count - 1{
                let groupid = aryTmpGroupId[i]
                if !aryLocalGroup.contains(where: {$0["groupId"] == groupid}) {
                    let refGroup = Database.database().reference().child("users")
                    guard let key = refGroup.child(groupid!).childByAutoId().key else {return}
                    refGroup.child(groupid!).child(key).setValue(userData) { (error, ref) in
                        if let error = error {
                          print("Data could not be saved: \(error).")
                        }
                    }
                }
            }
        }

        if aryLocalGroup.count > 0 {
            for i in 0 ... aryLocalGroup.count - 1 {
                let group = aryLocalGroup[i]
                let groupid = group["groupId"]
                let childid = group["childId"]
                if !aryTmpGroupId.contains(groupid!) {
                    Database.database().reference().child("users").child(groupid!!).child(childid!!).removeValue() { (error, ref) in
                        
                        if let error = error {
                          print("Data could not be saved: \(error).")
                        } else {
                            let _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        
        let _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryGroup.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupTableViewCell {
            
            let group = aryGroup[indexPath.row]
            let groupName = group["name"]
            let groupid = group["id"]
            
            cell.lblGroupName.text = groupName!
            
            if aryTmpGroupId.contains(groupid!) {
                cell.imgCheck.image = UIImage(named: "Checkmark")
            } else {
                cell.imgCheck.image = UIImage(named: "Checkmarkempty")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as! GroupTableViewCell
        
        let group = aryGroup[indexPath.row]
        let groupid = group["id"]

        if aryTmpGroupId.contains(groupid!) {
            currentCell.imgCheck.image = UIImage(named: "Checkmarkempty")
            let indexofCell = aryTmpGroupId.firstIndex(of: groupid!)
            aryTmpGroupId.remove(at: indexofCell!)
        } else {
            currentCell.imgCheck.image = UIImage(named: "Checkmark")
            aryTmpGroupId.append(groupid!)
        }
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
