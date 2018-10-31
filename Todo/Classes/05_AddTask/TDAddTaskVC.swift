//
//  TDAddTaskVC.swift
//  Todo
//
//  Created by Donovan on 11/19/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit

protocol TDAddTaskVCDelegate
{
    func addTaskVCDidCreateTask(task: TDTask)
}

class TDAddTaskVC: UITableViewController, UITextFieldDelegate
{
    var delegate: TDAddTaskVCDelegate?
    
    @IBOutlet weak var txtTitle:    UITextField!

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
    
    @IBAction func onBtnBack(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func onBtnAdd(sender: AnyObject)
    {
        self.view.endEditing(true);
        
        if doValidation()
        {
            doAddTask();
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        onBtnAdd(textField);
        return true;
    }
    
    // MARK: - Sing-up Logic
    
    func doAddTask()
    {
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        
        let queryParams = [
            "title":                    txtTitle.text,
            "token":                    TDUser.currentUser()?.token
        ];
        
        
        RKObjectManager.sharedManager().postObject(nil, path: apiTaskUrl, parameters: queryParams,
            success: { (operation, mappingResult) -> Void in
                var task: TDTask? = mappingResult.array()[0] as? TDTask;
                
                if let task2 = task
                {
                    self.delegate?.addTaskVCDidCreateTask(task2)
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
        
        // Check title is empty
        if txtTitle.text.isEmpty
        {
            alertController = TDUtil.defaultAlert(alertTitleWarning, message: "Please type in title.")
        }
        
        if let alert2 = alertController
        {
            presentViewController(alert2, animated: true, completion: nil);
            return false;
        }
        
        return true;
    }
}
