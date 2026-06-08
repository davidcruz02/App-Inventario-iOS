//
//  DatosEqEliminados.swift
//  AppUDL
//
//  Created by ADMIN on 02/12/25.
//

import SwiftUI

struct DatosEqEliminados: View {
    
    let id_equipo: String
    @State private var datos: [String:String] = [:]
    @StateObject private var controller = EqEliminadosController()
    
    var body: some View {
        
        VStack(spacing: 25) {
            
            Text("Datos del equipo")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // Icono
            Image(systemName: "laptopcomputer")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(datos["id_status"] == "2" ? .black : .gray)
                .padding(.top, 100)
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Text("Fecha: \(datos["fecha_baja"] ?? "")")
                        .font(.headline)
                    Spacer()
                    Text("Hora: \(datos["hora_baja"] ?? "")")
                        .font(.headline)
                }
                
                Text("Número de equipo: \(datos["no_equipo"] ?? "")")
                    .font(.headline)
                
                Text("Número de serie: \(datos["no_serie"] ?? "")")
                    .font(.headline)
                
                Text("Modelo: \(datos["modelo"] ?? "")")
                    .font(.headline)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .onAppear {
            controller.obtenerDatosEquipoEliminado(id_equipo: id_equipo) { result in
                switch result {
                case .success(let dict):
                    DispatchQueue.main.async { self.datos = dict }
                case .failure(let err):
                    print("Error → \(err.localizedDescription)")
                }
            }
        }
    }
}


#Preview {
    DatosEqEliminados(id_equipo: "1235")
}
