//
//  DetailViewController.swift
//  group_message
//
//  Created by Liu Jie on 3/25/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblGroup: UILabel!
    
    var dicMessage : [String: String?] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTitle.text = (dicMessage["title"] as? String ?? "")
        txtMessage.text = (dicMessage["content"] as? String ?? "")
        lblTime.text = (dicMessage["created"] as? String ?? "")
        lblGroup.text = (dicMessage["group"] as? String ?? "")
    }    
}
