import ExpoModulesCore

public class ReactNativeLayoutContextModule: Module {
  public func definition() -> ModuleDefinition {
      Name("ReactNativeLayoutContext")
      Events("layoutEvent")
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
        // let view = getKeyboardViewReactNativeAnimated()
        let responder = getCurrentFirstResponder()
        let contextKey = responder?.currentLayoutContextKey()
        sendEvent("layoutEvent", parseKeyboardEvent(kind: "keyboardWillShow", aNotification: aNotification, context: contextKey))
    }
    
    @objc func keyboardDidShow(aNotification: Notification) {
        // let view = getKeyboardViewReactNativeAnimated()
        let responder = getCurrentFirstResponder()
        let contextKey = responder?.currentLayoutContextKey()
        sendEvent("layoutEvent", parseKeyboardEvent(kind: "keyboardDidShow", aNotification: aNotification, context: contextKey))
    }
    
    @objc func keyboardWillHide(aNotification: Notification) {
        // let view = getKeyboardViewReactNativeAnimated()
        let responder = getCurrentFirstResponder()
        let contextKey = responder?.currentLayoutContextKey()
        sendEvent("layoutEvent", parseKeyboardEvent(kind: "keyboardWillHide", aNotification: aNotification, context: contextKey))
    }
    
    @objc func keyboardDidHide(aNotification: Notification) {
        // let view = getKeyboardViewReactNativeAnimated()
        let responder = getCurrentFirstResponder()
        let contextKey = responder?.currentLayoutContextKey()
        sendEvent("layoutEvent", parseKeyboardEvent(kind: "keyboardDidHide", aNotification: aNotification, context: contextKey))
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

func convertRect(rect: CGRect) -> NSDictionary {
    return [
        "screenX": rect.origin.x,
        "screenY": rect.origin.y,
        "width": rect.size.width,
        "height": rect.size.height
    ]
}

func convertAnimationFrameCurve(curve: Int) -> String {
    switch(curve) {
    case UIView.AnimationCurve.easeIn.rawValue:
        return "easeIn"
    case UIView.AnimationCurve.easeInOut.rawValue:
        return "easeInEaseOut"
    case UIView.AnimationCurve.easeOut.rawValue:
        return "easeOut"
    case UIView.AnimationCurve.linear.rawValue:
        return "linear"
    default:
        return "keyboard"
    }
}

func parseKeyboardEvent(kind: String, aNotification: Notification, context: String?) -> [String: Any?] {
    let userInfo = aNotification.userInfo
    let beginFrame = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect ?? CGRect.zero
    let endFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? CGRect.zero
    let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0
    let curve = convertAnimationFrameCurve(curve: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0)
    let isLocalUserInfoKey = userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? Int ?? 0
    let screenRect = UIScreen.main.bounds
    let screenWidth = screenRect.size.width
    let screenHeight = screenRect.size.height
    
    return [
        "kind": kind,
        "context": context,
        "startCoordinates": convertRect(rect: beginFrame),
        "endCoordinates": convertRect(rect: endFrame),
        "duration": duration * 1000.0, // ms
        "easing": curve,
        "screen": [
            "width": screenWidth,
            "height": screenHeight
        ],
        "isEventFromThisApp": isLocalUserInfoKey == 1 ? true : false
    ]
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
