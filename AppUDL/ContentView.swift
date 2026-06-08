import SwiftUI
import GoogleSignIn

struct ContentView: View {
    
    let loginController = LoginController()
    @EnvironmentObject var sesion: UsuarioSesion
    @State private var irADashboard = false
    @State private var mostrarToast = false
    @State private var mensajeToast = ""
    @State private var toastColor = Color.black
    
    var body: some View {
        NavigationStack {
            
            if sesion.usuario != nil {
                Dashboard()
                    .environmentObject(sesion)
            } else {
                
                VStack(spacing: 60) {
                    
                    Spacer()
                    
                    
                    Image("LogUDL")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                        .padding(.bottom, 30)
                        .onAppear {
                            print("DEBUG IMAGEN:", UIImage(named: "LogUDL") != nil)
                        }

                    
                    Button(action: iniciarSesionConGoogle) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.title2)
                            Text("Acceder con Google")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: 260, minHeight: 55)
                        .background(Color.black)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationDestination(isPresented: $irADashboard) {
                    Dashboard()
                        .environmentObject(sesion)
                }
                .overlay(
                    VStack {
                        if mostrarToast {
                            Text(mensajeToast)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(toastColor.opacity(0.9))
                                .cornerRadius(12)
                                .padding(.top, 40)
                                .transition(.opacity)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation { mostrarToast = false }
                                    }
                                }
                        }
                    }
                    .animation(.easeInOut, value: mostrarToast),
                    alignment: .top
                )
            }
        }
    }

    
    func iniciarSesionConGoogle() {
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            
            if let _ = error {
                mostrarToastRojo("Error al iniciar sesión")
                return
            }
            
            guard let user = result?.user,
                  let email = user.profile?.email,
                  let nombre = user.profile?.name else {
                mostrarToastRojo("Datos inválidos")
                return
            }
            
            let imagenURL = user.profile?.imageURL(withDimension: 200)?.absoluteString ?? ""

            let usuario = Usuario(
                nombre: nombre,
                correo: email,
                imagenURL: imagenURL,
                idAdmin: nil
            )

            loginController.enviarDatosUsuario(usuario: usuario) { resultado in
                DispatchQueue.main.async {
                    switch resultado {

                    case .success(let json):

                        if let idString = json["IdAdmin"] as? String,
                           let idAdmin = Int(idString) {

                            var usuarioConID = usuario
                            usuarioConID.idAdmin = idAdmin

                            sesion.usuario = usuarioConID
                            loginController.guardarUsuario(usuarioConID)

                            mostrarToastVerde("Bienvenido")

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                irADashboard = true
                            }

                        } else {
                            mostrarToastRojo("Sin IdAdmin")
                        }

                    case .failure(_):
                        mostrarToastRojo("Error con el servidor")
                    }
                }
            }
        }
    }

    
    // MARK: Toasts
    func mostrarToastVerde(_ msg: String) {
        mensajeToast = msg
        toastColor = .green
        mostrarToast = true
    }
    
    func mostrarToastRojo(_ msg: String) {
        mensajeToast = msg
        toastColor = .red
        mostrarToast = true
    }
}


