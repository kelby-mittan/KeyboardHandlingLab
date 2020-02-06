//
//  ViewController.swift
//  KeyboardHandlingLab
//
//  Created by Kelby Mittan on 2/5/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var stackViewYConstraint: NSLayoutConstraint!
    
    private var keyboardIsVisible = false
    
    private var originalYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterForKeyboardNotifications()
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return
        }
        
        moveKeyboardUp(keyboardFrame.size.height)
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        resetUI()
    }
    
    private func moveKeyboardUp(_ height: CGFloat) {
        
        if keyboardIsVisible { return }
        
        originalYConstraint = stackViewYConstraint
        
        stackViewYConstraint.constant -= (height * 1.0)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        keyboardIsVisible = true
    }
    
    private func resetUI() {
        keyboardIsVisible = false
        
        stackViewYConstraint.constant -= originalYConstraint.constant + 80
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }


}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

