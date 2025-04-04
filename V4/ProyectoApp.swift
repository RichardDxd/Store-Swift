//
//  ProyectoApp.swift
//  Proyecto
//
//  Created by DAMII on 15/12/24.
//

import SwiftUI

@main
struct ProyectoApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ListaArticuloView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
