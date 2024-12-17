//
//  wndAccessorModifier.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

#if os(macOS)
import SwiftUI
public extension View {
    /// With this modifier you're able to access to window from View.
    ///
    /// Usage:
    /// ```
    /// someView
    ///     .wndAccessor { wnd
    ///         self.window = wnd
    ///     }
    /// ```
    /// another sample:
    /// ```
    /// someView
    ///     .wndAccessor { wnd
    ///         wnd.title = "THIS... IS... WINDOOOOOW!"
    ///     }
    /// ```
    func wndAccessor(_ act: @escaping (NSWindow?) -> () )
        -> some View {
            self.modifier(WndTitleConfigurer(act: act))
    }
}

private struct WndTitleConfigurer: ViewModifier {
    let act: (NSWindow?) -> ()
    
    @State var window: NSWindow? = nil
    
    func body(content: Content) -> some View {
        content
            .getWindow($window)
            .onChange(of: window, { oldValue, newValue in
                act(newValue)
            })
    }
}

//////////////////////////////
///HELPERS
/////////////////////////////

private extension View {
    func getWindow(_ wnd: Binding<NSWindow?>) -> some View {
        self.background(WindowAccessor(window: wnd))
    }
}

private struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?
    
    public func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
        }
        return view
    }
    
    public func updateNSView(_ nsView: NSView, context: Context) {}
}

#endif
