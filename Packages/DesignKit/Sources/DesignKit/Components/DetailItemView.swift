import SwiftUI

public struct DetailItemView<Value>: View where Value: View {
        
    private let label: Text
    private let value: Value
    
    public init(@ViewBuilder label: () -> Text, @ViewBuilder value: () -> Value) {
        self.label = label()
        self.value = value()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: .vSpacing.interItem) {
            label
                .textCase(.uppercase)
                .font(.subheadline)
                .foregroundColor(.secondary)
            value
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }
}

struct DetailItemView_Previews: PreviewProvider {
    static var previews: some View {
        DetailItemView {
            Text("Hometown")
        } value: {
            Text("Chicago, Illinois, USA")
        }
    }
}
