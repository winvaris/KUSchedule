//
//  CourseTableViewController.swift
//  KUSchedule
//
//  Created by Varis Kritpolchai on 5/21/2560 BE.
//  Copyright © 2560 Varis Kritpolchai. All rights reserved.
//

import UIKit
import FirebaseDatabase

extension CourseTableViewController: UIViewControllerPreviewingDelegate {
    // Peek
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        guard let previewViewController = storyboard?.instantiateViewController(withIdentifier: "CourseInfoViewController") as? CourseInfoViewController else { return nil }
        
        previewViewController.course = courseSections![indexPath.row]
        
        previewViewController.preferredContentSize = CGSize(width: 0, height: 600)
        
        previewingContext.sourceRect = cell.frame
        
        return previewViewController
    }
    
    // Pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
}

class CourseTableViewController: UITableViewController {
    
    var idPassed: String!
    var ref: DatabaseReference?
    var courses: NSArray?
    var loaded: Bool?
    var courseSections: [NSDictionary]?
    @IBOutlet weak var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaded = false
        tableView.dataSource = self
        tableView.delegate = self
        courseSections = []
        
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
    
    func addCourseSections() {
        for i in 0 ..< self.courses!.count {
            let temp: NSDictionary = self.courses![i] as! NSDictionary
            if String(describing: temp.object(forKey: "FIELD3")!) == idPassed {
                courseSections?.append(temp)
            }
        }
    }
    
    func sortSections() {
        for i in 0 ..< self.courseSections!.count - 1 {
            for j in (i + 1) ..< self.courseSections!.count {
                let tempA: NSDictionary = self.courseSections![i]
                let tempB: NSDictionary = self.courseSections![j]
                if Int(String(describing: tempA.object(forKey: "FIELD6")!))! > Int(String(describing: tempB.object(forKey: "FIELD6")!))! {
                    self.courseSections![i] = tempB
                    self.courseSections![j] = tempA
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loaded == true {
            addCourseSections()
            sortSections()
            if (courseSections!.count > 0) {
                return courseSections!.count
            }
            return 1
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTableViewCell", for: indexPath) as? CourseTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of StudentTableViewCell.")
        }
        if loaded == true {
            if courseSections!.count > 0 {
                let temp: NSDictionary = self.courseSections![indexPath.row]
                navTitle.title = String(describing: temp.object(forKey: "FIELD4")!)
                cell.sectionLabel.text = "Section: " + String(describing: temp.object(forKey: "FIELD6")!)
                cell.timeLabel.text = String(describing: temp.object(forKey: "FIELD7")!)
            }
            else {
                navTitle.title = ""
                cell.sectionLabel.text = "No course id found!!!"
                cell.timeLabel.text = ""
            }
        }
        else {
            navTitle.title = ""
            cell.sectionLabel.text = "Please wait..."
            cell.timeLabel.text = ""
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if courseSections!.count > 0 {
            super.prepare(for: segue, sender: sender)
            
            switch(segue.identifier ?? "") {
                
            case "ShowDetail":
                guard let courseInfoViewController = segue.destination as? CourseInfoViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedCell = sender as? CourseTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedCourse = self.courseSections![indexPath.row]
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
