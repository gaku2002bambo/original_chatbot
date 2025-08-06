//
//  ChatViewModel.swift
//  SecretBot
//
//  Created by 生駒岳太郎 on 2025/08/06.
//

import Foundation
import MLCSwift

/// View‑model that loads the fine‑tuned Phi‑3 model and provides a simple
/// chat interface for the UI.
@MainActor
final class ChatViewModel: ObservableObject {

    // MARK: - Published State
    @Published var history: [String] = []            // alternating 👤 / 🤖 lines

    // MARK: - Private
    private let engine: MLCEngine
    private var messages: [ChatCompletionMessage] = []

    /// Loads the MLC model from the app bundle and opens a chat session.
    init() {
        guard let modelPath = Bundle.main.path(
            forResource: "phi3_myself-MLC",
            ofType: nil
        ) else {
            fatalError("❌ Model folder 'phi3_myself-MLC' not found in app bundle.")
        }

        self.engine = MLCEngine()
        
        Task {
            // Load the model with appropriate model library
            // You may need to adjust the modelLib parameter based on your setup
            await engine.reload(modelPath: modelPath, modelLib: "phi3-mini")
        }
    }

    /// Sends user text to the model and appends the assistant's reply.
    func send(_ text: String) async {
        let userText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userText.isEmpty else { return }

        history.append("👤 \(userText)")
        
        // Add user message to the conversation
        messages.append(ChatCompletionMessage(role: .user, content: userText))

        var assistantResponse = ""
        
        // Create streaming response
        let stream = await engine.chat.completions.create(
            messages: messages,
            max_tokens: 128,
            temperature: 0.7,
            top_p: 0.9
        )
        
        // Collect the streamed response
        for await response in stream {
            if let choice = response.choices.first,
               let content = choice.delta.content {
                // Extract text from ChatCompletionMessageContent enum
                assistantResponse += content.asText()
            }
        }
        
        // Clean up the response and add to history
        let cleanedResponse = assistantResponse.replacingOccurrences(of: "<|end|>", with: "")
        history.append("🤖 \(cleanedResponse)")
        
        // Add assistant message to conversation history
        messages.append(ChatCompletionMessage(role: .assistant, content: cleanedResponse))
    }
}
