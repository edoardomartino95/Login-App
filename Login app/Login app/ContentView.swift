//
//  ContentView.swift
//  Login app
//
//  Created by Edoardo Martino on 20/04/24.
//  Parte del codice è stato preso da questo link: https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Creating-a-Login-Page

// io mi sono occupato di implementare il controllo password,
// controllo colore del pulsante una volta premuto in assenza di
// testo per l'email e password sbagliata, navigationlink
// per la nuova view. 

import SwiftUI

struct ContentView: View {
    
    @State private var isLoginMode: Bool = true
    @State private var email: String = ""
    @State private var password: String = ""
    // Aggiungiamo uno stato pr far apparire un allert nel caso la password o l'email siano sbagliati
    @State private var showAlert: Bool = false
    // Aggiungiamo uno stato per verificare se la password è valida
    @State private var isPasswordValid: Bool = false
    @State private var alertColor = Color.cyan
    @State private var isTypingEmail: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Picker(selection: $isLoginMode, label: Text("Picker")) {
                        //imposto il picker entra come true, in quanto lui sarà il primo ad apparire
                        Text("Entra").tag(true)
                        Text("Crea account").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Group {
                        TextField("E-mail", text: $email, onEditingChanged: { editing in
                            //quando il pulsante è rosso per un errore, e poi tocchi il form, diventa di nuovo celeste
                            if !isTypingEmail{
                                alertColor = .cyan
                            }else{
                                alertColor = .red
                            }
                        })
                            .keyboardType(.emailAddress) //tastiera ottimizzatta per email
                            .autocapitalization(.none) //lascia il testo così come inserito
                        SecureField("Password", text: $password) //nascondi la password
                    }
                    .padding(12)
                    
                    // Utilizziamo il NavigationLink direttamente nel corpo del pulsante
                    NavigationLink(destination: Home(), isActive: $isPasswordValid) {
                        Button(action: {
                            if isLoginMode { //ti devi trovare nel picker login
                                if passwordControl(psw: $password) &&
                                    !email.isEmpty {
                                    
                                    isLoading = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){ //timing di accesso alla navlink
                                        isPasswordValid = true
                                    }
                                    alertColor = .green //caricamento colore verde
                                } else {
                                    showAlert = true
                                    alertColor = .red
                                }
                            }
                        }) {
                            if isLoading{ // se carica
                                ProgressView() //allora appare la rotellina di caricamento
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(2.0)
                                    .padding()
                            }else{
                                HStack {
                                    Spacer()
                                    Text(isLoginMode ? "Entra" : "Crea account") //il pulsante cambia nome
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                    Spacer()
                                }
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(alertColor))
                        .padding()
                    }
                    .alert(isPresented: $showAlert) { //sezione di allert
                        Alert(title: Text("Password o E-mail non valida"), message: Text("La password o la E-mail inserita non è corretta. Riprova."), dismissButton: .default(Text("OK")))
                    }
                    .navigationTitle(isLoginMode ? "Entra" : "Crea account") //il titolo cambia nome
                }
            }
        }
    }
}

struct Home: View { // Definizione della nuova view
    
    @State private var isDarkModeAttiva: Bool = false
    
    var body: some View {
            ScrollView{
                HStack(){
                    VStack(){
                        Text("Edoardo")
                            .padding()
                    }
                    Spacer()
                }
            }
            .navigationTitle("Benvenuto")
        
        //DARK MODE :3
            .navigationBarItems(trailing: Button(action: {
                isDarkModeAttiva.toggle()
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkModeAttiva ? .dark : .light
            })
                {
                if isDarkModeAttiva{
                    myblack
                }else{
                    mywhite
                }
                    
            })
    }
}


//luna per light mode
var mywhite: some View{
        Image(systemName: "moon.fill")
            .padding(4)
            .background(Color.black)
            .clipShape(Circle())
            .foregroundColor(.white)
    }
// sole per dark mode
var myblack: some View{
        Image(systemName: "sun.max.fill")
            .padding(4)
            .background(Color.white)
            .clipShape(Circle())
            .foregroundColor(.black)
    }

//controllo e verifica password, solo per simulare un login
func passwordControl(psw: Binding<String>) -> Bool{
    if psw.wrappedValue == "admin"{
        return true
    }else {
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        Home()
    }
}


