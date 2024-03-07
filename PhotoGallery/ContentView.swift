import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    @State var image: UIImage?
   
    var body: some View {
    
        VStack {
            PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            image = UIImage(data: data)
                        } else {
                            print("Failed to load the image")
                        }
                    }
                }
            
            if let image {
             Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .task {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                showUI(for: status)
            }
        }
    }
    
    func showUI(for status: PHAuthorizationStatus) {
        
        switch status {
        case .authorized:
            print("Full access")
            break

        case .limited:
            print("Limited access")
            break

        case .restricted:
            print("Restricted access")
            break

        case .denied:
            print("Denied access")
            break

        case .notDetermined:
            print("Not determined")
            break

        @unknown default:
            break
        }
    }
}

#Preview {
    ContentView()
}
