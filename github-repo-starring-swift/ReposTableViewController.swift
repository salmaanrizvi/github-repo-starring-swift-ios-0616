//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion {
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRepo = store.repositories[indexPath.row]
        
        store.toggleStarStatusForRepository(selectedRepo) { (toggled) in
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Okay", style: .Cancel, handler: { (cancelAction) in
                print("Okay clicked.")
            })
            alert.addAction(dismissAction)
            
            if toggled {
                alert.title = "You just starred \(selectedRepo.fullName)"
                alert.accessibilityLabel = "You just starred \(selectedRepo.fullName)"

            }
            else { // untoggled
                alert.title = "You just unstarred \(selectedRepo.fullName)"
                alert.accessibilityLabel = "You just unstarred \(selectedRepo.fullName)"
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.presentViewController(alert, animated: true, completion: {
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                })
            })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)

        let repository:GithubRepository = self.store.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName

        return cell
    }

}
