//
//  DevolucionEq.swift
//  App UDL
//
//  Created by ADMIN on 06/10/25.
//

import SwiftUI

struct DevolucionEq: View {
    var body: some View {
        VStack(spacing: 20) {
            
            // Barra superior amarilla con logos a los lados
            HStack {
                Image("LogNav")
                    .resizable()
                    .frame(width: 80, height: 80)
                
                Spacer()
                
                Text("Devolucion")
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                Image("LogNav")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            .padding(.horizontal, 20)
            .frame(height: 60)
            .background(Color.green)

            
            // Imagen centrada del alumno
            Image("Leo1")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(.top, 20)
            
            // Pregunta
            Text("¿Quieres regresar el equipo?")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            // Información del alumno
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("No. de equipo:")
                        .fontWeight(.bold)
                    Text("14")
                }
                HStack {
                    Text("Matrícula:")
                        .fontWeight(.bold)
                    Text("158689")
                }
                HStack {
                    Text("Nombre:")
                        .fontWeight(.bold)
                    Text("Julio A. Cartagena Vazquez")
                }
                HStack {
                    Text("Grupo:")
                        .fontWeight(.bold)
                    Text("9001")
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, 10)
            
            // Botones
            HStack(spacing: 30) {
                Button(action: {}) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.green)
                        .clipShape(Circle())
                }
                
                Button(action: {}) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
            .padding(.top, 20)
            
            Spacer()
        }
    }
}

#Preview {
    DevolucionEq()

}
