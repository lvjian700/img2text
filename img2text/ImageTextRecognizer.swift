import Foundation
import Vision

struct ImageTextRecognizer {
  let recognitionLevel: VNRequestTextRecognitionLevel = .accurate

  func recognize(from cgImage: CGImage, completeHandler: @escaping (Result<[String], Error>) -> Void) {
    let requestHandler = VNImageRequestHandler(cgImage: cgImage)
    
    let request = VNRecognizeTextRequest() { request, error in
      guard let observations =
              request.results as? [VNRecognizedTextObservation] else {
        completeHandler(.success([]))
        return
      }

      let recognizedStrings = observations
        .compactMap { $0.topCandidates(1).first?.string }
      
      completeHandler(.success(recognizedStrings))
    }

    request.recognitionLevel = recognitionLevel

    do {
      try requestHandler.perform([request])
    } catch {
      completeHandler(.failure(error))
    }
  }
}
