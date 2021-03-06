//
//  StudentTableViewController.swift
//  KUSchedule
//
//  Created by Varis Kritpolchai on 5/21/2560 BE.
//  Copyright © 2560 Varis Kritpolchai. All rights reserved.
//

import UIKit
import FirebaseDatabase

extension StudentTableViewController: UIViewControllerPreviewingDelegate {
    
    // Peek
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        guard let previewViewController = storyboard?.instantiateViewController(withIdentifier: "CourseInfoViewController") as? CourseInfoViewController else { return nil }
        
        if enrolledCourses!.count > 0 {
            previewViewController.course = enrolledCourses![indexPath.row]
        }
        
        previewViewController.preferredContentSize = CGSize(width: 0, height: 600)
        
        previewingContext.sourceRect = cell.frame
        
        return previewViewController
    }
    
    // Pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
}

class StudentTableViewController: UITableViewController {
    
    var idPassed: String!
    var ref: DatabaseReference?
    var courses: NSArray?
    var students: NSArray?
    var loaded: Bool?
    var enrolledCourses: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaded = false
        tableView.dataSource = self
        tableView.delegate = self
        enrolledCourses = []
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        ref = Database.database().reference()
        ref!.child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.courses = snapshot.value as? NSArray
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        ref!.child("students").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.students = snapshot.value as? NSArray
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
    
    func addEnrolledCourses() {
        for i in 0 ..< self.students!.count {
            let temp: NSDictionary = self.students![i] as! NSDictionary
            if String(describing: temp.object(forKey: "FIELD3")!) == idPassed {
                for j in 0 ..< self.courses!.count {
                    let tempCrs: NSDictionary = self.courses![j] as! NSDictionary
                    if String(describing: temp.object(forKey: "FIELD4")!) == String(describing: tempCrs.object(forKey: "FIELD3")!) && String(describing: temp.object(forKey: "FIELD6")!) == String(describing: tempCrs.object(forKey: "FIELD6")!) {
                        enrolledCourses?.append(tempCrs)
                    }
                }
            }
        }
    }
    
    func sortDay() {
        if self.enrolledCourses!.count > 0 {
            for i in 0 ..< self.enrolledCourses!.count - 1 {
                for j in (i + 1) ..< self.enrolledCourses!.count {
                    let tempA: NSDictionary = self.enrolledCourses![i]
                    let tempB: NSDictionary = self.enrolledCourses![j]
                    var numA = 0
                    var numB = 0
                    
                    // Check for A
                    if String(describing: tempA.object(forKey: "FIELD7")!)[0..<2] == "M " {
                        numA = 1
                    }
                    else if String(describing: tempA.object(forKey: "FIELD7")!)[0..<2] == "Tu" {
                        numA = 2
                    }
                    else if String(describing: tempA.object(forKey: "FIELD7")!)[0..<2] == "W " {
                        numA = 3
                    }
                    else if String(describing: tempA.object(forKey: "FIELD7")!)[0..<2] == "Th" {
                        numA = 4
                    }
                    else if String(describing: tempA.object(forKey: "FIELD7")!)[0..<2] == "F " {
                        numA = 5
                    }
                    else if String(describing: tempA.object(forKey: "FIELD7")!)[0..<2] == "Sa" {
                        numA = 6
                    }
                    else if String(describing: tempA.object(forKey: "FIELD7")!)[0..<2] == "Su" {
                        numA = 7
                    }
                    
                    // Check for B
                    if String(describing: tempB.object(forKey: "FIELD7")!)[0..<2] == "M " {
                        numB = 1
                    }
                    else if String(describing: tempB.object(forKey: "FIELD7")!)[0..<2] == "Tu" {
                        numB = 2
                    }
                    else if String(describing: tempB.object(forKey: "FIELD7")!)[0..<2] == "W " {
                        numB = 3
                    }
                    else if String(describing: tempB.object(forKey: "FIELD7")!)[0..<2] == "Th" {
                        numB = 4
                    }
                    else if String(describing: tempB.object(forKey: "FIELD7")!)[0..<2] == "F " {
                        numB = 5
                    }
                    else if String(describing: tempB.object(forKey: "FIELD7")!)[0..<2] == "Sa" {
                        numB = 6
                    }
                    else if String(describing: tempB.object(forKey: "FIELD7")!)[0..<2] == "Su" {
                        numB = 7
                    }
                    
                    // Swap position ordering by day M...Su
                    if numA > numB {
                        self.enrolledCourses![i] = tempB
                        self.enrolledCourses![j] = tempA
                    }
                }
            }
            sortTime()
        }
    }
    
    func sortTime() {
        for i in 0 ..< self.enrolledCourses!.count - 1 {
            let tempA: NSDictionary = self.enrolledCourses![i]
            let tempB: NSDictionary = self.enrolledCourses![i + 1]
            let strA = String(describing: tempA.object(forKey: "FIELD7")!)
            let strB = String(describing: tempB.object(forKey: "FIELD7")!)
            // Swap position ordering by time
            if strA[0..<2] == strB[0..<2] {
                if Int(strA[2] + strA[3])! > Int(strB[2] + strB[3])! {
                    self.enrolledCourses![i] = tempB
                    self.enrolledCourses![i + 1] = tempA
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loaded == true {
            addEnrolledCourses()
            sortDay()
            if (enrolledCourses!.count > 0) {
                return enrolledCourses!.count
            }
            else {
                return 1
            }
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as? StudentTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of StudentTableViewCell.")
        }
        if loaded == true {
            if enrolledCourses!.count > 0 {
                let temp: NSDictionary = self.enrolledCourses![indexPath.row]
                cell.nameLabel.text = String(describing: temp.object(forKey: "FIELD4")!)
                cell.timeLabel.text = String(describing: temp.object(forKey: "FIELD7")!)
                cell.idLabel.text = "0" + String(describing: temp.object(forKey: "FIELD3")!)
            }
            else {
                cell.nameLabel.text = "No student id found!!!"
                cell.timeLabel.text = ""
                cell.idLabel.text = ""
            }
        }
        else {
            cell.nameLabel.text = "Please wait..."
            cell.timeLabel.text = ""
            cell.idLabel.text = ""
        }
        //cell?.textLabel?.text = temp.object(forKey: "FIELD4") as? String
        //cell.nameLabel.text = String(describing: temp.object(forKey: "FIELD4")!)
        //cell.timeLabel.text = String(describing: temp.object(forKey: "FIELD6")!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if enrolledCourses!.count > 0 {
            super.prepare(for: segue, sender: sender)
            
            switch(segue.identifier ?? "") {
                
            case "ShowDetail":
                guard let courseInfoViewController = segue.destination as? CourseInfoViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedCell = sender as? StudentTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedCourse = self.enrolledCourses![indexPath.row]
                courseInfoViewController.course = selectedCourse
                
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
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
