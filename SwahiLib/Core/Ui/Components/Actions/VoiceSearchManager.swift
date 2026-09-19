//
//  VoiceSearchManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 19/09/2026.
//

import Foundation
import Speech
import AVFoundation
import UIKit

@MainActor
final class VoiceSearchManager: ObservableObject {

    enum Problem {
        case permissionDenied
        case unavailable
    }

    @Published private(set) var isListening = false
    @Published var problem: Problem? = nil

    private let recognizer: SFSpeechRecognizer? =
        SFSpeechRecognizer(locale: .current) ?? SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var onText: ((String) -> Void)?
    private var sessionID = 0

    func toggle(onText: @escaping (String) -> Void) {
        if isListening {
            stop()
        } else {
            start(onText: onText)
        }
    }

    func start(onText: @escaping (String) -> Void) {
        guard !isListening else { return }
        self.onText = onText

        Self.requestPermissions { [weak self] granted in
            Task { @MainActor in
                guard let self else { return }
                guard granted else {
                    self.problem = .permissionDenied
                    return
                }
                do {
                    try self.beginSession()
                } catch {
                    self.cleanUp()
                    self.problem = .unavailable
                }
            }
        }
    }

    func stop() {
        guard isListening else { return }
        stopEngine()
        request?.endAudio()
        task?.finish()
        isListening = false
    }

    static func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    private func beginSession() throws {
        guard let recognizer, recognizer.isAvailable else {
            throw NSError(domain: "VoiceSearch", code: 1)
        }

        task?.cancel()
        task = nil
        sessionID += 1
        let id = sessionID

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        self.request = request

        let input = audioEngine.inputNode
        input.removeTap(onBus: 0)
        input.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: input.outputFormat(forBus: 0),
            block: Self.tapBlock(for: request)
        )
        audioEngine.prepare()
        try audioEngine.start()
        isListening = true

        task = recognizer.recognitionTask(
            with: request,
            resultHandler: Self.resultHandler { [weak self] text, finished in
                Task { @MainActor in
                    self?.handle(text: text, finished: finished, session: id)
                }
            }
        )
    }

    private func handle(text: String?, finished: Bool, session: Int) {
        guard session == sessionID else { return }

        if let text, !text.isEmpty {
            onText?(text)
        }
        if finished {
            cleanUp()
        }
    }

    private func stopEngine() {
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        audioEngine.inputNode.removeTap(onBus: 0)
    }

    private func cleanUp() {
        stopEngine()
        request?.endAudio()
        request = nil
        task = nil
        onText = nil
        isListening = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    // MARK: Permissions

    private static func requestPermissions(_ completion: @escaping @Sendable (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else {
                completion(false)
                return
            }
            AVAudioApplication.requestRecordPermission { granted in
                completion(granted)
            }
        }
    }
    
    nonisolated private static func tapBlock(
        for request: SFSpeechAudioBufferRecognitionRequest
    ) -> AVAudioNodeTapBlock {
        { buffer, _ in
            request.append(buffer)
        }
    }

    nonisolated private static func resultHandler(
        _ deliver: @escaping @Sendable (String?, Bool) -> Void
    ) -> (SFSpeechRecognitionResult?, Error?) -> Void {
        { result, error in
            deliver(
                result?.bestTranscription.formattedString,
                (result?.isFinal ?? false) || error != nil
            )
        }
    }
}
