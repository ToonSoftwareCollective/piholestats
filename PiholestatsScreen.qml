import QtQuick 2.1
import SimpleXmlListModel 1.0
import qb.components 1.0
import qb.base 1.0

Screen {
	id: root

// title
	screenTitleIconUrl: "qrc:/tsc/pihole_logo_40x40.png"
	screenTitle: "Pi-Hole Stats"

// Open settings screen when empty settingsfile detected
	onShown: {
		addCustomTopRightButton("Instellingen");
		if (app.connectionPath.length < 5) {
			 app.piholeSettings.show();
		}
	}
// Open settings screen
	onCustomButtonClicked: {
		if (app.piholeSettings) {
			 app.piholeSettings.show();
		}
	}

//send state change
    function changeState(request) {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.open("GET", request, true);
 	if (xmlhttp.readyState == XMLHttpRequest.DONE) app.refreshScreen();
        xmlhttp.send();
    }

// header
	Item {
		id: header
		height: isNxt ? 55 : 45
		width: parent.width

		Text {
			id: headerText
			text: "Pi-Hole live gegevens (per " + app.lastupdated + ")"
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: parent.left
				leftMargin: isNxt ? 25 : 20
				bottom: parent.bottom
			}
		}

		IconButton {
			id: refreshButton
			anchors.right: parent.right
			anchors.rightMargin: isNxt ? 20 : 16
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 5
			leftClickMargin: 3
			bottomClickMargin: 5
			iconSource: "qrc:/tsc/refresh.svg"
			onClicked: app.refreshScreen()
		}
	}



// block left
		Rectangle {
			id: content
            visible: true
            anchors {
                top: header.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                topMargin: isNxt ? 5 : 5
                leftMargin: isNxt ? 20 : 16
                rightMargin: isNxt ? 338 : 270
				bottomMargin: isNxt ? 20 : 16
            }

// line 1 text
			Text {
				id: line1text
				text: "Status: "
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					left: parent.left
					leftMargin: isNxt ? 62 : 50
					topMargin: isNxt ? 13 : 10
				}
			}
// line 1 value
			Text {
				id: line1value
				text: app.piholeConfigJSON['status']
				color: colors.clockTileColor
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					top: line1text.top
					right: parent.right
					rightMargin:  isNxt ? 100 : 80
				}
			}

// line 2 text
			Text {
				id: line2text
				text: "Domeinen op blocklist: "
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					left: parent.left
					leftMargin: isNxt ? 62 : 50
					top: line1text.bottom
					topMargin: isNxt ? 13 : 10
				}
			}
// line 2 value
			Text {
				id: line2value
				text: app.piholeConfigJSON['domains_being_blocked'];
				color: colors.clockTileColor
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					top: line2text.top
					left: line1value.left
				}
			}

// line 3 text
			Text {
				id: line3text
				text: "DNS queries vandaag: "
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					left: parent.left
					leftMargin: isNxt ? 62 : 50
					top: line2text.bottom
					topMargin: isNxt ? 13 : 10
				}
			}
// line 3 value
			Text {
				id: line3value
				text: app.piholeConfigJSON['dns_queries_today'];
				color: colors.clockTileColor
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					top: line3text.top
					left: line2value.left
				}
			}

// line 4 text
			Text {
				id: line4text
				text: "Reclame geblokkeerd laatste 24h: "
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					left: parent.left
					leftMargin: isNxt ? 62 : 50
					top: line3text.bottom
					topMargin: isNxt ? 13 : 10
				}
			}
// line 4 value
			Text {
				id: line4value
				text: app.piholeConfigJSON['ads_blocked_today'];
				color: colors.clockTileColor
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					top: line4text.top
					left: line3value.left
				}
			}

// line 5 text
			Text {
				id: line5text
				text: "Percentage geblokkeerd: "
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					left: parent.left
					leftMargin: isNxt ? 62 : 50
					top: line4text.bottom
					topMargin: isNxt ? 13 : 10
				}
			}
// line 5 value
			Text {
				id: line5value
				text: app.piholeConfigJSON['ads_percentage_today'] + " %";
				color: colors.clockTileColor
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					top: line5text.top
					left: line4value.left
				}
			}

// line 6 text
			Text {
				id: line6text
				text: "Queries doorgestuurd: "
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					left: parent.left
					leftMargin: isNxt ? 62 : 50
					top: line5text.bottom
					topMargin: isNxt ? 13 : 10
				}
			}
// line 6 value
			Text {
				id: line6value
				text: app.piholeConfigJSON['queries_forwarded'];
				color: colors.clockTileColor
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					top: line6text.top
					left: line5value.left
				}
			}

// line 7 text
			Text {
				id: line7text
				text: "Queries cached: "
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					left: parent.left
					leftMargin: isNxt ? 62 : 50
					top: line6text.bottom
					topMargin: isNxt ? 13 : 10
				}
			}
// line 7 value
			Text {
				id: line7value
				text: app.piholeConfigJSON['queries_cached'];
				color: colors.clockTileColor
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					top: line7text.top
					left: line6value.left
				}
			}

// line 8 text
			Text {
				id: line8text
				text: "Totaal aantal apparaten ooit gezien: "
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					left: parent.left
					leftMargin: isNxt ? 62 : 50
					top: line7text.bottom
					topMargin: isNxt ? 13 : 10
				}
			}
// line 8 value
			Text {
				id: line8value
				text: app.piholeConfigJSON['clients_ever_seen'];
				color: colors.clockTileColor
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					top: line8text.top
					left: line7value.left
				}
			}

// line 9 text
			Text {
				id: line9text
				text: "Unieke apparaten gezien: "
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					left: parent.left
					leftMargin: isNxt ? 62 : 50
					top: line8text.bottom
					topMargin: isNxt ? 13 : 10
				}
			}
// line 9 value
			Text {
				id: line9value
				text: app.piholeConfigJSON['unique_clients'];
				color: colors.clockTileColor
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					top: line9text.top
					left: line8value.left
				}
			}
// line 10 text
			Text {
				id: line10text
				text: "Blocklist laatst bijgewerkt: "
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					left: parent.left
					leftMargin: isNxt ? 62 : 50
					top: line9text.bottom
					topMargin: isNxt ? 13 : 10
				}
			}
// line 10 value
			Text {
				id: line10value
				text: app.piholeConfigJSON['gravity_last_updated']['relative']['days'] + "d:" + app.piholeConfigJSON['gravity_last_updated']['relative']['hours'] + "h:" + app.piholeConfigJSON['gravity_last_updated']['relative']['minutes'] + "m";
				color: colors.clockTileColor
				font.family: qfont.italic.name
				font.pixelSize: isNxt ? 23 : 18
				anchors {
					top: line10text.top
					left: line9value.left
				}
			}
// end lines
		color: colors.addDeviceBackgroundRectangle
		}

//block right
		Rectangle {
		id: content2
		width: isNxt ? 291 : 233
		visible: true
		anchors {
			top: header.bottom
			bottom: parent.bottom
			right: parent.right
			topMargin: isNxt ? 5 : 5
			leftMargin: isNxt ? 20 : 16
			rightMargin: isNxt ? 20 : 16
			bottomMargin: isNxt ? 20 : 16
		}

// button 30s
		StandardButton {
			id: pause30button
			width: isNxt ? 250 : 200
			text: "Pauzeer 30s"
			leftClickMargin: 3
			bottomClickMargin: 5
			anchors {
				top: content2.top
				right: content2.right
				topMargin: isNxt ? 15 : 12
				leftMargin: isNxt ? 20 : 16
				rightMargin: isNxt ? 20 : 16
				bottomMargin: isNxt ? 20 : 16
			}
			onClicked: {
                		changeState(app.connectionPath+"/admin/api.php?disable=30&auth="+app.authtoken);
          		 }
		}

// button 60s
		StandardButton {
			id: pause60button
			width: isNxt ? 250 : 200
			text: "Pauzeer 60s"
			leftClickMargin: 3
			bottomClickMargin: 5
			anchors {
				top: pause30button.bottom
				right: content2.right
				topMargin: isNxt ? 15 : 12
				leftMargin: isNxt ? 20 : 16
				rightMargin: isNxt ? 20 : 16
				bottomMargin: isNxt ? 20 : 16
			}
			onClicked: {
                changeState(app.connectionPath+"/admin/api.php?disable=60&auth="+app.authtoken);
            }
		}

// button 5 min
		StandardButton {
			id: pause300button
			width: isNxt ? 250 : 200
			text: "Pauzeer 5 min"
			leftClickMargin: 3
			bottomClickMargin: 5
			anchors {
				top: pause60button.bottom
				right: content2.right
				topMargin: isNxt ? 15 : 12
				leftMargin: isNxt ? 20 : 16
				rightMargin: isNxt ? 20 : 16
				bottomMargin: isNxt ? 20 : 16
			}
			onClicked: {
                changeState(app.connectionPath+"/admin/api.php?disable=300&auth="+app.authtoken);
            }
		}

// button 10 min
		StandardButton {
			id: pause600button
			width: isNxt ? 250 : 200
			text: "Pauzeer 10 min"
			leftClickMargin: 3
			bottomClickMargin: 5
			anchors {
				top: pause300button.bottom
				right: content2.right
				topMargin: isNxt ? 15 : 12
				leftMargin: isNxt ? 20 : 16
				rightMargin: isNxt ? 20 : 16
				bottomMargin: isNxt ? 20 : 16
			}
			onClicked: {
                changeState(app.connectionPath+"/admin/api.php?disable=600&auth="+app.authtoken);
            }
		}

// button disable
		StandardButton {
			id: disablebutton
			width: isNxt ? 250 : 200
			text: "Pi-Hole uitschakelen"
			leftClickMargin: 3
			bottomClickMargin: 5
			anchors {
				top: pause600button.bottom
				right: content2.right
				topMargin: isNxt ? 62 : 50
				leftMargin: isNxt ? 20 : 16
				rightMargin: isNxt ? 20 : 16
				bottomMargin: isNxt ? 20 : 16
			}
			onClicked: {
                changeState(app.connectionPath+"/admin/api.php?disable&auth="+app.authtoken);
            }
		}

// button enable
		StandardButton {
			id: enablebutton
			width: isNxt ? 250 : 200
			text: "Pi-Hole aanzetten"
			leftClickMargin: 3
			bottomClickMargin: 5
			anchors {
				top: disablebutton.bottom
				right: content2.right
				topMargin: isNxt ? 15 : 12
				leftMargin: isNxt ? 20 : 16
				rightMargin: isNxt ? 20 : 16
				bottomMargin: isNxt ? 20 : 16
			}
			onClicked: {
                changeState(app.connectionPath+"/admin/api.php?enable&auth="+app.authtoken);
            }
		}
// end lines
		color: colors.addDeviceBackgroundRectangle
		}
// closing tag
}
