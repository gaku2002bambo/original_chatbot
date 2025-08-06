import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ChatViewModel()
    @State private var input = ""

    var body: some View {
        VStack {
            // 履歴表示
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(vm.history.indices, id: \.self) { idx in
                        Text(vm.history[idx])
                            .frame(maxWidth: .infinity,
                                   alignment: vm.history[idx].hasPrefix("👤") ? .trailing : .leading)
                            .padding(.vertical, 2)
                            .id(idx)
                    }
                }
                .onChange(of: vm.history.count) { _, _ in 
                    proxy.scrollTo(vm.history.indices.last)
                }
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()

            // 入力欄
            HStack {
                TextField("メッセージを入力", text: $input)
                    .textFieldStyle(.roundedBorder)
                Button("送信") {
                    let text = input; input = ""
                    Task { await vm.send(text) }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
}
