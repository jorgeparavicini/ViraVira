//
//  SettingsTableViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 11/03/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, SWRevealViewControllerDelegate {
	
//	MARK: - Properties
//	MARK: Navigation Bar
	@IBOutlet weak var navBar: UINavigationItem!
	var menuButton: UIButtonAnimation! = nil
	var comesFromSegue: Bool = false
	
//	MARK: Other properties

    override func viewDidLoad() {
        super.viewDidLoad()

		
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		self.revealViewController().delegate = self
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		Menu.currentRootViewController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
}
