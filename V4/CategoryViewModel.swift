import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    @Published var nombre: String = ""
    @Published var cantidad: Int16 = 0
    @Published var categoria: Category? = nil
    @Published var tienda: Store? = nil
    @Published var prioridad: Bool = false
    @Published var notasAdicionales: String = ""
    @Published var estado: Bool = false
    
    @Published var listaCategorias: [Category] = []
    @Published var listaTiendas: [Store] = []
    
    let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func fetchOptions() async {
        do {
            self.listaCategorias = try await APIService.shared.getCategories()
            self.listaTiendas = try await APIService.shared.getStores()
        } catch {
            print("Error al cargar las listas: \(error.localizedDescription)")
        }
    }

    func crearArticulo() {
        let nuevoArticulo = Articulo(context: viewContext)
        nuevoArticulo.id = UUID()
        nuevoArticulo.nombre = nombre
        nuevoArticulo.cantidad = cantidad
        nuevoArticulo.categoria = categoria?.nombre ?? "N/A"
        nuevoArticulo.tienda = tienda?.nombre ?? "N/A"
        nuevoArticulo.prioridad = prioridad
        nuevoArticulo.notasAdicionales = notasAdicionales
        nuevoArticulo.estado = estado
        guardarCambios()
        resetearValores()
    }

    func actualizarArticulo(articuloSeleccionado: Articulo) {
        let actualizarArticulo = Articulo(context: viewContext)
        actualizarArticulo.nombre = nombre
        actualizarArticulo.cantidad = cantidad
        actualizarArticulo.categoria = categoria?.nombre ?? actualizarArticulo.categoria
        actualizarArticulo.tienda = tienda?.nombre ?? actualizarArticulo.tienda
        actualizarArticulo.prioridad = prioridad
        actualizarArticulo.notasAdicionales = notasAdicionales
        guardarCambios()
        resetearValores()
    }
    
    func borrarArticulo(articulo: Articulo) {
        viewContext.delete(articulo)
        guardarCambios()
    }
    
    private func guardarCambios() {
        do {
            try viewContext.save()
        } catch {
            print("Error al guardar los cambios: \(error.localizedDescription)")
        }
    }
    
    func resetearValores() {
        nombre = ""
        cantidad = 0
        categoria = nil
        tienda = nil
        prioridad = false
        notasAdicionales = ""
        estado = false
    }
}