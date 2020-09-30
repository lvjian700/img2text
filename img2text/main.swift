import Foundation
import Vision
import ArgumentParser
import AppKit


struct Img2text: ParsableCommand {

    @Argument(help: "The phrase to repeat.")
    var pngFile: String

    mutating func run() throws {
      let fileManager = FileManager.default
      guard
        let pngData = fileManager.contents(atPath: pngFile),
        let image = NSImage(data: pngData)
      else {
        print("File not found \(pngFile)")
        return
      }
      
      let size = image.size
      var rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

      guard let cgImage = image.cgImage(
        forProposedRect: &rect,
        context: nil,
        hints: nil
      ) else {
        print("Can not load image: \(pngFile)")
        return
      }
      
      let requestHandler = VNImageRequestHandler(cgImage: cgImage)
      
      let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

      request.recognitionLevel = .accurate

      do {
          // Perform the text-recognition request.
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
