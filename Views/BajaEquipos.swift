import SwiftUI

struct BajaEquipos: View {

    @EnvironmentObject var sesion: UsuarioSesion
    @StateObject var controller = BajaEquiposController()

    @State private var searchText: String = ""

    // 🔥 Trigger para refrescar desde AceptarBaja
    @State private var refrescarLista = false

    var body: some View {

        NavigationStack {

            VStack(spacing: 20) {

                Text("Baja de Equipos")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                HStack {
                    TextField("Buscar...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

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
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 35) {

                        ForEach(controller.equipos, id: \.id_equipo) { eq in

                            NavigationLink(
                                destination: AceptarBaja(
                                    equipo: eq,
                                    refrescarLista: $refrescarLista  // 🔥 mandar el trigger
                                )
                            ) {
                                VStack(spacing: 8) {
                                    Image(systemName: "laptopcomputer")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 65, height: 65)
                                        .foregroundColor(eq.id_status == "1" ? .gray : .green)

                                    Text(eq.no_equipo)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                }
                            }

                        }
                    }
                }
                .padding(.top, 15)

                Spacer()
            }
            .padding()
            .onAppear {
                if let u = sesion.usuario {
                    controller.extraerEqParaEliminacion(
                        nombre: u.nombre,
                        correo: u.correo
                    ) { _ in }
                }
            }

            // 🔥 Si AceptarBaja pide refrescar, volvemos a cargar
            .onChange(of: refrescarLista) { nuevoValor in
                if nuevoValor == true {
                    if let u = sesion.usuario {
                        controller.extraerEqParaEliminacion(
                            nombre: u.nombre,
                            correo: u.correo
                        ) { _ in }
                    }
                    refrescarLista = false
                }
            }

        }
    }
}

#Preview {
    BajaEquipos()
        .environmentObject(UsuarioSesion())
}
