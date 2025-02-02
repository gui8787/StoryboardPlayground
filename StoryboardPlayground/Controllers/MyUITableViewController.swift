//
//  MyUITableViewController.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 1/31/25.
//

import UIKit

class MyUITableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "rootCellReuse", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController, animated: true)
        } else {
            navigationController?.pushViewController(CollectionViewController(), animated: true)
        }
    }
}
