import SwiftUI

struct Dashboard: View {
    
    @EnvironmentObject var sesion: UsuarioSesion
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                Text("")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 100)
                
                Spacer().frame(height: 20)
                
                let columnas = [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
                
                LazyVGrid(columns: columnas, spacing: 60) {
                    
                    // AGREGAR EQUIPO
                    NavigationLink {
                        AggEquipo()
                            .environmentObject(sesion)
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.blue)
                            Text("Agregar equipo")
                                .font(.headline)
                        }
                    }
                    
                    // PRÉSTAMO → EqDisponibles
                    NavigationLink {
                        EqDisponibles()
                            .environmentObject(sesion)
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "laptopcomputer")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.yellow)
                            Text("Préstamo")
                                .font(.headline)
                        }
                    }
                    
                    // DEVOLUCIÓN → EqPrestados
                    NavigationLink {
                        EqPrestados()
                            .environmentObject(sesion)
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "qrcode")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.green)
                            Text("Devolución")
                                .font(.headline)
                        }
                    }
                    
                    // AJUSTES
                    NavigationLink {
                        AjusteEq()
                            .environmentObject(sesion)
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.gray)
                            Text("Ajustes")
                                .font(.headline)
                        }
                    }
                    
                    // ELIMINAR
                    NavigationLink {
                        BajaEquipos()
                            .environmentObject(sesion)
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.red)
                            Text("Eliminar")
                                .font(.headline)
                        }
                    }
                    
                    // ANÁLISIS
                    NavigationLink {
                        Analisis()
                            .environmentObject(sesion)
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "chart.bar.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.purple)
                            Text("Análisis")
                                .font(.headline)
                        }
                    }
                    
                    // 🆕 EQUIPOS ELIMINADOS → EqEliminados
                    NavigationLink {
                        EqEliminados()
                            .environmentObject(sesion)
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "archivebox.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.orange)
                            Text("Equipos eliminados")
                                .font(.headline)
                        }
                    }
                    
                    // 🆕 CERRAR SESIÓN → ContentView
                    NavigationLink {
                        ContentView()
                            .environmentObject(sesion)
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "door.left.hand.open")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.black)
                            Text("Cerrar sesión")
                                .font(.headline)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    Dashboard()
        .environmentObject(UsuarioSesion())
}
