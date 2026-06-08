//
//  PrestamoQR.swift
//  AppUDL
//
//  Created by ADMIN on 27/11/25.
//Prestamo de equipo

import SwiftUI
import CodeScanner

struct PrestamoQR: View {
    @State private var matricula: String = ""
    @State private var isScanning: Bool = true
    @State private var scanResult: String?

    var body: some View {
        VStack(spacing: 50) {
            
            Text("Escanear Matrícula")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 133)
            
            // Recuadro con lector QR (tamaño controlado)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.yellow, lineWidth: 3)
                    .frame(width: 250, height: 250)
                    .overlay(
                        CodeScannerView(
                            codeTypes: [.qr],
                            scanMode: .once,
                            showViewfinder: true,
                            isTorchOn: false,
                            completion: handleScan
                        )
                        .frame(width: 240, height: 240)
                    )
            }

            // Input y botón en el mismo renglón
            HStack(spacing: 10) {
                TextField("Ingresar matrícula...", text: $matricula)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    enviarMatricula()
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .onChange(of: scanResult) {
            if let valor = scanResult {
                matricula = valor
                enviarMatricula()
            }
        }
        .padding()
    }

    // MARK: - Funciones internas
    private func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let scanResult):
            scanResultFound(scanResult.string)
        case .failure(let error):
            print("Error escaneando: \(error.localizedDescription)")
        }
    }

    private func scanResultFound(_ code: String) {
        scanResult = code
        print("QR leído: \(code)")
    }

    private func enviarMatricula() {
        print("Matrícula enviada: \(matricula)")
        // Aquí irá la lógica real: validar en base de datos / enviar al backend
    }
}

#Preview {
    PrestamoQR()
}
