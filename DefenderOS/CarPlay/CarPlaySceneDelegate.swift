import CarPlay

/// Connect = logging begins before any UI decision. This ordering is a product
/// contract (see docs/decisions/0005): the startup screen is theater, the capture is real.
///
/// Signature confidence (docs/AUDIT.md fix #3, corrected again 2026-07-04):
/// Apple's own documentation (developer.apple.com/documentation/carplay/
/// cptemplateapplicationscenedelegate) lists THREE real, distinct methods, not
/// two: `didConnect:` (2-param, generic apps), `didDisconnectInterfaceController:`
/// (2-param, pairs with the generic connect), and `didDisconnect:from:` (3-param,
/// WITH a window — Apple's own description names this one as being for
/// "navigation app" specifically). We correctly use the 3-param `didConnect:to:`
/// for the window a map needs, which pairs with `didDisconnect:from:` — NOT
/// with `didDisconnectInterfaceController:`.
///
/// This file's history is a useful cautionary tale in itself: the ORIGINAL code
/// paired the right connect method with the WRONG (but real) disconnect method.
/// The first correction (2026-07-04, fix #3) replaced it with a signature that
/// does not appear to exist as any protocol requirement at all — verified
/// against one forum example, generalized incorrectly, not checked against
/// Apple's own docs. A second, independent review caught this. The version
/// below is now checked directly against Apple's documentation page titles,
/// which is stronger evidence than either prior attempt — but still not a
/// compiler. Diff it against real Xcode before trusting it completely.
final class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    var interfaceController: CPInterfaceController?
    var carWindow: CPWindow?

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didConnect interfaceController: CPInterfaceController,
                                  to window: CPWindow) {
        TripLogger.shared.beginTrip()

        self.interfaceController = interfaceController
        self.carWindow = window

        window.rootViewController = MapViewController()
        let mapTemplate = CPMapTemplate()
        interfaceController.setRootTemplate(mapTemplate, animated: true, completion: nil)
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didDisconnect interfaceController: CPInterfaceController,
                                  from window: CPWindow) {
        TripLogger.shared.endTrip()
        self.interfaceController = nil
        self.carWindow = nil
    }
}


