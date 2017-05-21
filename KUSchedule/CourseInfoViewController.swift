//
//  CourseInfoViewController.swift
//  KUSchedule
//
//  Created by Varis Kritpolchai on 5/21/2560 BE.
//  Copyright © 2560 Varis Kritpolchai. All rights reserved.
//

import UIKit

class CourseInfoViewController: UIViewController {
    
    var course: NSDictionary?
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var courseIDLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseTypeLabel: UILabel!
    @IBOutlet weak var courseSectionLabel: UILabel!
    @IBOutlet weak var courseTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profIndexLabel: UILabel!
    @IBOutlet weak var profNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Force the orientation to be landscape
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        if course != nil {
            yearLabel.text = "Year: " + String(describing: self.course!.object(forKey: "FIELD1")!)
            semesterLabel.text = "Semester: " + String(describing: self.course!.object(forKey: "FIELD2")!)
            courseIDLabel.text = "Course ID: 0" + String(describing: self.course!.object(forKey: "FIELD3")!)
            courseNameLabel.text = "Course Name: " + String(describing: self.course!.object(forKey: "FIELD4")!)
            courseTypeLabel.text = "Course Type: " + String(describing: self.course!.object(forKey: "FIELD5")!)
            courseSectionLabel.text = "Course Section: " + String(describing: self.course!.object(forKey: "FIELD6")!)
            courseTimeLabel.text = "Course Time: " + String(describing: self.course!.object(forKey: "FIELD7")!)
            locationLabel.text = "Location: " + String(describing: self.course!.object(forKey: "FIELD8")!)
            profIndexLabel.text = "Professor Index: " + String(describing: self.course!.object(forKey: "FIELD9")!)
            profNameLabel.text = "Professor's Name: " + String(describing: self.course!.object(forKey: "FIELD10")!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
