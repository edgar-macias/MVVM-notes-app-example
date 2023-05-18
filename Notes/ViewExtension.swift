//
//  ViewExtension.swift
//  Notes
//
//  Created by Edgar Macias on 18/12/22.
//

import SwiftUI

extension View {
    func hideKeyboard(){
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
