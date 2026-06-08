//
//  DetallesEq.swift
//  AppUDL
//
//  Created by ADMIN on 20/11/25.
//

import SwiftUI

struct DetallesEq: View {
    
    @EnvironmentObject var sesion: UsuarioSesion


    var id_equipo: String    // <--- Recibimos el ID enviado

    @State private var serie: String = ""
    @State private var modelo: String = ""
    @State private var noEquipo: String = ""
    @State private var status: String = "Prestamo"

    var body: some View {

        VStack(spacing: 20) {

            // NAV
            HStack {
                Image("NavLog")
                    .resizable()
                    .frame(width: 80, height: 80)

                Spacer()

                Text("Detalles de Equipo")
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                Image("NavLog")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            .padding(.horizontal, 20)
            .frame(height: 80)
            .background(Color.black)

            ScrollView {

                VStack(spacing: 25) {

                    Image(systemName: "laptopcomputer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .foregroundColor(colorParaStatus(status))
                        .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 15) {

                        HStack {
                            Text("No. de Serie:")
                                .fontWeight(.bold)
                            TextField("Escribe el número de serie", text: $serie)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        HStack {
                            Text("Modelo:")
                                .fontWeight(.bold)
                            TextField("Escribe el modelo", text: $modelo)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Status:")
                                .fontWeight(.bold)

                            Picker("Selecciona status", selection: $status) {

                                // Devuelta
                                Text("Devuelta").tag("5")

                                // Reparación
                                Text("Reparación").tag("1")

                                // Baja
                                Text("Baja").tag("2")
                                //Text("Prestamo").tag("4")
                                // Prestamo → SOLO se muestra si el equipo viene prestado
                                 
                                
                                if status == "4" {
                                   Text("Prestamo").tag("4")
                               }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .disabled(status == "4")   // 🔥 sigue aplicándose si ya está prestado

                            
                            
                        }

                        HStack {
                            Text("No. de Equipo:")
                                .fontWeight(.bold)
                            TextField("Escribe el número de equipo", text: $noEquipo)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding(.horizontal, 30)

                    HStack(spacing: 30) {
                        Button(action: {

                            if status == "4" {
                                print("⛔ No se puede actualizar — equipo prestado")
                                return
                            }

                            let correo = sesion.usuario?.correo ?? ""

                            print("📡 MANDANDO DATOS:")
                            print("id_equipo:", id_equipo)
                            print("no_equipo:", noEquipo)
                            print("modelo:", modelo)
                            print("no_serie:", serie)
                            print("id_status:", status)
                            print("correo:", correo)

                            AjustesController().actualizarInformaciondelEquipo(
                                id_equipo: id_equipo,
                                no_equipo: noEquipo,
                                modelo: modelo,
                                no_serie: serie,
                                id_status: status,
                                correo: correo
                            ) { resultado in

                                switch resultado {

                                case .success(let mensaje):
                                    print("✅ RESPUESTA WS:", mensaje)

                                case .failure(let err):
                                    print("❌ ERROR:", err)
                                }
                            }

                        }) {
                            Text("Actualizar")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 25)
                                .background(Color.green)
                                .cornerRadius(8)
                        }


                        Button(action: {}) {
                            NavigationLink(destination: masDetallesEq(id_equipo: id_equipo)) {
                                Text("Detalles")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 25)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }

                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
        .padding(.bottom)
        .onAppear {
            print("📦 Llegó a DetallesEq con id_equipo:", id_equipo)

            AjustesController().obtenerDatosEquipoCompleto(id_equipo: id_equipo) { resultado in
                switch resultado {

                case .success(let json):
                    print("🔥 Datos completos recibidos:", json)

                    DispatchQueue.main.async {
                        self.serie = "\(json["no_serie"] ?? "")"
                        self.modelo = "\(json["modelo"] ?? "")"
                        self.noEquipo = "\(json["no_equipo"] ?? "")"

                        // status = es texto, así que lo mapearemos ya que el WS regresa números
                        if let idStatus = json["id_status"] {
                            self.status = "\(idStatus)"
                        }

                    }

                case .failure(let err):
                    print("❌ Error al obtener datos completos:", err)
                }
            }
        }

    }
}

func colorParaStatus(_ id: String) -> Color {
    switch id {
    case "1": return .gray
    case "2": return .black
    case "3": return .red
    case "4": return .orange
    case "5": return .green
    default: return .gray
    }
}

#Preview {
    DetallesEq(id_equipo: "")
}
