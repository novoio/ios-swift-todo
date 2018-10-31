//
//  TDSettingsVC.swift
//  Todo
//
//  Created by Donovan on 11/17/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit

class TDSettingsVC: UITableViewController, UITextFieldDelegate
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
        
        initContents()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button Events
    
    @IBAction func onBtnMenu(sender: AnyObject)
    {
        TDUtil.appDelegate().menuContainerVC?.anchorTopViewToRightAnimated(true);
    }
    
    @IBAction func onBtnUpdate(sender: AnyObject)
    {
        self.view.endEditing(true);
        
        if doValidation()
        {
            doUpdate();
        }
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
            onBtnUpdate(textField)
        }
        else if textField == txtPassword
        {
            txtConfirm.becomeFirstResponder()
        }
        else
        {
            onBtnUpdate(textField)
        }
        
        return true;
    }
    
    // MARK: - Contents Init Functions
    
    func initContents()
    {
        let user = TDUser.currentUser()!
        
        txtFirstName.text   = user.firstName
        txtLastName.text    = user.lastName
        txtEmail.text       = user.email
    }
    
    func updateCurrentUser()
    {
        let user = TDUser.currentUser()
        
        user?.firstName = txtFirstName.text
        user?.lastName  = txtLastName.text
        user?.email     = txtEmail.text
        
        user?.storeToUserDefaults()
        
        TDUtil.appDelegate().sideMenuVC?.initContents()
    }
    
    // MARK: - Update Logic
    
    func doUpdate()
    {
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        
        let queryParams = [
            "email":                    txtEmail.text,
            "password":                 txtPassword.text,
            "password_confirmation":    txtConfirm.text,
            "first_name":               txtFirstName.text,
            "last_name":                txtLastName.text,
            "token":                    TDUser.currentUser()?.token
        ];
        
        
        let baseURL = NSURL(string: apiRootUrl);
        
        let requestClient = AFHTTPClient(baseURL: baseURL)
        
        let userId = TDUser.currentUser()?.userId
        
        
        requestClient?.putPath(apiUserUrl+"/"+userId!, parameters: queryParams,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
                let responseMessage = TDUtil.messageFromResponseObject(responseObject)
                
                TDUtil.hudWithCheckMark(hud, text: responseMessage).hide(true, afterDelay: 1)
                
                self.updateCurrentUser()
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                
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
        )
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
        
        else if !txtPassword.text.isEmpty || !txtConfirm.text.isEmpty
        {
            // Check password is empty
            if txtPassword.text.isEmpty
            {
                alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please type in password.");
            }
                
            // Check password and confirmation matches
            else if txtPassword.text != txtConfirm.text
            {
                alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please make sure that confirmation matches password.");
            }
        }
        
        if let alert2 = alertController
        {
            presentViewController(alert2, animated: true, completion: nil);
            return false;
        }
        
        return true;
    }
}
