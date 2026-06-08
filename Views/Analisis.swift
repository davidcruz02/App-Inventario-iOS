import SwiftUI
import DGCharts
import UIKit

struct Analisis: View {
    
    @State private var vistaActiva: Int = 1
    @State private var fechaInicio = Date()
    @State private var fechaFin = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Análisis")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            // BOTONES
            HStack {
                botonCategoria("Estado", id: 1)
                botonCategoria("Alumnos", id: 2)
                botonCategoria("Equipos", id: 3)
                botonCategoria("Tiempo", id: 4)
            }
            .padding(.horizontal)

            // -------------------------------
            //  FILTROS (K2, K3, K4)
            // -------------------------------
            if vistaActiva != 1 {
                HStack(spacing: 12) {
                    
                    // Fecha inicio
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.red)
                        DatePicker(
                            "",
                            selection: $fechaInicio,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    
                    // Fecha fin
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundColor(.red)
                        DatePicker(
                            "",
                            selection: $fechaFin,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    
                    // Botón BUSCAR
                    Button(action: {
                        // acción buscar según K2/K3/K4
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }


    
            
            
            // ÁREA CENTRAL
            ZStack {
                switch vistaActiva {
                case 1: vistaGenerales
                case 2: vistaAlumnos
                case 3: vistaEquipos
                case 4: vistaTiempo
                default: EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 400)
            .padding()
            
            Spacer()
        }
    }
    
    
    // BOTÓN CATEGORÍA
    func botonCategoria(_ titulo: String, id: Int) -> some View {
        let icono: String = {
            switch titulo {
            case "Estado": return "chart.pie.fill"
            case "Alumnos": return "person.2.fill"
            case "Equipos": return "laptopcomputer"
            case "Tiempo": return "clock.fill"
            default: return "circle"
            }
        }()
        
        return Button(action: { vistaActiva = id }) {
            Image(systemName: icono)
                .font(.system(size: 20))
                .foregroundColor(vistaActiva == id ? .white : .red)
                .padding(12)
                .background(vistaActiva == id ? Color.red : Color.clear)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 1.5)
                )
        }
    }
    
    
    // VISTAS
    var vistaGenerales: some View {
        VStack {
            Text("Gráfica General").font(.headline)
            GraficaEquiposView()
        }
    }
    
    var vistaAlumnos: some View {
        VStack {
            Text("Gráfica: Alumnos").font(.headline)
            Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 250)
        }
    }
    
    var vistaEquipos: some View {
        VStack {
            Text("Gráfica: Equipos").font(.headline)
            Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 250)
        }
    }
    
    var vistaTiempo: some View {
        VStack {
            Text("Gráfica: Tiempo de Uso").font(.headline)
            Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 250)
        }
    }
}

#Preview {
    Analisis()
}
