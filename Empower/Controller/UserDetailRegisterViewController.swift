//
//  UserDetailRegisterViewController.swift
//  Empower
//
//  Created by Aaron Zhong on 19/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import UIKit

class UserDetailRegisterViewController: UIViewController {
    
    // UI
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextFieldUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTextFieldUI() {
        firstNameTextField.addPadding(.left(15))
        lastNameTextField.addPadding(.left(15))
        usernameTextField.addPadding(.left(15))
        emailTextField.addPadding(.left(15))
        passwordTextField.addPadding(.left(15))
        dateOfBirthTextField.addPadding(.left(15))
        
        cancelButton.layer.cornerRadius = 0.5 * cancelButton.bounds.size.width
        cancelButton.clipsToBounds = true
    }
    
    @IBAction func xButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateOfBirthTextFieldPressed(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.locale = Locale(identifier: "en-nz")
        dateOfBirthTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(dobDatePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func dobDatePickerFromValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateOfBirthTextField.text = dateFormatter.string(from: sender.date)
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
