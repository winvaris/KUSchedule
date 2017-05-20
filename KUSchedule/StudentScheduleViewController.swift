//
//  StudentScheduleViewController.swift
//  KUSchedule
//
//  Created by Varis Kritpolchai on 5/18/2560 BE.
//  Copyright © 2560 Varis Kritpolchai. All rights reserved.
//

import UIKit
import FirebaseDatabase

class StudentScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference?
    var loaded: Bool?

    @IBOutlet weak var tableView: UITableView!
    var courses: NSArray?
    var students: NSArray?
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loaded == true {
            print(self.students![0])
            return self.courses!.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if loaded == true {
            print ("SET")
            print (indexPath.row)
            let temp: NSDictionary = self.courses![indexPath.row] as! NSDictionary
            print(temp.object(forKey: "FIELD3")!)
            cell?.textLabel?.text = temp.object(forKey: "FIELD4") as? String
            //cell?.textLabel?.text = String(describing: temp.object(forKey: "FIELD3")!)
        }
        return cell!
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
