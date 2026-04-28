import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()

    // Set initial window size and position
    let windowFrame = NSRect(
      x: 100,
      y: 100,
      width: 1280,
      height: 800
    )

    self.setFrame(windowFrame, display: false)

    // Set minimum size
    self.minSize = NSSize(width: 800, height: 600)

    self.contentViewController = flutterViewController
    self.setContentSize(windowFrame.size)

    self.center()

        // Position traffic light buttons in the center of the title bar
    self.toolbar = NSToolbar(identifier: "main")
    self.titleVisibility = .hidden
    

    RegisterGeneratedPlugins(registry: flutterViewController)

    let channel = FlutterMethodChannel(
      name: "jp.szktty.rinnegraph/window_info",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      if call.method == "getWindowNumber" {
        if let windowNumber = self?.windowNumber {
          result(windowNumber)
        } else {
          result(FlutterError(code: "NO_WINDOW", message: "No main window", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    super.awakeFromNib()
  }
}
