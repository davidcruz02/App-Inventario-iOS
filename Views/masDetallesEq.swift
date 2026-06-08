//
//  masDetallesEq.swift
//  AppUDL
//
//  Created by ADMIN on 08/10/25.
//

import SwiftUI

struct masDetallesEq: View {
    
    var id_equipo: String   // <--- RECIBIMOS EL ID

    @State private var fechaInicio = Date()
    @State private var fechaFin = Date()

    @State private var historial: [[String: Any]] = []
    @State private var cargando = true

    var body: some View {

        VStack(spacing: 20) {

            // --- NAV SUPERIOR ---
            HStack {
                Image("NavLog")
                    .resizable()
                    .frame(width: 80, height: 80)

                Spacer()

                Text("Información del Equipo")
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

            // --- CALENDARIOS Y BOTÓN ---
            HStack(spacing: 10) {
                VStack(alignment: .leading) {
                    Text("Fecha inicial:")
                        .fontWeight(.bold)
                    DatePicker("", selection: $fechaInicio, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(CompactDatePickerStyle())
                }

                VStack(alignment: .leading) {
                    Text("Fecha final:")
                        .fontWeight(.bold)
                    DatePicker("", selection: $fechaFin, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(CompactDatePickerStyle())
                }

                Button(action: {
                    print("🔍 BUSCAR (aún no implementado)")
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)

            // --- TABLA RESPONSIVA ---
            VStack(spacing: 0) {

                // Encabezado
                HStack {
                    Text("Responsable").bold().font(.system(size: 10)).frame(maxWidth: .infinity)
                    Text("Matrícula").bold().font(.system(size: 10)).frame(maxWidth: .infinity)
                    Text("Fecha").bold().font(.system(size: 10)).frame(maxWidth: .infinity)
                    Text("Hora").bold().font(.system(size: 10)).frame(maxWidth: .infinity)
                    Text("Tipo actividad").bold().font(.system(size: 10)).frame(maxWidth: .infinity)
                }
                .font(.footnote)
                .padding()
                .background(Color.gray.opacity(0.2))


                // --- CUERPO DINÁMICO ---
                ScrollView {
                    VStack(spacing: 0) {

                        if cargando {
                            ProgressView("Cargando historial…")
                                .padding()
                        }

                        else if historial.isEmpty {
                            Text("No hay historial para este equipo.")
                                .font(.caption)
                                .padding()
                        }

                        else {
                            ForEach(0..<historial.count, id: \.self) { i in
                                let item = historial[i]

                                HStack {

                                    Text("\(item["responsable"] ?? "")")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                        .frame(maxWidth: .infinity)

                                    Text("\(item["matricula"] ?? "")")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                        .frame(maxWidth: .infinity)

                                    Text("\(item["fecha"] ?? "")")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                        .frame(maxWidth: .infinity)

                                    let hora = "\(item["hora"] ?? "")"
                                    let horaLimpia = String(hora.prefix(8))
                                    Text(horaLimpia)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                        .frame(maxWidth: .infinity)

                                    Text("\(item["tipo_actividad"] ?? "")")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                        .frame(maxWidth: .infinity)
                                }
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)

                                Divider()
                            }
                        }
                    }
                }
                .frame(maxHeight: 250)
            }

            Spacer()

            // --- NAV INFERIOR ---
            HStack {
                Spacer()

                NavigationLink(destination: Dashboard()) {
                    Image(systemName: "square.grid.2x2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .frame(height: 60)
            .background(Color.black)
        }
        .onAppear {
            print("🟦 masDetallesEq recibió id_equipo:", id_equipo)

            AjustesController().obtenerHistorialEquipo(id_equipo: id_equipo) { resultado in

                switch resultado {

                case .success(let lista):
                    DispatchQueue.main.async {
                        self.historial = lista
                        self.cargando = false
                        print("📜 HISTORIAL CARGADO:", lista.count)
                    }

                case .failure(let err):
                    print("❌ ERROR HISTORIAL:", err)
                }
            }
        }
    }
}

#Preview {
    masDetallesEq(id_equipo: "14")
}
