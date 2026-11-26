pragma ComponentBehavior: Bound
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Item { // Window
    id: root
    property var toplevel
    property var windowAddresses: HyprlandData.addresses
    property var windowByAddress: HyprlandData.windowByAddress
    property var windowData
    property var monitorData
    property var scale
    property bool restrictToWorkspace: true
    property real widthRatio: {
        const widgetWidth = widgetMonitor.transform & 1 ? widgetMonitor.height : widgetMonitor.width;
        const monitorWidth = monitorData.transform & 1 ? monitorData.height : monitorData.width;
        return (widgetWidth * monitorData.scale) / (monitorWidth * widgetMonitor.scale);
    }
    property real heightRatio: {
        const widgetHeight = widgetMonitor.transform & 1 ? widgetMonitor.width : widgetMonitor.height;
        const monitorHeight = monitorData.transform & 1 ? monitorData.width : monitorData.height;
        return (widgetHeight * monitorData.scale) / (monitorHeight * widgetMonitor.scale);
    }
    property real initX: {
        if (singleTiled) return xOffset;
        return (windowData?.at[0] - (monitorData?.x ?? 0) - monitorData?.reserved[0]) * widthRatio * root.scale + xOffset;
    }

    property real initY: {
        if (singleTiled) return yOffset;
        return Math.max((windowData?.at[1] - (monitorData?.y ?? 0) - monitorData?.reserved[1]) * heightRatio * root.scale, 0) + yOffset;
    }
    property real xOffset: 0
    property real yOffset: 0
    property var widgetMonitor
    property int widgetMonitorId: widgetMonitor.id
    property real workspaceWidth: 0
    property real workspaceHeight: 0

    property real tiledCount: {
        if (!windowData || windowData.floating || windowData.fullscreen) return 0;
        const wsId = windowData.workspace?.id;
        if (!wsId) return 0;
        let count = 0;
        for (const addr of root.windowAddresses) {
            const w = root.windowByAddress[addr];
            if (w && w.workspace?.id === wsId && !w.floating && !w.fullscreen) count++;
        }
        return count;
    }
    property bool singleTiled: tiledCount === 1

    property var targetWindowWidth: {
        if (singleTiled && root.workspaceWidth > 0) {
            return root.workspaceWidth;
        }
        return windowData?.size[0] * scale * widthRatio;
    }
    property var targetWindowHeight: {
        if (singleTiled && root.workspaceHeight > 0) {
            return root.workspaceHeight;
        }
        return windowData?.size[1] * scale * heightRatio;
    }
    property bool hovered: false
    property bool pressed: false
    property bool dragging: false

    property bool centerIcons: Config.options.overview.centerIcons
    property real iconGapRatio: 0.06
    property real iconToWindowRatio: centerIcons ? 0.35 : 0.15
    property real xwaylandIndicatorToIconRatio: 0.35
    property real iconToWindowRatioCompact: 0.6
    property string iconPath: SystemAppearance.iconPath(AppSearch.guessIcon(windowData?.class), "image-missing")
    property bool compactMode: Appearance.font.pixelSize.smaller * 4 > targetWindowHeight || Appearance.font.pixelSize.smaller * 4 > targetWindowWidth

    property bool indicateXWayland: windowData?.xwayland ?? false

    x: initX
    y: initY
    width: targetWindowWidth
    height: targetWindowHeight
    opacity: windowData.monitor == widgetMonitorId ? 1 : 0.4

    property real topLeftRadius
    property real topRightRadius
    property real bottomLeftRadius
    property real bottomRightRadius

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: root.width
            height: root.height
            topLeftRadius: root.topLeftRadius
            topRightRadius: root.topRightRadius
            bottomRightRadius: root.bottomRightRadius
            bottomLeftRadius: root.bottomLeftRadius
        }
    }

    Behavior on x {
        enabled: !window.Drag.active && !window.dragging
        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
    }
    Behavior on y {
        enabled: !window.Drag.active && !window.dragging
        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
    }
    Behavior on width {
        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
    }
    Behavior on height {
        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
    }

    Item {
        id: windowPreview
        anchors.fill: parent

        SmoothScreencopyView {
            anchors.fill: parent
            captureSource: GlobalStates.overviewOpen ? root.toplevel : null
            live: true
        }

        // Color overlay for interactions
        Rectangle {
            anchors.fill: parent
            topLeftRadius: root.topLeftRadius
            topRightRadius: root.topRightRadius
            bottomRightRadius: root.bottomRightRadius
            bottomLeftRadius: root.bottomLeftRadius
            color: pressed ? ColorUtils.transparentize(Appearance.colors.colLayer2Active, 0.5) : 
                hovered ? ColorUtils.transparentize(Appearance.colors.colLayer2Hover, 0.7) : 
                ColorUtils.transparentize(Appearance.colors.colLayer2)
            border.color : ColorUtils.transparentize(Appearance.m3colors.m3outline, 0.88)
            border.width : 1
        }

        AdaptiveIcon {
            id: windowIcon
            property real baseSize: Math.min(root.targetWindowWidth, root.targetWindowHeight)
            // A maximised window makes baseSize the whole workspace, which blew
            // the icon up to a third of the screen and buried the preview under
            // it. Cap it so the icon stays a badge whatever the window size.
            readonly property real maxIconSize: 48
            anchors {
                top: root.centerIcons ? undefined : parent.top
                left: root.centerIcons ? undefined : parent.left
                centerIn: root.centerIcons ? parent : undefined
                margins: baseSize * root.iconGapRatio
            }
            // Named differently from AdaptiveIcon's own `iconSize`: declaring a
            // local property with that name and also assigning it is a
            // "property value set multiple times" error.
            property var targetIconSize: Math.min(
                baseSize * (root.compactMode ? root.iconToWindowRatioCompact : root.iconToWindowRatio),
                maxIconSize
            )
            Layout.alignment: Qt.AlignHCenter
            source: root.iconPath
            iconSize: windowIcon.targetIconSize
            monochrome: false
            width: targetIconSize
            height: targetIconSize

            Behavior on width {
                animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
            }
            Behavior on height {
                animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
            }
        }
    }
}