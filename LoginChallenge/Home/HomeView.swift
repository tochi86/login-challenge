import SwiftUI

@MainActor
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    let dismiss: () -> Void
    
    var body: some View {
        let state = viewModel.state

        return ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color(UIColor.systemGray4))
                        .frame(width: 120, height: 120)
                    
                    VStack(spacing: 0) {
                        Text(state.nameText)
                            .font(.title3)
                            .redacted(reason: state.shouldShowPlaceholder ? .placeholder : [])
                        Text(state.idText)
                            .font(.body)
                            .foregroundColor(Color(UIColor.systemGray))
                            .redacted(reason: state.shouldShowPlaceholder ? .placeholder : [])
                    }
                    
                    if let attributedIntroduction = state.attributedIntroductionText {
                        Text(attributedIntroduction)
                            .font(.body)
                            .redacted(reason: state.shouldShowPlaceholder ? .placeholder : [])
                    } else {
                        Text(state.introductionText)
                            .font(.body)
                            .redacted(reason: state.shouldShowPlaceholder ? .placeholder : [])
                    }
                    
                    // リロードボタン
                    Button {
                        viewModel.onReloadButtonDidTap()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(!state.isReloadButtonEnabled)
                }
                .padding()
                
                Spacer()
                
                // ログアウトボタン
                Button("Logout") {
                    viewModel.onLogoutButtonDidTap()
                }
                .disabled(!state.isLogoutButtonEnabled)
                .padding(.bottom, 30)
            }
        }
        .alert(
            ErrorAlert.authentication.title,
            isPresented: viewModel.showAuthenticationErrorAlert,
            actions: {
                Button(ErrorAlert.authentication.buttonTitle) {
                    dismiss()
                }
            },
            message: { Text(ErrorAlert.authentication.message) }
        )
        .alert(
            ErrorAlert.network.title,
            isPresented: viewModel.showNetworkErrorAlert,
            actions: { Text(ErrorAlert.network.buttonTitle) },
            message: { Text(ErrorAlert.network.message) }
        )
        .alert(
            ErrorAlert.server.title,
            isPresented: viewModel.showServerErrorAlert,
            actions: { Text(ErrorAlert.server.buttonTitle) },
            message: { Text(ErrorAlert.server.message) }
        )
        .alert(
            ErrorAlert.system.title,
            isPresented: viewModel.showSystemErrorAlert,
            actions: { Text(ErrorAlert.system.buttonTitle) },
            message: { Text(ErrorAlert.system.message) }
        )
        .activityIndicatorCover(isPresented: state.isLoggingOut)
        .onChange(of: state.dismiss) { newValue in
            if newValue {
                dismiss()
            }
        }
        .onAppear {
            viewModel.onViewDidAppear()
        }
    }
}
