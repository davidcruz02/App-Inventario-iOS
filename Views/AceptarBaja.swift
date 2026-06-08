import SwiftUI

struct AceptarBaja: View {

    let equipo: EquipoParaEliminar
    @Binding var refrescarLista: Bool   // 🔥 trigger para refrescar

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sesion: UsuarioSesion
    @StateObject var controller = BajaEquiposController()

    var body: some View {
        VStack(spacing: 0) {

            // --- NAV ROJO (FIJO, NO SE TOCA JAMÁS) ---
            HStack {
                Image("NavLog")
                    .resizable()
                    .frame(width: 80, height: 80)

                Spacer()

                Text("Eliminar equipo")
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)

                Spacer()

                Image("NavLog")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            .padding(.horizontal, 20)
            .frame(height: 60)
            .background(Color.red)

            // --- CONTENIDO (NAV NO SE MUEVE) ---
            ZStack {
                VStack(spacing: 10) {

                    Image(systemName: "laptopcomputer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(equipo.id_status == "1" ? .gray : .green)

                    Text("¿Estás seguro que quieres eliminar el equipo?")
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    HStack(spacing: 8) {
                        Text("No. de equipo:")
                            .fontWeight(.bold)
                        Text(equipo.no_equipo)
                            .fontWeight(.bold)
                    }
                    .font(.title3)

                    // BOTONES
                    HStack(spacing: 20) {

                        // 🔥 CONFIRMAR BAJA
                        Button(action: {
                            if let correo = sesion.usuario?.correo {
                                controller.eliminarEquipo(
                                    id_equipo: equipo.id_equipo,
                                    correo: correo
                                ) { _ in
                                    DispatchQueue.main.async {
                                        refrescarLista = true  // 🔥 avisar a BajaEquipos
                                        dismiss()
                                    }
                                }
                            }
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                        }

                        // ❌ CANCELAR
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 40)

                }
                .offset(y: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    AceptarBaja(
        equipo: EquipoParaEliminar(
            id_equipo: "14",
            no_equipo: "14",
            id_status: "5",
            id_admin: "1",
            nombre_admin: "Julio"
        ),
        refrescarLista: .constant(false)
    )
    .environmentObject(UsuarioSesion())
}
