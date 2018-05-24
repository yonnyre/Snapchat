//
//  ElegirUsuarioViewController.swift
//  Snapchat
//
//  Created by yonny on 24/05/18.
//  Copyright © 2018 Yonnyr Team. All rights reserved.
//

import UIKit

class ElegirUsuarioViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

 
}
