import SwiftUI

struct ListaArticuloView : View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Articulo.nombre, ascending: true)],
        animation: .default
    ) private var articulos: FetchedResults<Articulo>

    @StateObject private var viewModel = TaskViewModel(context: Persistence.shared.container.viewContext)
    @State private var mostrarFormulario = false
    @State private var eliminarArticulo : Articulo?
    
    var body: some View {
        NavigationView {
            VStack {
                if articulos.isEmpty {
                    Text("No hay articulos para comprar")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(articulos) { articuloItem in
                            NavigationLink(destination: DetalleArticuloView(articulo: articuloItem).environment(\.managedObjectContext, viewContext)){
                                HStack {
                                    ArticuloItemView (
                                        nombre: articuloItem.nombre ?? "Sin nombre",
                                        cantidad: articuloItem.cantidad ?? 0,
                                        prioridad: articuloItem.prioridad,
                                        notasAdicionales: articuloItem.notasAdicionales ?? "Sin comentarios"
                                    )
                                    Spacer()
                                    Button(action: {
                                        articuloItem.estado.toggle()
                                        guardarCambios()
                                    }) {
                                        let icon = articuloItem.estado ? "checkmark.circle.fill" : "circle"
                                        let colorIcon = articuloItem.estado ? Color.green : Color.gray
                                        Image(systemName: icon).foregroundColor(colorIcon)
                                    }
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        eliminarArticulo = articuloItem
                                    } label: {
                                        Label("Eliminar", systemImage: "trash")
                                    }
                                }
                                .alert(item: $eliminarArticulo) { articulo in
                                    Alert(
                                        title: Text("Eliminar articulo"),
                                        message: Text("¿Estás seguro de eliminar?"),
                                        primaryButton: .destructive(Text("Eliminar")) {
                                            viewModel.borrarArticulo(articulo)
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Lista de Compras")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        ResumenView(mostrarResumen: $mostrarFormulario)
                    }) {
                        Text("Ver resumen")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        mostrarFormulario = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                FormularioArticuloView(mostrarFormulario: $mostrarFormulario)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
}
