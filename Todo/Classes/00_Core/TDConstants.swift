//
//  TDData.swift
//  Todo
//
//  Created by Donovan on 11/17/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit

// MARK: - Backend API URL
let apiRootUrl      = "https://donovan-rails-todo-api.herokuapp.com"
let apiSessionUrl   = "/api/v1/sessions"
let apiUserUrl      = "/api/v1/users"
let apiTaskUrl      = "/api/v1/tasks"

// MARK: - Storyboard IDs

let SBID_TDMenuVC       = "SBID_TDMenuVC"
let SBID_TDLoginVC      = "SBID_TDLoginVC"
let SBID_TDSignupNC     = "SBID_TDSignupNC"
let SBID_TDSignupVC     = "SBID_TDSignupVC"
let SBID_TDSettingsNC   = "SBID_TDSettingsNC"
let SBID_TDSettingsVC   = "SBID_TDSettingsVC"
let SBID_TDTasksNC      = "SBID_TDTasksNC"
let SBID_TDTasksVC      = "SBID_TDTasksVC"
let SBID_TDAddTaskNC    = "SBID_TDAddTaskNC"
let SBID_TDAddTaskVC    = "SBID_TDAddTaskVC"

// MARK: - Side Menu Titles
let kTDSideMenuItemTitleTasks       = "Tasks"
let kTDSideMenuItemTitleSettings    = "Settings"
let kTDSideMenuItemTitleLogout      = "Log out"

// MARK: - Alert Constants
let alertTitleWarning   = "Warning"
let alertDefaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)

// MARK: - NSUserDefaults Constants
let kNSUserDefaultsCurrentUserKey = "current_user"

// MARK: - Common Resources
let COMMON_IMAGE_HUD_CHECKMARK = "00_hud_checkmark"