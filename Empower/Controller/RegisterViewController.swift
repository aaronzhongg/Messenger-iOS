//
//  RegisterViewController.swift
//  Empower
//
//  Created by Aaron Zhong on 19/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    // UI
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    // User DB
    let userDB = Database.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        scrollView.keyboardDismissMode = .interactive
        
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
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
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
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            SVProgressHUD.dismiss()
            
            if error != nil {
                let alert = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                self.present(alert, animated: true)
            } else {
                let user: [String: String] = ["first_name": self.firstNameTextField?.text ?? "", "last_name": self.lastNameTextField?.text ?? "", "username": self.usernameTextField?.text ?? "", "email": self.emailTextField?.text ?? "", "date_of_birth": self.dateOfBirthTextField?.text ?? ""]
                
                self.userDB.childByAutoId().setValue(user)
                
                let alert = UIAlertController(title: "You're Registered!", message: "", preferredStyle: .alert)
                
                self.present(alert, animated: true)
                
                let timeToDismiss = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: timeToDismiss, execute: {
                    alert.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
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
