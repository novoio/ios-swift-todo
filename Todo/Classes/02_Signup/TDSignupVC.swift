//
//  TDSignupVC.swift
//  Todo
//
//  Created by Donovan on 11/17/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit

class TDSignupVC: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var txtFirstName:    UITextField!
    @IBOutlet weak var txtLastName:     UITextField!
    @IBOutlet weak var txtEmail:        UITextField!
    @IBOutlet weak var txtPassword:     UITextField!
    @IBOutlet weak var txtConfirm:      UITextField!
    
    // MARK: - View Controller LifeCycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button Events
    
    @IBAction func onBtnSignup(sender: AnyObject)
    {
        self.view.endEditing(true);
        
        if doValidation()
        {
            doSignup();
        }
    }
    
    @IBAction func onBtnBack(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == txtFirstName
        {
            txtLastName.becomeFirstResponder()
        }
        else if textField == txtLastName
        {
            txtEmail.becomeFirstResponder()
        }
        else if textField == txtEmail
        {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword
        {
            txtConfirm.becomeFirstResponder()
        }
        else
        {
            onBtnSignup(textField);
        }
        
        return true;
    }
    
    // MARK: - Sing-up Logic
    
    func doSignup()
    {
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        
        let queryParams = [
                "email":                    txtEmail.text,
                "password":                 txtPassword.text,
                "password_confirmation":    txtConfirm.text,
                "first_name":               txtFirstName.text,
                "last_name":                txtLastName.text
        ];
        
        
        RKObjectManager.sharedManager().postObject(nil, path: apiUserUrl, parameters: queryParams,
            success: { (operation, mappingResult) -> Void in
                var user: TDUser? = mappingResult.array()[0] as? TDUser;
                
                if let user2 = user
                {
                    self.dismissViewControllerAnimated(false, completion: { () -> Void in
                        TDUtil.appDelegate().loginWithUser(user2)
                    })
                }
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            },
            failure: { (operation, error) -> Void in
                if let errorMessage = error!.localizedRecoverySuggestion
                {
                    let message = TDUtil.messageFromError(error)
                    self.presentViewController(TDUtil.defaultAlert(alertTitleWarning, message: message), animated: true, completion: nil)
                }
                else
                {
                    self.presentViewController(TDUtil.defaultAlert(alertTitleWarning, message: "Please try again."), animated: true, completion: nil)
                }
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        );
    }
    
    func doValidation() -> Bool
    {
        var alertController: UIAlertController?
        
        // Check first name is empty
        if txtFirstName.text.isEmpty
        {
            alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please type in first name.")
        }
        
        // Check last name is empty
        else if txtLastName.text.isEmpty
        {
            alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please type in last name.")
        }
        
        // Check email is empty
        else if txtEmail.text.isEmpty
        {
            alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please type in email.")
        }
        
        // Check email format
        else if !TDUtil.isValidEmail(txtEmail.text)
        {
            alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please type in email of valid format.")
        }
        
        // Check password is empty
        else if txtPassword.text.isEmpty
        {
            alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please type in password.");
        }
        
        // Check password and confirmation matches
        else if txtPassword.text != txtConfirm.text
        {
            alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please make sure that confirmation matches password.");
        }
        
        if let alert2 = alertController
        {
            presentViewController(alert2, animated: true, completion: nil);
            return false;
        }
        
        return true;
    }
}
