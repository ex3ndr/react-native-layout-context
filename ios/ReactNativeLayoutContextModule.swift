import ExpoModulesCore

public class ReactNativeLayoutContextModule: Module {
  public func definition() -> ModuleDefinition {
      Name("ReactNativeLayoutContext")
      View(ReactNativeLayoutContextView.self) {
          Prop("name") { (view: ReactNativeLayoutContextView, prop: String) in
              view.name = prop
          }
      }
      OnCreate {
          self.registerForNotifications()
      }
      OnDestroy {
          self.unregisterFromNotifications()
      }
    }

    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    func unregisterFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(aNotification: Notification) {
        let view = getKeyboardViewReactNativeAnimated()
        let responder = getCurrentFirstResponder()
        let contextKey = responder?.currentLayoutContextKey() ?? "<none>"
        print("[KEYBOARD]: Will Show: \(contextKey), \(responder)")
    }
    
    @objc func keyboardDidShow(aNotification: Notification) {
        let view = getKeyboardViewReactNativeAnimated()
        let responder = getCurrentFirstResponder()
        let contextKey = responder?.currentLayoutContextKey() ?? "<none>"
        print("[KEYBOARD]: Did Show: \(contextKey), \(responder)")
    }
    
    @objc func keyboardWillHide(aNotification: Notification) {
        let view = getKeyboardViewReactNativeAnimated()
        let responder = getCurrentFirstResponder()
        let contextKey = responder?.currentLayoutContextKey() ?? "<none>"
        print("[KEYBOARD]: Will Hide: \(contextKey), \(responder)")
    }
    
    @objc func keyboardDidHide(aNotification: Notification) {
        let view = getKeyboardViewReactNativeAnimated()
        let responder = getCurrentFirstResponder()
        let contextKey = responder?.currentLayoutContextKey() ?? "<none>"
        print("[KEYBOARD]: Did Hide: \(contextKey), \(responder)")
    }
    
    //
    // Loading Keyboard View
    //
    
    func getKeyboardViewReactNativeAnimated() -> UIView? {
        let windows = UIApplication.shared.windows
        let window = findClass(name: "UITextEffectsWindow", inViewsList: windows)
        if window == nil {
            return nil
        }
        let keyboardContainer = findClass(name: "UIInputSetContainerView", inViewsList: window!.subviews)
        if keyboardContainer == nil {
            return nil
        }
        let keyboardView = findClass(name: "UIInputSetHostView", inViewsList: keyboardContainer!.subviews)
        return keyboardView
    }

//    func getKeyboardViewTelegram() -> UIView {
//        let windowClass = NSClassFromString("UIRemoteKeyboardWindow")
//        let result = (windowClass as! UIRemoteKeyboardWindowProtocol).remoteKeyboardWindow(forScreen: UIScreen.main, create: false)
//        return result!
//    }
}

//
// Keyboard
//

func findClass(name: String, inViewsList: [UIView]) -> UIView? {
    for view in inViewsList {
        if String(describing: type(of: view)) == name {
            return view
        }
    }
    return nil
}

func getKeyboardViewReactNativeAnimated() -> UIView? {
  let windows = UIApplication.shared.windows
  let window = findClass(name: "UITextEffectsWindow", inViewsList: windows)
  if window == nil {
    return nil
  }
  let keyboardContainer = findClass(name: "UIInputSetContainerView", inViewsList: window!.subviews)
  if keyboardContainer == nil {
    return nil
  }
  return findClass(name: "UIInputSetHostView", inViewsList: keyboardContainer!.subviews)
}

//
// First responder
//

func getCurrentFirstResponder() -> UIView? {
  return UIApplication.shared.windows.first?.currentFirstResponder()
}

extension UIView {
    func currentFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        
        return nil
     }
}

//
// Context
//

extension UIView {
    func currentLayoutContextKey() -> String? {
        if self is ReactNativeLayoutContextView {
            return (self as! ReactNativeLayoutContextView).name
        }
        return self.superview?.currentLayoutContextKey()
    }
}
