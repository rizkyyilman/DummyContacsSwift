import SwiftUI

// Model untuk Profil Pengguna
struct UserProfile {
    var name: String
    var email: String
}

// ViewModel untuk mengelola data dan logika aplikasi
class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile? = nil
    
    func saveProfile(name: String, email: String) {
        guard !name.isEmpty, !email.isEmpty else { return }
        userProfile = UserProfile(name: name, email: email)
    }
}

// View utama aplikasi
struct ContentView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Form Profil Pengguna")) {
                    TextField("Nama Lengkap", text: $name)
                        .autocapitalization(.words)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button("Simpan") {
                        viewModel.saveProfile(name: name, email: email)
                        showAlert = true
                        hideKeyboard()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                    .alert("Data berhasil disimpan", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }
                
                if let profile = viewModel.userProfile {
                    Section(header: Text("Profil Disimpan")) {
                        Text("Nama: \(profile.name)")
                        Text("Email: \(profile.email)")
                    }
                }
            }
            .navigationTitle("Aplikasi Profil")
        }
    }
}

// Extension untuk memudahkan menyembunyikan keyboard
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
#endif

#Preview {
    ContentView()
}
