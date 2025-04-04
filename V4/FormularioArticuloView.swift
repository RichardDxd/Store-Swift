import SwiftUI

struct FormularioArticuloView : View {
    @ObservedObject var viewModel: TaskViewModel
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
                .navigationBarTitle("Formulario de Registro de Articulo")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Guardar") {
                            viewModel.crearArticulo()
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
