//
//  AppDelegate.swift
//  Todo
//
//  Created by Donovan on 11/17/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TDMenuVCDelegate
{

    var window: UIWindow?
    var menuContainerVC: ECSlidingViewController?
    var sideMenuVC: TDMenuVC?
    
    // MARK: - App Init
    
    func initApp()
    {
        configureRestKit();
        
        if let user = TDUser.currentUser()
        {
            setupSceneOnLoggedIn();
        }
    }
    
    // MARK: - Log-in-Log-out Function
    
    func setupSceneOnLoggedIn()
    {
        window?.rootViewController = getMenuContainerVC();
    }
    
    func setupSceneOnLoggedOut()
    {
        window?.rootViewController = TDUtil.instantiateViewControllerWithIdentifier(SBID_TDLoginVC) as? UIViewController;
    }
    
    func loginWithUser(user: TDUser)
    {
        user.storeToUserDefaults()
        
        setupSceneOnLoggedIn();
    }
    
    func logout()
    {
        TDUser.currentUser()?.clearFromUserDefaults();
        
        menuContainerVC = nil
        sideMenuVC      = nil
        
        setupSceneOnLoggedOut();
    }
    
    // MARK: - Getter For View Controllers
    
    func getMenuContainerVC() -> ECSlidingViewController
    {
        if (menuContainerVC == nil)
        {
            let nc = TDUtil.instantiateViewControllerWithIdentifier(SBID_TDTasksNC) as? UINavigationController;
            menuContainerVC = ECSlidingViewController.slidingWithTopViewController(nc);
            menuContainerVC?.underLeftViewController = getSideMenuVC();
            menuContainerVC?.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesture.Tapping;
            menuContainerVC?.topViewControllerStoryboardId = SBID_TDTasksNC;
        }
        
        return menuContainerVC!;
    }
    
    func getSideMenuVC() -> TDMenuVC
    {
        if (sideMenuVC == nil)
        {
            sideMenuVC = TDUtil .instantiateViewControllerWithIdentifier(SBID_TDMenuVC) as? TDMenuVC;
            sideMenuVC?.delegate = self;
        }
        
        return sideMenuVC!;
    }
    
    // MARK: - TDMenuVCDelegate
    func sideMenuVCDidSelectItem(title: String)
    {
        var storyboardID = "";
        
        if (title == kTDSideMenuItemTitleTasks)
        {
            storyboardID = SBID_TDTasksNC;
        }
        else if (title == kTDSideMenuItemTitleSettings)
        {
            storyboardID = SBID_TDSettingsNC;
        }
        else if (title == kTDSideMenuItemTitleLogout)
        {
            logout();
            return;
        }
        
        if (storyboardID == menuContainerVC?.topViewControllerStoryboardId)
        {
            menuContainerVC?.resetTopViewAnimated(true);
            return;
        }
        
        menuContainerVC?.resetTopViewAnimated(true);
        
        var nc: UINavigationController? = TDUtil.instantiateViewControllerWithIdentifier(storyboardID) as? UINavigationController;
      
        menuContainerVC?.resetTopViewAnimated(true, onComplete: { () -> Void in
            println();
            self.menuContainerVC?.topViewControllerStoryboardId = storyboardID;
            self.menuContainerVC?.topViewController = nc;
        });
    }
    
    // MARK: - RestKit Functions
    
    func configureRestKit()
    {
        let baseURL = NSURL(string: apiRootUrl);
        let client = AFHTTPClient(baseURL: baseURL)
        
        let objectManager = RKObjectManager(HTTPClient: client)
        
        // register mappings with the provider using a response descriptor for User Log-in
        let responseDescriptor1 = RKResponseDescriptor(mapping: TDMappingProvider.userMapping(), method: RKRequestMethod.POST, pathPattern: apiSessionUrl, keyPath: "", statusCodes: NSIndexSet(index: 200))
        
        objectManager.addResponseDescriptor(responseDescriptor1)
        
        // register mappings with the provider using a response descriptor for Sign-up
        let responseDescriptor2 = RKResponseDescriptor(mapping: TDMappingProvider.userMapping(), method: RKRequestMethod.POST, pathPattern: apiUserUrl, keyPath: "", statusCodes: NSIndexSet(index: 200))
        
        objectManager.addResponseDescriptor(responseDescriptor2)
        
        // register mappings with the provider using a response descriptor for Load Tasks in Tasks Page
        let responseDescriptor3 = RKResponseDescriptor(mapping: TDMappingProvider.taskMapping(), method: RKRequestMethod.GET, pathPattern: apiTaskUrl, keyPath: "tasks", statusCodes: NSIndexSet(index: 200))
        
        objectManager.addResponseDescriptor(responseDescriptor3)
        
        // register mappings with the provider using a response descriptor for Add New Task
        let responseDescriptor4 = RKResponseDescriptor(mapping: TDMappingProvider.taskMapping(), method: RKRequestMethod.POST, pathPattern: apiTaskUrl, keyPath: "", statusCodes: NSIndexSet(index: 200))
        
        objectManager.addResponseDescriptor(responseDescriptor4)
    }
    
    // MARK: - App LifeCycle

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        initApp();
        
        return true
    }

    func applicationWillResignActive(application: UIApplication)
    {
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
    }

    func applicationWillTerminate(application: UIApplication)
    {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "donovan.Todo" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Todo", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Todo.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

