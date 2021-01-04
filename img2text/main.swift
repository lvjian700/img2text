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
      
      let requestHandler = VNImageRequestHandler(cgImage: cgImage)
      
      let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

      request.recognitionLevel = .accurate

      do {
          try requestHandler.perform([request])
      } catch {
          print("Unable to perform the requests: \(error).")
      }
  }
  
  func recognizeTextHandler(request: VNRequest, error: Error?) {
      guard let observations =
              request.results as? [VNRecognizedTextObservation] else {
          return
      }
      let recognizedStrings = observations.compactMap { observation in
          // Return the string of the top VNRecognizedText instance.
          return observation.topCandidates(1).first?.string
      }
      
      // Process the recognized strings.
    let text = recognizedStrings.joined(separator: " ")
    print(text)
  }
}

Img2text.main()
