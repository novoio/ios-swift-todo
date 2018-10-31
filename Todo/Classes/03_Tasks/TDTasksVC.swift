//
//  TDTasksVC.swift
//  Todo
//
//  Created by Donovan on 11/17/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit

let TaskCellID      = "TaskCell"
let SEGID_AddTask   = "SEGID_AddTask"

class TDTasksVC: UITableViewController, TDTaskCellDelegate, TDAddTaskVCDelegate
{
    var dataSource: Array<TDTask>!
    
    // MARK: - View Controller LifeCycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadTasks()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button Events
    
    @IBAction func onBtnMenu(sender: AnyObject)
    {
        TDUtil.appDelegate().menuContainerVC?.anchorTopViewToRightAnimated(true)
    }
    
    // MARK: - Load Tasks Functions
    
    func loadTasks()
    {
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        
        var token: String? = TDUser.currentUser()?.token
        
        let queryParams = [
            "token":   token!
        ]
        
        RKObjectManager.sharedManager().getObjectsAtPath(apiTaskUrl, parameters: queryParams,
            success: { (operation, mappingResult) -> Void in
                
                self.dataSource = mappingResult.array() as? Array<TDTask>
                self.tableView.reloadData()
                
                TDUtil.hudWithCheckMark(hud, text: "").hide(true, afterDelay: 1)
                
            }, failure: { (operation, error) -> Void in
                
                self.presentViewController(TDUtil.defaultAlert(alertTitleWarning, message: "Please try again."), animated: true, completion: nil)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        )
    }
    
    // MARK: - Update a Task
    
    func updateTaskStatus(cell: TDTaskCell, task: TDTask)
    {
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        
        var token: String? = TDUser.currentUser()?.token
        
        let queryParams = [
            "title":                    task.title!,
            "completed":                true,
            "token":                    token!
        ];
        
        let baseURL       = NSURL(string: apiRootUrl);
        let requestClient = AFHTTPClient(baseURL: baseURL)
        
        let taskId = task.taskId
        
        requestClient?.putPath(apiTaskUrl+"/"+taskId!, parameters: queryParams,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                
                let responseMessage = TDUtil.messageFromResponseObject(responseObject)
                
                TDUtil.hudWithCheckMark(hud, text: responseMessage).hide(true, afterDelay: 1)
                
                task.completed = true
                
                cell.updateStatusWitTask(task)
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
    
    // MARK: - TDTaskCellDelegate
    
    func taskCellDidClickDone(cell: TDTaskCell)
    {
        let indexPath = tableView.indexPathForCell(cell)
        
        let task = objectAtIndexPath(indexPath!);
        
        updateTaskStatus(cell, task: task)
    }
    
    // MARK: - TDAddTaskVCDelegate
    func addTaskVCDidCreateTask(task: TDTask)
    {
        let hud = MBProgressHUD(forView: self.view)
        hud.show(true)
        TDUtil.hudWithCheckMark(hud, text: "New Task Created.").hide(true, afterDelay: 1)
        
        dataSource.insert(task, atIndex: 0)
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: - Table view data source
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> TDTask
    {
        let task = dataSource?[indexPath.row]
        
        return task!
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let count = dataSource?.count
        {
            return count
        }
        return 0;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(TaskCellID, forIndexPath: indexPath) as TDTaskCell
        
        let task = objectAtIndexPath(indexPath)
        
        cell.configureCellWithTask(task)
        cell.delegate = self;

        return cell
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == SEGID_AddTask
        {
            let vc = TDUtil.vcFromSegue(segue) as TDAddTaskVC
            vc.delegate = self
        }
    }
}
