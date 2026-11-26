pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

RippleButton {
    id: root
    required property QsMenuEntry menuEntry
    property bool forceIconColumn: false
    property bool forceSpecialInteractionColumn: false
    readonly property bool hasIcon: menuEntry.icon.length > 0
    readonly property bool hasSpecialInteraction: menuEntry.buttonType !== QsMenuButtonType.None
    readonly property color contentColor: menuEntry.enabled ? Appearance.m3colors.m3onSurface : Appearance.m3colors.m3outline

    signal dismiss()
    signal openSubmenu(handle: QsMenuHandle)

    colBackground: menuEntry.isSeparator ? "transparent" : ColorUtils.transparentize(Appearance.colors.colLayer0)
    enabled: !menuEntry.isSeparator && menuEntry.enabled
    opacity: menuEntry.enabled ? 1 : 0.38

    horizontalPadding: 12
    implicitWidth: Math.max(contentItem.implicitWidth + contentItem.anchors.leftMargin + contentItem.anchors.rightMargin, 180)
    implicitHeight: menuEntry.isSeparator ? 9 : 36
    Layout.fillWidth: true

    // Separator entries come over the same model as the buttons.
    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: 10
            rightMargin: 10
        }
        visible: root.menuEntry.isSeparator
        implicitHeight: 1
        color: ColorUtils.transparentize(Appearance.m3colors.m3outline, 0.7)
    }

    releaseAction: () => { 
        if (menuEntry.hasChildren) {
            root.openSubmenu(root.menuEntry);
            return;
        }
        menuEntry.triggered();
        root.dismiss(); 
    }
    altAction: (event) => { // Not hog right-click
        event.accepted = false;
    }

    contentItem: RowLayout {
        id: contentItem
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 14
        }
        spacing: 8
        visible: !root.menuEntry.isSeparator

        // Interaction: checkbox or radio button
        Item {
            visible: (root.hasSpecialInteraction || root.forceSpecialInteractionColumn) && !root.menuEntry.isSeparator
            implicitWidth: 20
            implicitHeight: 20

            Loader {
                anchors.fill: parent
                active: root.menuEntry.buttonType === QsMenuButtonType.RadioButton

                sourceComponent: StyledRadioButton {
                    enabled: false
                    padding: 0
                    checked: root.menuEntry.checkState === Qt.Checked
                }
            }

            Loader {
                anchors.fill: parent
                active: root.menuEntry.buttonType === QsMenuButtonType.CheckBox && root.menuEntry.checkState !== Qt.Unchecked

                sourceComponent: MaterialSymbol {
                    text: root.menuEntry.checkState === Qt.PartiallyChecked ? "check_indeterminate_small" : "check"
                    iconSize: Appearance.font.pixelSize.normal
                    color: root.contentColor
                }
            }
        }

        // Button icon
        Item {
            visible: (root.hasIcon || root.forceIconColumn) && !root.menuEntry.isSeparator
            implicitWidth: Appearance.font.pixelSize.normal
            implicitHeight: Appearance.font.pixelSize.normal

            Loader {
                anchors.centerIn: parent
                active: root.menuEntry.icon.length > 0
                sourceComponent: IconImage {
                    asynchronous: true
                    source: root.menuEntry.icon
                    implicitSize: Appearance.font.pixelSize.normal
                    mipmap: true
                }
            }
        }

        StyledText {
            id: label
            text: root.menuEntry.text
            font.pixelSize: Appearance.font.pixelSize.small
            color: root.contentColor
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        Loader {
            active: root.menuEntry.hasChildren

            sourceComponent: MaterialSymbol {
                text: "chevron_right"
                iconSize: Appearance.font.pixelSize.normal
                color: root.contentColor
            }
        }
    }
}
