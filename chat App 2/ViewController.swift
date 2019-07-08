//
//  ViewController.swift
//  chat App 2
//
//  Created by Mohamed Gamal on 6/17/19.
//  Copyright © 2019 ME. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ViewController: UIViewController {
    
    enum topSegment: Int {
        case login
        case register
    }
    
    
    var currentPage: topSegment = .login
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.setTitle("login", for: .normal)
        }
    }
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!{
        didSet{
            userNameField.isHidden = true
        }
    }

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(Auth.auth().currentUser != nil){
            presentHome()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        swipe()
        // Do any additional setup after loading the view.
    }
    
    
    func swipe(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didDetectSwipe))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didDetectSwipe))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
     @objc func didDetectSwipe (_ sender: UISwipeGestureRecognizer){
        if(sender.direction == .left){
            segmentControl.selectedSegmentIndex = 0
           
        } else if(sender.direction == .right){
            segmentControl.selectedSegmentIndex = 1
    
        }
         segmentControl.sendActions(for: UIControl.Event.valueChanged)
    }
    
    func presentHome() {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav")
        
        self.present(view!, animated: true, completion: nil)
        
    }
 
    @IBAction func didPressSegment(_ sender: Any) {
        if let selectedSegment = topSegment(rawValue: segmentControl.selectedSegmentIndex){
            switch selectedSegment {
            case .login:
                userNameField.isHidden = true
                submitButton.setTitle("login", for: .normal)
                currentPage = .login
            case .register:
                userNameField.isHidden = false
                submitButton.setTitle("Register", for: .normal)
                currentPage = .register
            
            }
        }
       
    }
    
    func displayError(errorText: String){
        let alert = UIAlertController.init(title: "Error", message: errorText, preferredStyle: .alert)
        let cancelButton = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func didPressSubmit(_ sender: Any) {
            guard let email = emailField.text , let password = passwordField.text else{
                return
            }
            switch currentPage {
            case .login:
            if(emailField.text?.isEmpty == true || passwordField.text?.isEmpty == true ){
               displayError(errorText: "please fill empty fields.")
                
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if(error == nil){
                        self.presentHome()
                        
                    } else {
                        self.displayError(errorText: "wrong userName or password")
                    }
                }
            }
               
                
            case .register:
            if(emailField.text?.isEmpty == true || passwordField.text?.isEmpty == true || userNameField.text?.isEmpty == true){
                displayError(errorText: "please fill empty fields.")
                
            } else {
                
                guard let userName = userNameField.text else {
                    return
                }
                let data: [String: String] = ["username": userName]
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if(error == nil){
                        let db = Database.database().reference()
                        db.child("users").child(result!.user.uid).setValue(data)
                        self.presentHome()
                        
                    } else {
                        
                        self.displayError(errorText: "wrong userName or password")
                    }
                }
            }
             
                
            }
            
        
    
    }
}

