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
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrameNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidChangeFrameNotification), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }

    func unregisterFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(aNotification: Notification) {
        let responder = getCurrentFirstResponder()
        let contextView = responder?.currentLayoutContextView()
        sendEvent("layoutEvent", prepareEvent(kind: "keyboardWillShow", aNotification: aNotification, context: contextView))
    }
    
    @objc func keyboardDidShow(aNotification: Notification) {
        let responder = getCurrentFirstResponder()
        let contextView = responder?.currentLayoutContextView()
        sendEvent("layoutEvent", prepareEvent(kind: "keyboardDidShow", aNotification: aNotification, context: contextView))
    }
    
    @objc func keyboardWillHide(aNotification: Notification) {
        let responder = getCurrentFirstResponder()
        let contextView = responder?.currentLayoutContextView()
        sendEvent("layoutEvent", prepareEvent(kind: "keyboardWillHide", aNotification: aNotification, context: contextView))
    }
    
    @objc func keyboardDidHide(aNotification: Notification) {
        let responder = getCurrentFirstResponder()
        let contextView = responder?.currentLayoutContextView()
        sendEvent("layoutEvent", prepareEvent(kind: "keyboardDidHide", aNotification: aNotification, context: contextView))
    }
    
    @objc func keyboardWillChangeFrameNotification(aNotification: Notification) {
        let responder = getCurrentFirstResponder()
        let contextView = responder?.currentLayoutContextView()
        sendEvent("layoutEvent", prepareEvent(kind: "keyboardWillChangeFrameNotification", aNotification: aNotification, context: contextView))
    }
    
    @objc func keyboardDidChangeFrameNotification(aNotification: Notification) {
        let responder = getCurrentFirstResponder()
        let contextView = responder?.currentLayoutContextView()
        sendEvent("layoutEvent", prepareEvent(kind: "keyboardDidChangeFrameNotification", aNotification: aNotification, context: contextView))
    }
}

//
// Event
//

func prepareEvent(kind: String, aNotification: Notification, context: ReactNativeLayoutContextView?) -> [String: Any?] {
    let userInfo = aNotification.userInfo
    let beginFrame = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect ?? CGRect.zero
    let endFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? CGRect.zero
    let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0
    let curve = convertAnimationFrameCurve(curve: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0)
    let isLocalUserInfoKey = userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? Int ?? 0
    let screenRect = UIScreen.main.bounds
    let screenWidth = screenRect.size.width
    let screenHeight = screenRect.size.height
    
    // Save insets
    let window = UIApplication.shared.windows.first!
    let safeInsets = window.safeAreaInsets
    
    // Safe
    var safeBottom = safeInsets.bottom
    var safeTop = safeInsets.top
    var safeLeft = safeInsets.left
    var safeRight = safeInsets.right
    
    // Keyboard bottom
    var keyboardBottom = screenHeight - endFrame.origin.y
    if context != nil {
        let frame = context!.frame
        let frameOrigin = context!.convert(frame.origin, to: nil)
        let frameBottom = frameOrigin.y + frame.size.height
        print("\(kind): \(frameBottom)")
        keyboardBottom = max(frameBottom - endFrame.origin.y, 0)
    }
    
    // Adjust safe bottom
    safeBottom = max(safeBottom, keyboardBottom)
    
    return [
        
        // Vanila event
        "kind": kind,
        "startCoordinates": convertRect(rect: beginFrame),
        "endCoordinates": convertRect(rect: endFrame),
        "duration": duration * 1000.0, // ms
        "easing": curve,
        "isEventFromThisApp": isLocalUserInfoKey == 1 ? true : false,
        
        // Updated
        "context": context?.name,
        "keyboardBottom": keyboardBottom,
        "safe": [
            "top": safeTop,
            "bottom": safeBottom,
            "left": safeLeft,
            "right": safeRight
        ],
    ]
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
    func currentLayoutContextView() -> ReactNativeLayoutContextView? {
        if self is ReactNativeLayoutContextView {
            return (self as! ReactNativeLayoutContextView)
        }
        return self.superview?.currentLayoutContextView()
    }
}
