//
//  TDLoginVC.swift
//  Todo
//
//  Created by Donovan on 11/17/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit

class TDLoginVC: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var txtEmail:    UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
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
    
    @IBAction func onBtnLogin(sender: AnyObject)
    {
        self.view.endEditing(true);
        
        if doValidation()
        {
            doLogin();
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == txtEmail
        {
            txtPassword.becomeFirstResponder();
        }
        else
        {
            onBtnLogin(textField);
        }
        return true;
    }
    
    // MARK: - Login Logic
    
    func doLogin()
    {
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        
        let queryParams = [
            "email":    txtEmail.text,
            "password": txtPassword.text,
        ];
        
        
        RKObjectManager.sharedManager().postObject(nil, path: apiSessionUrl, parameters: queryParams,
            success: { (operation, mappingResult) -> Void in
                var user: TDUser? = mappingResult.array()[0] as? TDUser;
                
                if let user2 = user
                {
                    TDUtil.appDelegate().loginWithUser(user2)
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
        
        // Check email is empty
        if txtEmail.text.isEmpty
        {
            alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please type in email.")
        }
        
        // Check email format
        if !TDUtil.isValidEmail(txtEmail.text)
        {
            alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please type in email of valid format.");
        }
        
        // Check password is empty
        if txtPassword.text.isEmpty
        {
            alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please type in password.")
        }
        
        if let alert2 = alertController
        {
            presentViewController(alert2, animated: true, completion: nil);
            return false;
        }
        
        return true;
    }
}
