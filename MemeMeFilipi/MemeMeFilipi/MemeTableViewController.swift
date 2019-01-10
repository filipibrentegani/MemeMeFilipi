//
//  MemeTableViewController.swift
//  MemeMeFilipi
//
//  Created by Filipi Brentegani on 07/01/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: Properties & Variables
    var memes : [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    // MARK: Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: TableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath) as! MemeTableCell

        let meme = memes[indexPath.row]
        
        cell.tableCellImageView.image = meme.memedImage
        cell.tableCellLabel.text = meme.topText

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller: MemeViewController
        controller = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        
        controller.meme = memes[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
