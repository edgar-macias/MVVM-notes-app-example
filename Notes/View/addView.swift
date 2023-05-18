//
//  addView.swift
//  Notes
//
//  Created by Edgar Macias on 17/12/22.
//

import SwiftUI

struct addView: View {
    
    @ObservedObject var model : ViewModel
    @Environment(\.managedObjectContext) var context
    @State private var showAlert = false
    @State private var datePickerId:Int = 0
    
    var body: some View {
        VStack{
            Spacer()
            Text(model.updateItem == nil ? "Agregar nota" : "Editar nota")
                .font(.largeTitle)
                .bold()
            Spacer()
            TextField("Titulo",text: $model.titulo).font(.title).foregroundColor(Color("FontColor"))
            Divider()
            TextEditor(text: $model.nota)
            Divider()
            DatePicker("Seleccionar fecha", selection: $model.fecha)
                .id(datePickerId)
                .onChange(of: model.fecha){ newDate in 
                    datePickerId += 1
            }
            Spacer()
            Button(action: {
                
                if(model.titulo==""){
                    showAlert.toggle()
                } else {
                    if model.updateItem != nil {
                        model.editData(context: context)
                    } else {
                        model.saveData(context: context)
                    }
                }
            }){
                Label(
                    title: {Text("Guardar").foregroundColor(.white).bold()},
                    icon: {Image(systemName: "plus").foregroundColor(.white)})
            }.padding()
             .frame(width: UIScreen.main.bounds.width - 30)
             .background(model.nota == "" ? Color.gray : Color.blue)
             .cornerRadius(8)
             .disabled(model.nota == "" ? true : false)
             .alert("El titulo de la nota es requerido", isPresented: $showAlert, actions:{
                 Button("OK", role:.cancel){ }
             })
            
        }.onTapGesture {
            hideKeyboard()
        }.padding()
    }
}
