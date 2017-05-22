//
//  MajorTableViewController.swift
//  KUSchedule
//
//  Created by Varis Kritpolchai on 5/22/2560 BE.
//  Copyright © 2560 Varis Kritpolchai. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MajorTableViewController: UITableViewController {
    
    var facultyName: String!
    var ref: DatabaseReference?
    var majors: NSArray?
    var loaded: Bool?
    @IBOutlet weak var navTitle: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        loaded = false
        tableView.dataSource = self
        tableView.delegate = self
        
        ref = Database.database().reference()
        ref!.child("faculties").child(facultyName).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.majors = snapshot.value as? NSArray
            print("HI")
            self.loaded = true;
            self.tableView.reloadData()
            print(self.majors!.count)
            print(self.majors!)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loaded == true {
            return majors!.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MajorTableViewCell", for: indexPath) as? MajorTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of StudentTableViewCell.")
        }
        if loaded == true {
            let temp: String = self.majors![indexPath.row] as! String
            navTitle.title = facultyName
            cell.nameLabel.text = temp
        }
        else {
            navTitle.title = ""
            cell.nameLabel.text = "Please wait..."
        }
        return cell
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

}
