import SwiftUI

struct AuthView: View {
  @ObservedObject var vm: MainViewModel
  @FocusState var isFocused: Bool
  @Environment(\.router) var router
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if !isFocused {
        BgImage
          .transition(.move(edge: .top).combined(with: .opacity))
      }
      
      VStack(spacing: 0) {
        Logo
        Title
        EmailButton
        
        if let error = vm.authVM.errorMessage {
          Text(error)
            .foregroundColor(.red)
            .body(type: .regular)
            .padding(.horizontal, 48)
        }
        
        PressButton
        SkipButton
        Spacer()
      }
      .background(.white)
    }
    .animation(.easeInOut, value: isFocused)
  }
  
  private var BgImage: some View {
    VStack(alignment: .leading) {
      Rectangle()
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottomTrailing) {
          Image(.appBg1)
            .resizable()
            .scaledToFit()
            .frame(width: 400, height: 400, alignment: .leading)
            .offset(x: -5)
        }
    }
    .frame(height: 391)
    .foregroundStyle(.appLight)
  }
  
  private var Logo: some View {
    VStack {
      Image(.logo)
        .resizable()
        .scaledToFit()
        .frame(width: 130)
        .foregroundStyle(.accent)
    }
    .padding(.vertical, 17)
  }
  
  private var Title: some View {
    VStack {
      Text("Your Premier Destination for Lush Greenery: Elevate your space with our exceptional plant selection")
        .body(type: .regular)
        .padding(.horizontal, 48)
        .multilineTextAlignment(.center)
    }
    .padding(.vertical, 15)
  }
  
  private var EmailButton: some View {
    VStack {
      CustomTextField(placeholder: "Email", color: .gray, text: $vm.authVM.email)
        .keyboardType(.emailAddress)
        .focused($isFocused)
        .padding(.horizontal, 48)
    }
    .padding(.vertical, 15)
  }
  
  private var PressButton: some View {
    VStack {
      CustomButton(text: "Login / Register", color: isFocused ? .black : .appLightGray) {
        Task { await vm.authVM.saveFromData() }
        vm.appState.updateUser(email: vm.authVM.email)
      }
      .disabled(!isFocused)
      .padding(.horizontal, 48)
    }
    .padding(.vertical, 15)
  }
  
  private var SkipButton: some View {
    VStack {
      Button(action: {
        vm.appState.updateUser(email: "exapmle@mail.com")
      }) {
        Text("Not now")
          .sub(type: .regular)
          .foregroundStyle(.appDarkGray)
          .underline()
      }
    }
  }
}

#Preview {
  AuthView(vm: MainViewModel())
    .previewRouter()
    .environmentObject(CartViewModel())
  
}
