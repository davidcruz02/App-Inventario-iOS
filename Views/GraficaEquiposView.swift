//
//  GraficaEquiposView.swift
//  AppUDL
//
//  Created by ADMIN on 25/11/25.


import SwiftUI
import DGCharts
import UIKit

struct GraficaEquiposView: View {
    
    @StateObject private var controller = GraficasController()
    
    var body: some View {
        VStack {
            if let g = controller.graficaGeneral {
                GraficaBarrasH(grafica: g)
                    .frame(height: 300)
            } else {
                ProgressView("Cargando gráfica...")
            }
        }
        .onAppear {
            controller.obtenerDatosGenerales { _ in }
        }
    }
}


// ==============================================
//   GRÁFICA BARRAS HORIZONTALES – DGCharts
//   Orden del backend: prestados, disponibles,
//   reparación, baja.
// ==============================================
struct GraficaBarrasH: UIViewRepresentable {
    
    let grafica: GraficaGeneral
    
    func makeUIView(context: Context) -> HorizontalBarChartView {
        let chart = HorizontalBarChartView()
        
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = false
        
        chart.xAxis.enabled = false
        chart.legend.enabled = false
        
        chart.doubleTapToZoomEnabled = false
        chart.pinchZoomEnabled = false
        
        return chart
    }
    
    func updateUIView(_ chart: HorizontalBarChartView, context: Context) {
        
        // ORDEN DEL BACKEND
        let valores = [
            Double(grafica.prestados),
            Double(grafica.disponibles),
            Double(grafica.reparacion),
            Double(grafica.baja)
        ]
        
        let entries = [
            BarChartDataEntry(x: 0, y: valores[0]),
            BarChartDataEntry(x: 1, y: valores[1]),
            BarChartDataEntry(x: 2, y: valores[2]),
            BarChartDataEntry(x: 3, y: valores[3])
        ]
        
        let set = BarChartDataSet(entries: entries)
        
        // COLORES – MISMO ORDEN
        set.colors = [
            UIColor(hex: "#ff9800"), // prestados
            UIColor(hex: "#43a047"), // disponibles
            UIColor(hex: "#808080"), // reparación
            UIColor(hex: "#000000")  // baja
        ]
        
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 14, weight: .bold)
        set.valueTextColor = .white
        
        // LOS LABELS DENTRO DE LA BARRA
        set.valueFormatter = LabelFormatter(labels: [
            "Prestados",
            "Disponibles",
            "Reparación",
            "Baja"
        ])
        
        let data = BarChartData(dataSet: set)
        data.setDrawValues(true)
        
        chart.data = data
    }
}

// ==========================
//   FORMATTER DE LABELS
// ==========================
class LabelFormatter: NSObject, ValueFormatter {
    
    let labels: [String]
    
    init(labels: [String]) {
        self.labels = labels
    }
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let index = Int(entry.x)
        if index >= 0 && index < labels.count {
            return labels[index]
        }
        return ""
    }
}

// ==========================
//   EXTENSIÓN HEX → UIColor
// ==========================
extension UIColor {
    convenience init(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: 1.0
        )
    }
}
