import SwiftUI
import GoogleSignIn

@main
struct AppUDLApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // ✅ Creamos la sesión global
    @StateObject var sesion = UsuarioSesion()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sesion) // <-- se inyecta aquí
        }
    }
}

