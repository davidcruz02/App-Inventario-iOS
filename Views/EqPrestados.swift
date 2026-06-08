//DEVOLUCION
//  EqPrestados.swift
//  App UDL
//
//  Created by ADMIN on 06/10/25.
//

import SwiftUI

struct EqPrestados: View {
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            // TÍTULO
            Text("Equipos asignados")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // BUSCADOR + BOTONES
            HStack(spacing: 10) {
                TextField("Buscar...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    // Acción de búsqueda
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Acción QR
                }) {
                    Image(systemName: "qrcode.viewfinder")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            // IMAGEN ABAJO
            HStack(spacing: 40) {
                
                // --- CARTA 1 ---
                VStack(spacing: 1) {
                    ZStack {
                        // Ícono de laptop
                        Image(systemName: "laptopcomputer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.orange)
                        
                        // Imagen dentro de la pantalla
                        Image("Leo1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .offset(y: 0)
                    }
                    
                    // Número de equipo
                    HStack(spacing: 5) {
                        Text("14.")
                            .font(.headline)
                            .fontWeight(.bold)
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                    }
                    
                    // Nombre
                    Text("Julio A. Cartagena")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                // --- CARTA 2 ---
                VStack(spacing: 1) {
                    ZStack {
                        // Ícono de laptop
                        Image(systemName: "laptopcomputer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.orange)
                        
                        // Imagen dentro de la pantalla
                        Image("Leo1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .offset(y: 0)
                    }
                    
                    // Número de equipo
                    HStack(spacing: 5) {
                        Text("18.")
                            .font(.headline)
                            .fontWeight(.bold)
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                    }
                    
                    // Nombre
                    Text("Kenia Castillo")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            .padding(.top, 0)
            Spacer()
            
        }
        .padding()
    }
}

#Preview {
    EqPrestados()
}
