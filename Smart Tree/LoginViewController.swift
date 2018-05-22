//
//  LoginViewController.swift
//  Smart Tree
//
//  Created by Всеволод on 10.05.2018.
//  Copyright © 2018 me4air. All rights reserved.
//

import UIKit
import LocalAuthentication

struct Login: Codable {
    let id: String
}

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var touchIdSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    var userName = ""
    var userPass = ""
    var userID = "-1"
    
    
    @IBAction func loginButtonPresed(_ sender: UIButton) {
        if ((passTextField.text != "") && (userNameTextField.text != "")){
            UserDefaults.standard.set(passTextField.text, forKey: "pass")
            UserDefaults.standard.set(userNameTextField.text, forKey: "userName")
            userName = UserDefaults.standard.string(forKey: "userName")!
            userPass = UserDefaults.standard.string(forKey: "pass")!.utf8.md5.rawValue
            if touchIdSwitch.isOn{
                UserDefaults.standard.set(true, forKey: "touchIdEnabled")
            } else {
                UserDefaults.standard.set(false, forKey: "touchIdEnabled")
            }
            authToServer()
        } else {
            print ("error")
        }
        
    }
    
    override func viewDidLoad() {
        
        if((UserDefaults.standard.string(forKey: "pass") != "") && (UserDefaults.standard.string(forKey: "userName") != "")){
            userName = UserDefaults.standard.string(forKey: "userName")!
            userPass = UserDefaults.standard.string(forKey: "pass")!.utf8.md5.rawValue
            print(userPass)
            }
            if (UserDefaults.standard.bool(forKey: "touchIdEnabled" )){
            userNameTextField.text=userName
            authWithTouchId()
            
        } else if (UserDefaults.standard.bool(forKey: "touchIdEnabled") == false){
            touchIdSwitch.setOn(false, animated: false)
        }
        loginButton.layer.cornerRadius = loginButton.bounds.size.width * 0.1
        loginButton.clipsToBounds = true
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showTouchIdAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func authWithTouchId() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Войти как пользователь "+userName+" при помощи Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {(succes, error) in
                    if succes {
                        self.authToServer()
                    }
                    else {
                        self.showTouchIdAlertController("Touch ID Authentication Failed")
                    }
                    } )
        }
        else {
            showTouchIdAlertController("Touch ID not available")
        }
    }
    
    func authToServer() {
        
        guard let url = URL(string: "http://me4air.fvds.ru/loginApi.php") else {return}

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "name="+userName+"&pass="+userPass;
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, erroe) in
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                if let response = response {
                    print(response)
                }
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do{
                        let loginData = try JSONDecoder().decode(Login.self, from: data)
                        print(loginData)
                        self.userID=loginData.id
                       // print(self.userID)
                        if(self.userID != "-1"){
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                    } catch {
                        print(error)
                    }
                }
               
            }
            }.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let dvc = segue.destination  as! UINavigationController
            let tvc = dvc.topViewController as! StationsCollectionViewController
                tvc.userId = Int(userID)!
        }
        
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
