import SwiftUI

struct EqEliminados: View {
    
    @State private var noEquipo: String = ""
    @StateObject private var controller = EqEliminadosController()
    
    private var listaFiltrada: [EquipoEliminado] {
        if noEquipo.isEmpty {
            return controller.equipos
        } else {
            return controller.equipos.filter { $0.no_equipo.contains(noEquipo) }
        }
    }
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            Text("Equipos eliminados")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            HStack {
                TextField("Número de equipo", text: $noEquipo)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 25) {
                    
                    ForEach(listaFiltrada) { eq in
                        NavigationLink {
                            DatosEqEliminados(id_equipo: eq.id)
                        } label: {
                            VStack(spacing: 5) {
                                Image(systemName: "laptopcomputer")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.black)
                                
                                Text(eq.no_equipo)
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                .padding(.horizontal)   // AHORA SÍ AQUÍ
            }
            
            Spacer()
        }
        .onAppear {
            controller.obtenerEquiposEliminados { _ in }
        }
    }
}

#Preview {
    EqEliminados()
}
