//PRESTAMO

import SwiftUI

struct EqDisponibles: View {
    @State private var searchText: String = ""

    var body: some View {
        VStack(spacing: 20) {
            
            // Primer renglón: título
            Text("Equipos Disponibles")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // Campo de búsqueda con botón al lado
            HStack {
                TextField("Buscar...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    // Acción de búsqueda (vacía por ahora)
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)

            // Icono de laptop con número debajo
            VStack(spacing: 8) {
                Button(action: {
                    // Acción al presionar laptop
                }) {
                    Image(systemName: "laptopcomputer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green)
                        .buttonStyle(.plain) // Sin borde ni color adicional
                }
                
                Text("14")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    EqDisponibles()
}

