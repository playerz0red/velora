import SwiftUI

enum ContentTab: String, Hashable {
    case welcome, home, settings
}

struct RootView: View {
   
    @State private var viewModel: RootViewModel
    
    private var appDependencyContainer: AppDependencyContainer
    private let factory: RootFactoryProtocol
    private let userFormFactory: UserFormFactoryProtocol
    private let authFactory: AuthFactoryProtocol
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
        self.factory = appDependencyContainer.makeRootFactory()
        self.userFormFactory = appDependencyContainer.makeUserFormFactory()
        self.authFactory = appDependencyContainer.makeAuthFactory()
        self.viewModel = factory.buildRootViewModel()
    }
    
    var body: some View {
        ZStack {
            if viewModel.isSigned {
                UserFormView(viewModel: userFormFactory.buildUserFormViewModel())
            } else {
                AuthFlowView(authFactory: authFactory)
                    .onAppear {
                        viewModel.signOut()
                    }
            }
        }
        .animation(.bouncy, value: viewModel.isSigned)
    }
}
