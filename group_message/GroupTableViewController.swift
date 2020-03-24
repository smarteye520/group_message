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
    
    var aryGroup : [String?] = []
    var aryLocalGroup : [String?] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.getGroupData()
    }
    
    func getGroupData() {
        aryLocalGroup.removeAll()
        aryLocalGroup = Utility.getArrayFromUserDefaults(key: USER_GROUP)
        
        let refGroup = Database.database().reference().child("group")
        refGroup.queryOrdered(byChild: "name")
            .observe( .value, with: { (snapshot) in
            for group  in snapshot.children.allObjects as! [DataSnapshot] {
                let dicGroup = group.value as! [String: AnyObject]
                let content = dicGroup["name"] as? String
                self.aryGroup.append(content);
            }
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aryGroup.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupTableViewCell {
            
            let groupName = aryGroup[indexPath.row]
            cell.lblGroupName.text = groupName
            if aryLocalGroup.contains(groupName) {
                cell.imgCheck.image = UIImage(named: "checkmark")
            } else {
                cell.imgCheck.image = UIImage(named: "checkmarkempty")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cellinfo = dashboardItems[indexPath.row]
//        if bEdit{
//            self.iSelectIndex = indexPath.row
//            collectionView.reloadData()
//        } else {
//            if cellinfo.identifier == 0 {
//                  if let destView = self.storyboard?.instantiateViewController(withIdentifier: "ConfigSwitchView") as? ConfigSwitchViewController{
//                      destView.configInfo = cellinfo
//                      destView.delegate = self
//                      destView.switchOperation = .Add
//                      self.navigationController?.pushViewController(destView, animated: true)
//                  }
//            } else {
//                  if let destView = self.storyboard?.instantiateViewController(withIdentifier: "SwitchOnOffView") as? SwitchOnOffViewController{
//                    destView.configInfo = cellinfo
//                    destView.iSelectedIndex = indexPath.row
//                    self.navigationController?.pushViewController(destView, animated: true)
//                  }
//            }
//
//        }
                    
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
