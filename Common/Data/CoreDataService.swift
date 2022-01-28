//
//  Service.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 28.01.22.
//

import Foundation
import CoreData
import SwiftUI

protocol CoreDataServiceProtocol {
    static var shared: CoreDataServiceProtocol { get }
    
    func fetchQrCodes() -> [QrModel]
    func insertQrCode(_ qr: QrModel)
    func removeQrCode(id: UUID)
}

class CoreDataService: CoreDataServiceProtocol {
    
    static var shared: CoreDataServiceProtocol = CoreDataService.init()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: UserDefaultsConstants.suiteId)!
        let storeURL = containerURL.appendingPathComponent("MainDb.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)

        let container = NSPersistentContainer(name: "MainDb")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func fetchQrCodes() -> [QrModel] {
        let context = persistentContainer.newBackgroundContext()
        let fr = QrCodeMO.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor(key: #keyPath(QrCodeMO.createdAt), ascending: false)]
        
        do {
            let fetchedQrs = try context.fetch(fr)
            return fetchedQrs.map { QrModel(id: $0.id?.uuidString ?? "", name: $0.name ?? "", content: $0.content ?? "") }
        } catch {
            fatalError("Failed to fetch qrs: \(error)")
        }
    }
    
    func insertQrCode(_ qr: QrModel) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let newQr = NSEntityDescription.insertNewObject(forEntityName: "QrCode", into: context) as! QrCodeMO
            newQr.id = UUID()
            newQr.name = qr.name
            newQr.content = qr.content
            newQr.createdAt = Date()
            
            context.insert(newQr)
            do {
                try context.save()
            } catch {
                fatalError("Failed to save qr: \(error)")
            }
        }
    }
    
    func removeQrCode(id: UUID) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let fr = NSFetchRequest<QrCodeMO>(entityName: "QrCode")
            fr.predicate = NSPredicate(format: "firstName == %@", id as NSUUID)
            
            let fetchedQr = try? context.fetch(fr)
            guard let fetchedQr = fetchedQr?.first else {
                return
            }
            context.delete(fetchedQr)
            do {
                try context.save()
            } catch {
                fatalError("Failed to remove qr: \(error)")
            }
        }
    }
}
