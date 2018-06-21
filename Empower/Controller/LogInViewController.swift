//
//  ViewController.swift
//  Empower
//
//  Created by Aaron Zhong on 19/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        configureUI()
    }
    
    func configureUI() {
        emailTextField.addPadding(.left(15))
        passwordTextField.addPadding(.left(15))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            SVProgressHUD.dismiss()
            
            if error != nil {
                let alert = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            } else {
                self.performSegue(withIdentifier: "goToContacts", sender: self)
            }
        }
    }

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let registerPageVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailRegisterVC") as? RegisterViewController {
            present(registerPageVC, animated: true, completion: nil)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

