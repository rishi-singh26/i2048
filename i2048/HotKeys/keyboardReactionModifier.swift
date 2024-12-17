//
//  keyboardReactionModifier.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

#if os(macOS)
import Foundation
import SwiftUI

@available(macOS 11.0, *)
public extension View {
    
    /// * Reaction on keyboard's .keyDown will be executed only in case of view located at window where window.isKeyWindow == true
    /// * But reaction will be even if this window displays .sheet
    /// * KeyCode struct located in Essentials
    /// * Active Keyboard Layout does not matter
    /// ```
    ///.keyboardReaction { event in
    ///    switch event.keyCode {
    ///    case KeyCode.escape:
    ///        print("esc pressed!")
    ///        return nil // disable beep sound
    ///    case KeyCode.a:
    ///        print("A pressed!")
    ///        return nil // disable beep sound
    ///    default:
    ///        return event // beep sound will be here
    ///    }
    ///}
    /// ```
    func keyboardReaction(action: @escaping (NSEvent) -> (NSEvent?) ) -> some View {
        self.modifier(KeyboardReactiomModifier(action: action))
    }
}

@available(macOS 11.0, *)
private struct KeyboardReactiomModifier: ViewModifier {
    let action: (NSEvent) -> (NSEvent?)
    
    @State var window: NSWindow? = nil
    
    func body(content: Content) -> some View {
        content
            .wndAccessor { self.window = $0 }
            .onAppear {
                NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                    guard let window = window,
                          window.isKeyWindow
                    else { return event }
                    
                    return action(event)
                }
            }
    }
}
#endif
