//
//  videoDownloader.swift
//  AniLab
//
//  Created by The WORLD on 18/09/23.
//

import Foundation
import Photos
import AVFoundation

class DownloadViewModel: NSObject, ObservableObject, URLSessionDownloadDelegate {
    
    
    @Published var progress: Float = 0
    
    func downloadVideo(url: URL, UserAgent: String) {
        
        var request = URLRequest(url: url)
        request.setValue(UserAgent, forHTTPHeaderField: "User-Agent")
        
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = request.allHTTPHeaderFields
        
        
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                return
            }
            let downloadTask = session.downloadTask(with: url)
            downloadTask.resume()
        }
        task.resume()
    }
    
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
                return
            }
            
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(downloadTask.originalRequest!.url!.lastPathComponent)
        do {
            try data.write(to: destinationURL)
            saveVideoToAlbum(videoURL: destinationURL, albumName: "anime")
        } catch {
            print("Error saving file:", error)
        }
    
    }
     
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
            DispatchQueue.main.async {
                self.progress = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
            }
    }
    
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
                print("Ошибка при скачивании видео: \(error)")
            } else {
                if let response = task.response as? HTTPURLResponse {
                    let contentLength = response.expectedContentLength
                    print("Размер скачанного файла: \(contentLength) байт")
                    
                    if contentLength == 0 {
                        print("Скачанный файл пустой. Возможно, на сервере ошибка.")
                    }
                }
            }
    }
    
    
    
    
    private func saveVideoToAlbum(videoURL: URL, albumName: String) {
        if albumExists(albumName: albumName) {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            if let album = collection.firstObject {
                saveVideo(videoURL: videoURL, to: album)
            }
        } else {
            var albumPlaceholder: PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { success, error in
                if success {
                    guard let albumPlaceholder = albumPlaceholder else { return }
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                    guard let album = collectionFetchResult.firstObject else { return }
                    self.saveVideo(videoURL: videoURL, to: album)
                } else {
                    print("Error creating album: \(error?.localizedDescription ?? "")")
                }
            })
        }
    }

    private func albumExists(albumName: String) -> Bool {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collection.firstObject != nil
    }

    private func saveVideo(videoURL: URL, to album: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            let enumeration: NSArray = [assetChangeRequest!.placeholderForCreatedAsset!]
            albumChangeRequest?.addAssets(enumeration)
        }, completionHandler: { success, error in
            if success {
                print("Successfully saved video to album")
            } else {
                print("Error saving video to album: \(error?.localizedDescription ?? "")")
            }
        })
    }
    
    
    
    
    
}
