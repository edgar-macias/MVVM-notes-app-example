//
//  ViewModel.swift
//  Notes
//
//  Created by Edgar Macias on 17/12/22.
//

import CoreData
import SwiftUI
import CoreData

class ViewModel: ObservableObject {
    
    @Published var titulo = ""
    @Published var nota = ""
    @Published var fecha = Date()
    @Published var show = false
    @Published var updateItem : Notes!
    
    //CoreData
    
    func restoreData(){
        updateItem = nil
        titulo = ""
        nota = ""
        fecha = Date()
    }
    
    func saveData(context: NSManagedObjectContext){
        let newNote = Notes(context: context)
        newNote.title = titulo
        newNote.note = nota
        newNote.date = fecha
        
        do {
            try context.save()
            restoreData()
            show.toggle()
        } catch let error as NSError {
            print("No guardo",error.localizedDescription)
        }
    }
    
    func deleteData(item:Notes,context:NSManagedObjectContext){
        context.delete(item)
        do {
            try context.save()
        } catch let error as NSError {
            print("No elimino",error.localizedDescription)
        }
    }
    
    func sendData(item : Notes){
        updateItem = item
        titulo = item.title ?? ""
        nota = item.note ?? ""
        fecha = item.date ?? Date()
        show.toggle()
    }
    
    func editData(context:NSManagedObjectContext){
        updateItem.title = titulo
        updateItem.date = fecha
        updateItem.note = nota
        do {
            try context.save()
            restoreData()
            show.toggle()
        } catch let error as NSError {
            print("No edito",error.localizedDescription)
        }
    }
}
