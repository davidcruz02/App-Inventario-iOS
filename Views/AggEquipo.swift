import SwiftUI

struct AggEquipo: View {

    @EnvironmentObject var sesion: UsuarioSesion
    @Environment(\.dismiss) var dismiss   // <--- para regresar si lo usas desde NavigationStack

    @State private var noEquipo = ""
    @State private var modelo = ""
    @State private var noSerie = ""

    struct StatusOption: Identifiable {
        var id: String
        var nombre: String

        init(dic: [String: Any]) {
            let rawId = "\(dic["id"] ?? "")"
            self.id = rawId.isEmpty ? UUID().uuidString : rawId
            self.nombre = dic["name"] as? String ?? ""
        }
    }

    @State private var opcionesStatus: [StatusOption] = []
    @State private var estadoSeleccionado = ""

    var body: some View {

        VStack(spacing: 0) {

            // NAV
            HStack {
                Image("NavLog")
                    .resizable()
                    .frame(width: 80, height: 80)

                Spacer()

                Text("Agregar equipo")
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
                VStack(spacing: 20) {

                    Image(systemName: "laptopcomputer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                        .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 15) {

                        VStack(alignment: .leading, spacing: 5) {
                            Text("No. Equipo")
                                .font(.headline)
                            TextField("Escribe el número de equipo", text: $noEquipo)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Modelo")
                                .font(.headline)
                            TextField("Escribe el modelo", text: $modelo)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("No. de serie")
                                .font(.headline)
                            TextField("Escribe el número de serie", text: $noSerie)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Estado")
                                .font(.headline)

                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                    .frame(height: 40)

                                Picker("Estado", selection: $estadoSeleccionado) {
                                    ForEach(opcionesStatus) { item in
                                        Text(item.nombre).tag(item.id)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                    .padding(.horizontal, 30)

                    // -------------------------
                    //  BOTONES
                    // -------------------------
                    HStack(spacing: 40) {

                    
                        // CANCELAR
                        Button(action: {
                            print("🟨 CANCELAR — Regresando al dashboard")
                            dismiss()    // <--- ESTO Y NADA MÁS
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                        }


                        // GUARDAR
                        Button(action: {

                            print("🔥 CLICK EN GUARDAR — MANDANDO DATOS AL WS…")

                            let correo = sesion.usuario?.correo ?? ""

                            print("📡 Enviando →")
                            print("  no_equipo:", noEquipo)
                            print("  modelo:", modelo)
                            print("  no_serie:", noSerie)
                            print("  id_status:", estadoSeleccionado)
                            print("  correo:", correo)

                            AgregarEqController().registrarNuevoEquipo(
                                no_equipo: noEquipo,
                                modelo: modelo,
                                no_serie: noSerie,
                                id_status: estadoSeleccionado,
                                correo: correo
                            ) { resultado in

                                switch resultado {

                                case .success(let json):
                                    print("✅ WS RESPUESTA EXITOSA")
                                    print("Respuesta:", json)

                                    // 🔥 limpiar campos
                                    DispatchQueue.main.async {
                                        self.noEquipo = ""
                                        self.modelo = ""
                                        self.noSerie = ""

                                        if let primero = opcionesStatus.first {
                                            self.estadoSeleccionado = primero.id
                                        }

                                        print("🧼 CAMPOS LIMPIADOS DESPUÉS DEL INSERT")
                                    }


                                case .failure(let err):
                                    print("❌ ERROR AL MANDAR:")
                                    print(err)
                                }
                            }

                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 10)

                    Spacer(minLength: 0)
                }
                .padding()
            }
        }
        .onAppear {
            print("🔥 AggEquipo ON APPEAR — LA VISTA NACIÓ")

            AgregarEqController().muestraOpcionesStatus { resultado in
                print("🔥 LLAMANDO AL WS STATUS…")

                switch resultado {
                case .success(let lista):
                    print("🔥 WS STATUS OK:", lista)
                    DispatchQueue.main.async {
                        self.opcionesStatus = lista.map { StatusOption(dic: $0) }
                        if let primero = opcionesStatus.first {
                            self.estadoSeleccionado = primero.id
                        }
                    }

                case .failure(let error):
                    print("🔥 WS STATUS ERROR:", error)
                }
            }
        }
    }
}

#Preview {
    AggEquipo()
        .environmentObject(UsuarioSesion())
}
