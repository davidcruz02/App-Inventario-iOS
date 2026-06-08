import SwiftUI

struct AjusteEq: View {

    @State private var equipoSeleccionado: String? = nil
    @State private var searchText: String = ""
    @State private var equipos: [EquipoItem] = []
    @State private var equiposFiltrados: [EquipoItem] = []   // <--- NUEVO
    @State private var cargando = true

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 24), count: 3)

    var body: some View {

        VStack(spacing: 20) {

            HStack {
                Image("NavLog").resizable().frame(width: 80, height: 80)
                Spacer()
                Text("Ajustes").fontWeight(.bold).foregroundColor(.white)
                Spacer()
                Image("NavLog").resizable().frame(width: 80, height: 80)
            }
            .padding(.horizontal, 20)
            .frame(height: 80)
            .background(Color.black)

            // BUSCADOR
            HStack(spacing: 10) {
                TextField("Buscar...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    let filtro = searchText.lowercased().trimmingCharacters(in: .whitespaces)

                    if filtro.isEmpty {
                        equiposFiltrados = equipos
                        print("🔍 Buscador vacío — restaurando lista completa")
                        return
                    }

                    equiposFiltrados = equipos.filter {
                        $0.no_equipo.lowercased().contains(filtro)
                    }

                    print("🔍 Coincidencias:", equiposFiltrados.count)
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)

            // ÍCONOS
            if cargando {
                ProgressView("Cargando equipos…").padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 18) {

                        ForEach(equiposFiltrados) { item in

                            VStack(spacing: 6) {

                                Button(action: {
                                    equipoSeleccionado = item.id_equipo
                                    print("🔥 ID seleccionado:", item.id_equipo)
                                }) {
                                    Image(systemName: "laptopcomputer")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(colorParaStatus(item.id_status))
                                }

                                NavigationLink(
                                    destination: DetallesEq(id_equipo: equipoSeleccionado ?? ""),
                                    tag: item.id_equipo,
                                    selection: $equipoSeleccionado
                                ) { EmptyView() }
                                .hidden()

                                Text(item.no_equipo)
                                    .font(.headline)
                            }
                        }

                    }
                    .padding(.horizontal, 16)
                }
            }

            Spacer()
        }
        .padding(.bottom)
        .onAppear { cargarEquipos() }
    }

    func cargarEquipos() {
        AjustesController().obtenerEquiposConfiguracion { resultado in
            switch resultado {
            case .success(let listaJSON):
                let listaConvertida = listaJSON.compactMap { EquipoItem(dict: $0) }

                DispatchQueue.main.async {
                    self.equipos = listaConvertida
                    self.equiposFiltrados = listaConvertida
                    self.cargando = false
                }

            case .failure(let err):
                print("❌ Error:", err)
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
        default: return .black
        }
    }
}

#Preview { AjusteEq() }
