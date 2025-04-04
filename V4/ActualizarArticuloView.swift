import SwiftUI

struct FormularioArticuloView : View {
    @ObservedObject var viewModel: TaskViewModel
    var articulo : Articulo
    @Environment(\.dismiss) private var dismiss 
    
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Cargando listas")
                    .onAppear {
                        Task {
                            await viewModel.fetchOptions()
                            isLoading = false
                        }
                    }
            } else {
                Form {
                    Section (header: Text("Informacion del articulo")) {
                        TextField(placeholder: "Nombre", text: $viewModel.nombre)
                        TextField(placeholder: "Cantidad", text: $viewModel.cantidad, format: .number)
                    }
                    Section (header: Text("Categoria")) {
                        Picker("Selecciona una categoria", selection: $categoria) {
                            ForEach(viewModel.listaCategorias) { item in
                                Text(item.nombre).tag(item as Category?)
                            }
                        }
                    }
                    Section (header: Text("Tienda")) {
                        Picker("Selecciona una tienda", selection: $categoria) {
                            ForEach(viewModel.listaTiendas) { item in
                                Text(item.nombre).tag(item as Store?)
                            }
                        }
                    }
                    Section (header: Text("Prioridad")) {
                        SegmentedControl(selection: $viewModel.prioridad) {
                            Text("Alta").tag(true)
                            Text("Baja").tag(false)
                        }
                    }
                    Section (header: Text("Informacion Adicional")) {
                        TextField(placeholder: "Notas o comentarios", text: $viewModel.notasAdicionales)
                    }
                }
                .navigationBarTitle("Actualizar articulo: \(articulo.nombre)")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Guardar") {
                            viewModel.actualizarArticulo(articulo)
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") {
                            viewModel.resetearValores()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}    
