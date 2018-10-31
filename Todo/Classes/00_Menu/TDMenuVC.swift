//
//  TDMenuVC.swift
//  Todo
//
//  Created by Donovan on 11/17/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit

protocol TDMenuVCDelegate
{
    func sideMenuVCDidSelectItem(title: String);
}

class TDMenuVC: UITableViewController
{
    var delegate: TDMenuVCDelegate?;
    
    @IBOutlet weak var labelName: UILabel!
    
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
    
    // MARK: - Init Functions
    
    func initContents()
    {
        labelName.text = TDUser.currentUser()?.fullName()
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        
        if (indexPath.row == 3)
        {
            delegate?.sideMenuVCDidSelectItem(kTDSideMenuItemTitleTasks);
        }
        else if (indexPath.row == 4)
        {
            delegate?.sideMenuVCDidSelectItem(kTDSideMenuItemTitleSettings);
        }
        else if (indexPath.row == 6)
        {
            delegate?.sideMenuVCDidSelectItem(kTDSideMenuItemTitleLogout);
        }
    }
}
