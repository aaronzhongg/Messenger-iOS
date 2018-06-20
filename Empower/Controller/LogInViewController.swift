//
//  ViewController.swift
//  Empower
//
//  Created by Aaron Zhong on 19/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let registerPageVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailRegisterVC") as? RegisterViewController {
            present(registerPageVC, animated: true, completion: nil)
        }
        
        
    }
}

