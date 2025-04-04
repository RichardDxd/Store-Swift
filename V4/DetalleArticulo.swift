import SwiftUI

struct DetalleArticuloView : View {
    @ObservedObject var viewModel: TaskViewModel
    var articulo : Articulo
    @Environment(\.dismiss) private var dismiss 
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Nombre: \(articulo.nombre ?? "Sin nombre")")
                    .font(.headline)
                Text("Categoria: \(articulo.categoria ?? "Sin Categoria")")
                    .font(.subheadline)
                Text("Tienda: \(articulo.tienda ?? "Sin tiendas")")
                    .font(.subheadline)
                Text("Prioridad: \(articulo.prioridad ? "Alta" : "Baja")")
                    .font(.subheadline)
                Text("Estado: \(articulo.estado ? "Comprado" : "Pendiente")")
                    .font(.subheadline)
                Text("Notas adicionales: \(articulo.notasAdicionales ?? "Sin comentarios")")
                    .font(.body)
                Spacer()
            }
            .padding()
            .navigationTitle(articulo.nombre ?? "Sin nombre")
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Eliminar") {
                        viewModel.eliminarArticulo(articulo)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Editar") {
                        ActualizarArticuloView(articulo: articulo)
                    }
                }
            }
        }
    }
}
