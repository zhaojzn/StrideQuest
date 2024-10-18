import SwiftUI

struct LoginView: View {
    
    static let color0 = Color(red: 112/255, green: 113/255, blue: 119/255)
    static let color1 = Color(red: 15/255, green: 16/255, blue: 27/255)
    
    let gradient = Gradient(colors: [color0, color1])
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Title
                HStack {
                    Button(action: {
                        // Handle back button action
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                Text("Create an account")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                // Social Media Sign Up
                Text("Sign up with")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                
                HStack(spacing: 20) {
                    Button(action: {
                        // Google Sign In action
                    }) {
                        HStack {
                            Image(systemName: "globe") // Replace with Google logo
                            Text("Google")
                                .bold()
                        }
                        .frame(minWidth: 150)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Facebook Sign In action
                    }) {
                        HStack {
                            Image(systemName: "globe") // Replace with Facebook logo
                            Text("Facebook")
                                .bold()
                        }
                        .frame(minWidth: 150)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
                
                // Form Fields
                VStack(alignment: .leading, spacing: 20) {
                    Text("Username")
                        .foregroundColor(.white)
                    TextField("username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    Text("Email")
                        .foregroundColor(.white)
                    TextField("example@mail.com", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    Text("Password")
                        .foregroundColor(.white)
                    SecureField("••••••••", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                // Register Button
                Button(action: {
                    // Handle register action
                }) {
                    Text("Register")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 30)
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
