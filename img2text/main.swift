import Foundation
import Vision
import ArgumentParser
import AppKit


struct Img2text: ParsableCommand {

    @Argument(help: "PNG file path.")
    var pngFile: String

    mutating func run() throws {
      guard
        let image = NSImage(contentsOfFile: pngFile),
        let cgImage = image.toCGImage()
      else {
        print("Can not load image: \(pngFile)")
        return
      }
      
      ImageTextRecognizer().recognize(from: cgImage) { ret in
        switch ret {
          case .success(let recognizedStrings):
            let text = recognizedStrings.joined(separator: " ")
            print(text)
          case .failure(let error):
            print("Unable to recognize text from image, reason: \(error)")
        }
      }
  }
}

Img2text.main()
