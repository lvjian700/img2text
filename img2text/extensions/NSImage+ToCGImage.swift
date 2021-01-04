import Foundation
import AppKit

extension NSImage {
  func toCGImage() -> CGImage? {
    var rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
  
    return cgImage(
      forProposedRect: &rect,
      context: nil,
      hints: nil
    )
  }
}
