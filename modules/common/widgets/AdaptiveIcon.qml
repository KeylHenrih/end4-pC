import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets
import qs.modules.common
import qs.modules.common.functions

/**
 * One icon container for the whole shell.
 *
 * The app logo stays whatever it is; what this component unifies is the plate
 * it sits on — same shape, same padding, same size relationship everywhere, so
 * a tray glyph, a launcher entry and a dock icon stop looking like they came
 * from three different shells.
 *
 * Everything derives from a single `iconSize`, so a call site only ever picks
 * one number.
 *
 * The colours are theme tokens, not literals: changing the palette in Settings
 * repaints every container without anything here knowing about colour schemes.
 */
Item {
    id: root

    enum Shape {
        Squircle, // rounded square, the shape chosen for the shell
        Circle,
        Square,
        None      // no plate at all, logo only — the escape hatch
    }

    // Read defensively: the settings page is optional, so the component must
    // still work on a shell where the config patch was never applied.
    readonly property var _opts: Config?.options?.appearance?.adaptiveIcons ?? null

    property string source: ""
    property real iconSize: 22
    property bool monochrome: true
    property int shape: root._shapeFromName(root._opts?.shape ?? "squircle")
    // 0.8 matches the notification icons this shell already ships
    // (implicitSize 38 with appIconScale 0.8), so the logo keeps the weight it
    // has elsewhere instead of shrinking inside the new plate.
    property real paddingFactor: root._opts?.padding ?? 0.8
    property real radiusFactor: root._opts?.radius ?? 0.25

    /// Draw the logo edge to edge and clip it to the plate, instead of insetting
    /// it. For logos that carry their own background.
    property bool masked: false

    /// A monochrome logo needs a plate behind it to stay readable; a coloured
    /// one would fight a coloured plate, so it gets the quiet neutral surface.
    property color containerColor: root.monochrome
        ? Appearance.colors.colSecondaryContainer
        : Appearance.colors.colSurfaceContainerLow
    property color logoColor: Appearance.colors.colOnSecondaryContainer

    /// How much of the logo's own colour is thrown away in monochrome mode.
    /// 1.0 is fully greyscale. Grey keeps the logo's internal light and dark
    /// detail, which a flat colour wash does not — app logos are photographs of
    /// a kind, not glyphs, so flattening them to one colour leaves a blank tile.
    property real monochromeSaturation: 0.8

    /// Strength of the theme tint laid over the greyscale logo. Low on purpose:
    /// enough to tie the logo to the palette, not enough to erase it. This is
    /// the same idea as the tray icons upstream, which tint at 10%.
    property real monochromeTint: 0.35

    readonly property bool hasContainer: root.shape !== AdaptiveIcon.Shape.None
    /// Masked logos go to the plate edge; the rest are inset by this much.
    readonly property real padding: root.masked ? 0 : root.iconSize * (1 - root.paddingFactor) / 2
    readonly property real radius: root._radius()

    function _shapeFromName(name) {
        switch (name) {
        case "circle": return AdaptiveIcon.Shape.Circle;
        case "square": return AdaptiveIcon.Shape.Square;
        case "none":   return AdaptiveIcon.Shape.None;
        default:       return AdaptiveIcon.Shape.Squircle;
        }
    }

    function _radius() {
        switch (root.shape) {
        case AdaptiveIcon.Shape.Circle: return root.iconSize / 2;
        case AdaptiveIcon.Shape.Square: return 0;
        default:                        return root.iconSize * root.radiusFactor;
        }
    }

    implicitWidth: root.iconSize
    implicitHeight: root.iconSize

    Rectangle {
        id: plate
        anchors.fill: parent
        visible: root.hasContainer
        color: root.containerColor
        radius: root.radius
        // Only the masked logo can overflow the plate, so the texture pass is
        // skipped entirely the rest of the time.
        layer.enabled: root.masked
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: plate.width
                height: plate.height
                radius: plate.radius
            }
        }

        // One sizing path for both modes: masked logos get zero margins and the
        // plate does the trimming; the rest are inset by `padding`.
        Item {
            id: logoArea
            anchors.fill: parent
            anchors.margins: root.padding

            // The logo itself always draws, in both modes. Monochrome changes how
            // it is coloured, never whether it is there: hiding it and painting a
            // flat shape instead turned every opaque app logo into a blank tile,
            // because ColorOverlay fills by alpha and an app logo's alpha is 1.
            IconImage {
                id: logo
                anchors.fill: parent
                source: root.source
                implicitSize: Math.min(logoArea.width, logoArea.height)
                asynchronous: true
                mipmap: true
            }

            // Monochrome is a two-step wash laid OVER the logo, not a replacement
            // for it. Desaturate keeps the logo's own light and dark detail — app
            // logos are pictures, and flattening one to a single colour leaves a
            // blank tile. It draws opaque, so the colourful copy underneath is
            // covered; the tint on top only nudges it toward the palette.
            Loader {
                active: root.monochrome
                anchors.fill: parent
                sourceComponent: Item {
                    Desaturate {
                        id: desaturated
                        anchors.fill: parent
                        source: logo
                        desaturation: root.monochromeSaturation
                    }
                    ColorOverlay {
                        anchors.fill: desaturated
                        source: desaturated
                        color: ColorUtils.transparentize(root.logoColor, 1 - root.monochromeTint)
                    }
                }
            }
        }
    }
}
