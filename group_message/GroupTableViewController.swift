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
    
    var aryGroupName : [String?] = []
    var aryGroupId: [String?] = []
    var aryTmpGroupId : [String?] = []
    var aryLocalGroup : [String?] = []
    var bDone : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onDone(_:)))
        self.navigationItem.rightBarButtonItem = button

        self.getGroupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bDone = false
    }
    
    func getGroupData() {
        aryLocalGroup.removeAll()
        aryLocalGroup = Utility.getArrayFromUserDefaults(key: USER_GROUP)
        aryTmpGroupId = aryLocalGroup
        
        let refGroup = Database.database().reference().child("group")
        refGroup.queryOrdered(byChild: "name")
            .observe( .value, with: { (snapshot) in
            for group  in snapshot.children.allObjects as! [DataSnapshot] {
                let dicGroup = group.value as! [String: AnyObject]
                let content = dicGroup["name"] as? String
                let id = group.key
                self.aryGroupName.append(content)
                self.aryGroupId.append(id)
            }
            self.tableView.reloadData()
        })
    }
    
    
    
    @IBAction func onDone(_ sender: Any) {
        bDone = !bDone
        if bDone {
            self.saveGroup()
        }
    }
    
    func saveGroup() {
//        let deviceToken = Utility.getStringFromUserDefaults(key: DEVICE_TOKEN)
        let deviceToken = "test_token"
        let userData = ["username": "", "usertoken": deviceToken]
        Utility.saveArrayToUserDefaults(value: aryTmpGroupId, key: USER_GROUP)
        
        if aryTmpGroupId.count > 0 {
            for i in 0 ... aryTmpGroupId.count - 1{
                let groupid = aryTmpGroupId[i]
                if !aryLocalGroup.contains(groupid) {
                    let refGroup = Database.database().reference().child("users")
                    guard let key = refGroup.child(groupid!).childByAutoId().key else {return}
                    refGroup.child(groupid!).child(key).setValue(userData)
                }
            }
        }
        
        if aryLocalGroup.count > 0 {
            for i in 0 ... aryLocalGroup.count - 1 {
                let groupid = aryLocalGroup[i]
                if !aryTmpGroupId.contains(groupid) {
                    let refGroup = Database.database().reference().child("users").child(groupid!)
                    let query = refGroup.queryOrdered(byChild: "usertoken").queryEqual(toValue: deviceToken)
                    query.observe( .value, with: { (snapshot) in
                        for child  in snapshot.children.allObjects as! [DataSnapshot] {
                            let childkey = child.key
                            refGroup.child(childkey).removeValue()
                        }
                    })
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let _ = self.navigationController?.popViewController(animated: true)
        }        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aryGroupName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupTableViewCell {
            
            cell.lblGroupName.text = aryGroupName[indexPath.row]
            let groupid = aryGroupId[indexPath.row]
            
            if aryTmpGroupId.contains(groupid) {
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
        
        let groupid = aryGroupId[indexPath.row]
        if aryTmpGroupId.contains(groupid) {
            currentCell.imgCheck.image = UIImage(named: "Checkmarkempty")
            let indexofCell = aryTmpGroupId.firstIndex(of: groupid)
            aryTmpGroupId.remove(at: indexofCell!)
        } else {
            currentCell.imgCheck.image = UIImage(named: "Checkmark")
            aryTmpGroupId.append(groupid)
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
