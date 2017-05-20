//
//  StudentTableViewController.swift
//  KUSchedule
//
//  Created by Varis Kritpolchai on 5/21/2560 BE.
//  Copyright © 2560 Varis Kritpolchai. All rights reserved.
//

import UIKit
import FirebaseDatabase

class StudentTableViewController: UITableViewController {
    
    var idPassed: String!
    var ref: DatabaseReference?
    var courses: NSArray?
    var students: NSArray?
    var loaded: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaded = false
        tableView.dataSource = self
        tableView.delegate = self
        
        // Force the orientation to be landscape
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        ref = Database.database().reference()
        ref!.child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.courses = snapshot.value as? NSArray
            print("HI")
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        ref!.child("students").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.students = snapshot.value as? NSArray
            print("HI")
            self.loaded = true;
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        print(idPassed)
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
            /*
            var count = 0
            print("OUTSIDE")
            for i in 0 ..< self.students!.count {
                print("idPassed: " + idPassed)
                let temp: NSDictionary = self.students![i] as! NSDictionary
                print("students: " + String(describing: temp.object(forKey: "FIELD3")!))
                if String(describing: temp.object(forKey: "FIELD3")!) == idPassed {
                    print("INSIDE")
                    count += 1
                }
            }
            */
            return self.students!.count
        }
        return 0;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as? StudentTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of StudentTableViewCell.")
        }
        if loaded == true {
            print ("SET")
            let temp: NSDictionary = self.students![indexPath.row] as! NSDictionary
            print ("After Set: " + String(describing: temp.object(forKey: "FIELD3")!))
            if String(describing: temp.object(forKey: "FIELD3")!) == idPassed {
                print ("INSIDE CONDITION")
                //cell?.textLabel?.text = temp.object(forKey: "FIELD4") as? String
                cell.nameLabel.text = String(describing: temp.object(forKey: "FIELD4")!)
                cell.timeLabel.text = String(describing: temp.object(forKey: "FIELD6")!)
                print ("END INSIDE CONDITION")
            }
        }
        print ("END OF CELL")
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
