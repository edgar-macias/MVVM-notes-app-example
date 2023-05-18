//
//  Home.swift
//  Notes
//
//  Created by Edgar Macias on 17/12/22.
//

import SwiftUI

struct Home: View {
    
    @StateObject var model = ViewModel()
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Notes.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)],animation: .spring()) var results : FetchedResults<Notes>
    
    @State private var selectedDate = Date()
    @State private var datePickerId: Int = 0
    
    var body: some View {
        NavigationView{
            VStack{
                HStack {
                    DatePicker(selection: $selectedDate,displayedComponents: [.date]) {
                        Text("Buscar por fecha")
                    }.id(datePickerId)
                        .onChange(of: selectedDate){newDate in
                            selectedDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: newDate)!
                            datePickerId += 1
                        }
                    Button(action: {
                        results.nsPredicate = NSPredicate(format: "date >= %@ AND date <= %@",
                                                          Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)! as NSDate,
                                                          Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)! as NSDate
                        )
                    }){
                        Image(systemName: "magnifyingglass").font(.title3).foregroundColor(.blue)
                    }
                }.padding(20)
                List{
                    ForEach(results){ item in
                        VStack(alignment: .leading, spacing: 1, content: {
                            Text(item.title ?? "Sin Titulo")
                                .font(.title)
                                .bold()
                            Text(item.note ?? "Sin nota")
                                .font(.title3)
                            Text(item.date ?? Date(), style:.date)
                        }).contextMenu(ContextMenu(menuItems: {
                            Button(action:{
                                model.sendData(item: item)
                            }){
                                Label(title:{
                                    Text("Editar")
                                },icon:{
                                    Image(systemName: "pencil")
                                })
                            }
                            Button(action:{
                                model.deleteData(item: item, context: context)
                            }){
                                Label(title:{
                                    Text("Eliminar")
                                },icon:{
                                    Image(systemName: "trash")
                                })
                            }
                        }))
                    }
                    
                }
            }.navigationTitle("Notas")
                .toolbar{
                    Button(action: {
                        if model.updateItem != nil {
                            model.restoreData()
                        }
                        model.show.toggle()
                    }){
                        Image(systemName: "plus").font(.title3).foregroundColor(.blue)
                    }
                }.sheet(isPresented: $model.show, content: {
                    addView(model: model)
                })
        }
        
    }
}
