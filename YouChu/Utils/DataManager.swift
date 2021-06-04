//
//  DataManager.swift
//  YouChu
//
//  Created by 김현식 on 2021/06/04.
//

import CoreData
import UIKit

open class DataManager: NSObject {

    public static let sharedInstance = DataManager()

    private lazy var userEntity: NSEntityDescription = {
        let managedContext = getContext()
        return NSEntityDescription.entity(forEntityName: "CdUser", in: managedContext!)!
    }()

    private override init() {}

    // Helper func for getting the current context.
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }

    func retrieveUser() -> NSManagedObject? {
        guard let managedContext = getContext() else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CdUser")

        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            if result.count > 0 {
                // Assuming there will only ever be one User in the app.
                return result[0]
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Retrieving user failed. \(error): \(error.userInfo)")
           return nil
        }
    }

    func saveChannels(_ channels: [Channel]) {
        guard let managedContext = getContext() else { return }
        guard let user = retrieveUser() else { return }
        user.setValue(channels, forKey: "recommendChannels")

        do {
            print("Saving session...")
            try managedContext.save()
        } catch let error as NSError {
            print("Failed to save session data! \(error): \(error.userInfo)")
        }
    }

    func deleteUser() {
        guard let managedContext = getContext() else {
            return
        }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CdUser")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("ERROR \(error)")
        }
    }

    func createUser() {
        guard let managedContext = getContext() else { return }
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Failed to save new user! \(error): \(error.userInfo)")
        }
    }

}
