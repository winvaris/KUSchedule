//
//  CourseIDViewController.swift
//  KUSchedule
//
//  Created by Varis Kritpolchai on 5/21/2560 BE.
//  Copyright © 2560 Varis Kritpolchai. All rights reserved.
//

import UIKit

class CourseIDViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBAction func searchButton(_ sender: Any) {
        print("SEARCHBUTTON")
        let myVC = storyboard?.instantiateViewController(withIdentifier: "CourseTableViewController") as! CourseTableViewController
        myVC.idPassed = idTextField.text
        navigationController?.pushViewController(myVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        idTextField.setBottomBorder()
        
        // Add the tapped around to hide keyboard function
        self.hideKeyboardWhenTappedAround()
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
