//
//  ResumenView.swift
//  Proyecto
//
//  Created by DAMII on 15/12/24.
//

import SwiftUI

struct ResumenView : View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Articulo.nombre, ascending: true)],
        animation: .default
    ) private var articulos: FetchedResults<Articulo>

    @Binding var mostrarResumen: Bool

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Text("Articulos comprados")
                    ForEach(articulos) { articuloItem in
                        HStack {
                            ArticuloItemView (
                                nombre: articuloItem.nombre ?? "Sin nombre",
                                cantidad: articuloItem.cantidad ?? 0,
                                prioridad: articuloItem.prioridad,
                                notasAdicionales: articuloItem.notasAdicionales ?? ""
                            )
                        }
                    }
                    let articulosComprados = articulos.filter { articulo in
                        articulo.estado == true
                    }.count ?? 0
                    Text("\(articulosComprados) articulos comprados")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                }
                .navigationBarTitle("Articulos comprados")
                Spacer()
                List {
                    ForEach(articulos) { articuloItem in
                        HStack {
                            ArticuloItemView (
                                nombre: articuloItem.nombre ?? "Sin nombre",
                                cantidad: articuloItem.cantidad ?? 0,
                                prioridad: articuloItem.prioridad,
                                notasAdicionales: articuloItem.notasAdicionales ?? ""
                            )
                        }
                    }
                    let articulosPendientes = articulos.filter { articulo in
                        articulo.estado == false
                    }.count ?? 0
                    Text("\(articulosPendientes) articulos pendientes")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                }
                .navigationBarTitle("Articulos comprados")
            }
            .navigationBarTitle("Progreso de las compras")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        mostrarResumen = false
                    }
                }
            }
        }
    }
}
