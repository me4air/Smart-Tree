//
//  LoginViewController.swift
//  Smart Tree
//
//  Created by Всеволод on 10.05.2018.
//  Copyright © 2018 me4air. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var touchIdSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginButtonPresed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        loginButton.layer.cornerRadius = loginButton.bounds.size.width * 0.1
        loginButton.clipsToBounds = true
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
