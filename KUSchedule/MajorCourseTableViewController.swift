//
//  MajorCourseTableViewController.swift
//  KUSchedule
//
//  Created by Varis Kritpolchai on 5/22/2560 BE.
//  Copyright © 2560 Varis Kritpolchai. All rights reserved.
//

import UIKit
import FirebaseDatabase

extension MajorCourseTableViewController: UIViewControllerPreviewingDelegate {
    
    // Peek
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        guard let previewViewController = storyboard?.instantiateViewController(withIdentifier: "CourseTableViewController") as? CourseTableViewController else { return nil }
        
        let temp: NSDictionary = self.majorCourses![indexPath.row]
        let selectedCourseID = String(describing: temp.object(forKey: "FIELD3")!)
        previewViewController.idPassed = selectedCourseID
        
        previewViewController.preferredContentSize = CGSize(width: 0, height: 800)
        
        previewingContext.sourceRect = cell.frame
        
        return previewViewController
    }
    
    // Pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
}

class MajorCourseTableViewController: UITableViewController {
    
    var majorPassed: String!
    var ref: DatabaseReference?
    var courses: NSArray?
    var loaded: Bool?
    var majorCourses: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaded = false
        tableView.dataSource = self
        tableView.delegate = self
        majorCourses = []
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        ref = Database.database().reference()
        ref!.child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.courses = snapshot.value as? NSArray
            print("HI")
            self.loaded = true;
            self.tableView.reloadData()
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
    
    func addMajorCourses() {
        for i in 0 ..< self.courses!.count {
            var added = false
            let temp: NSDictionary = self.courses![i] as! NSDictionary
            for j in 0 ..< self.majorCourses!.count {
                let tempMjr: NSDictionary = self.majorCourses![j]
                if String(describing: temp.object(forKey: "FIELD3")!) == String(describing: tempMjr.object(forKey: "FIELD3")!) {
                    added = true
                }
            }
            if !added {
                majorCourses?.append(temp)
            }
        }
    }
    
    func sortCourses() {
        for i in 0 ..< self.majorCourses!.count - 1 {
            for j in (i + 1) ..< self.majorCourses!.count {
                let tempA: NSDictionary = self.majorCourses![i]
                let tempB: NSDictionary = self.majorCourses![j]
                if String(describing: tempA.object(forKey: "FIELD4")!) > String(describing: tempB.object(forKey: "FIELD4")!) {
                    self.majorCourses![i] = tempB
                    self.majorCourses![j] = tempA
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loaded == true {
            addMajorCourses()
            sortCourses()
            return majorCourses!.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MajorCourseTableViewCell", for: indexPath) as? MajorCourseTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of MajorCourseTableViewCell.")
        }
        if loaded == true {
            let temp: NSDictionary = self.majorCourses![indexPath.row]
            cell.nameLabel.text = String(describing: temp.object(forKey: "FIELD4")!)
            cell.idLabel.text = "0" + String(describing: temp.object(forKey: "FIELD3")!)
        }
        else {
            cell.nameLabel.text = "Please wait..."
            cell.idLabel.text = ""
        }
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowDetail":
            guard let courseTableViewController = segue.destination as? CourseTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? MajorCourseTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let temp: NSDictionary = self.majorCourses![indexPath.row]
            let selectedCourseID = String(describing: temp.object(forKey: "FIELD3")!)
            courseTableViewController.idPassed = selectedCourseID
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
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
