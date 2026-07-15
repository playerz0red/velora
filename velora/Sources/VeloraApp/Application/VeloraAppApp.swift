import Foundation
import OSLog
import SkipFirebaseCore
import SwiftUI

let logger: Logger = Logger(subsystem: "com.palina.velora", category: "VeloraApp")

public struct VeloraAppRootView : View {
    
    private let appDependencyContainer = AppDependencyContainer()
    
    public init() {
        FirebaseApp.configure()
    }

    public var body: some View {
       RootView(appDependencyContainer: appDependencyContainer)
            .task {
                logger.info("Skip app logs are viewable in the Xcode console for iOS; Android logs can be viewed in Studio or using adb logcat")
            }
    }
}

public final class VeloraAppAppDelegate : Sendable {
    public static let shared = VeloraAppAppDelegate()

    private init() {
    }

    public func onInit() {
        logger.debug("onInit")
    }

    public func onLaunch() {
        logger.debug("onLaunch")
    }

    public func onResume() {
        logger.debug("onResume")
    }

    public func onPause() {
        logger.debug("onPause")
    }

    public func onStop() {
        logger.debug("onStop")
    }

    public func onDestroy() {
        logger.debug("onDestroy")
    }

    public func onLowMemory() {
        logger.debug("onLowMemory")
    }
}
