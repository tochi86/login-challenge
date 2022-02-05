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
            "認証エラー",
            isPresented: viewModel.showAuthenticationErrorAlert,
            actions: {
                Button("OK") {
                    dismiss()
                }
            },
            message: { Text("再度ログインして下さい。") }
        )
        .alert(
            "ネットワークエラー",
            isPresented: viewModel.showNetworkErrorAlert,
            actions: { Text("閉じる") },
            message: { Text("通信に失敗しました。ネットワークの状態を確認して下さい。") }
        )
        .alert(
            "サーバーエラー",
            isPresented: viewModel.showServerErrorAlert,
            actions: { Text("閉じる") },
            message: { Text("しばらくしてからもう一度お試し下さい。") }
        )
        .alert(
            "システムエラー",
            isPresented: viewModel.showSystemErrorAlert,
            actions: { Text("閉じる") },
            message: { Text("エラーが発生しました。") }
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
