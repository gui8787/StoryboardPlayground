//
//  MainMenuTableViewController.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 1/31/25.
//

import UIKit

class MainMenuTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCellReuse", for: indexPath)
        cell.textLabel?.text = indexPath.row == 0 ? "Store" : "Library"
        if indexPath.row == 0 {
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.5
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier: "storeViewController") as! StoreViewController, animated: true)
        } else {
            navigationController?.pushViewController(CollectionViewController(), animated: true)
        }
    }
}
