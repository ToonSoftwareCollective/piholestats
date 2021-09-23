import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
	id: root

	property url trayUrl : "PiholestatsTray.qml";
	property url thumbnailIcon: "qrc:/tsc/pihole_logo_40x40.png"
	property url menuScreenUrl : "PiholestatsSettings.qml"
	property url piholeScreenUrl : "PiholestatsScreen.qml"
	property url piholeTileUrl : "PiholestatsTile.qml"
	property PiholestatsSettings piholeSettings
	property PiholestatsScreen piholeScreen
	property PiholestatsTile piholeTile
	property bool dialogShown : false  //shown when changes have been. Shown only once.

	property SystrayIcon piholeTray
	property bool showAppIcon : true
	property bool firstTimeShown : true
	property variant piholeConfigJSON
	property variant emptyPiholeConfigJSON : {
		"domains_being_blocked":0,
		"dns_queries_today":0,
		"ads_blocked_today":0,
		"ads_percentage_today":0,
		"unique_domains":0,
		"queries_forwarded":0,
		"queries_cached":0,
		"clients_ever_seen":0,
		"unique_clients":0,
		"dns_queries_all_types":0,
		"reply_NODATA":0,
		"reply_NXDOMAIN":0,
		"reply_CNAME":0,
		"reply_IP":0,
		"privacy_level":0,
		"status":"geen connectie",
		"gravity_last_updated":{"file_exists":true,"absolute":0,"relative":{"days":0,"hours":0,"minutes":0}}
	}
	property bool piholeDataRead: false

// app settings
	property string connectionPath
	property bool useSsl: false
	property string uriScheme: "http"
	property string ipadres
	property string poortnummer: "80"
	property int refreshrate: 60	// interval to retrieve data
	property string authtoken

//data vars
	property string tmp_ads_blocked_today
	property string tmp_ads_percentage_today
	property string lastupdated
	property string status

	property string tileColor
	property string textBgColor
	property string textColor

// user settings from config file
	property variant userSettingsJSON : {
		'connectionPath': [],
		'ShowTrayIcon': "",
		'refreshrate': "",
		'authtoken': ""
	}

// location of settings file
	FileIO {
		id: userSettingsFile
		source: "file:///mnt/data/tsc/piholestats.userSettings.json"
 	}

	function init() {
		registry.registerWidget("systrayIcon", trayUrl, this, "piholeTray");
		registry.registerWidget("screen", piholeScreenUrl, this, "piholeScreen");
		registry.registerWidget("screen", menuScreenUrl, this, "piholeSettings");
		registry.registerWidget("menuItem", null, this, null, {objectName: "AppMenuItem", label: qsTr("Pi-Hole"), image: thumbnailIcon, screenUrl: menuScreenUrl, weight: 120});
		registry.registerWidget("tile", piholeTileUrl, this, null, {thumbLabel: "PiHole", thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
	}

//this function needs to be started after the app is booted.
	Component.onCompleted: {
		// read user settings
		try {
			userSettingsJSON = JSON.parse(userSettingsFile.read());
			showAppIcon  = (userSettingsJSON['ShowTrayIcon'] == "yes") ? true : false;
			connectionPath = userSettingsJSON['connectionPath'];
			var splitVar = connectionPath.split(":")
			if (splitVar.length < 3) {
				// Old config, without uriScheme
				ipadres = splitVar[0];
				poortnummer = splitVar[1];
			} else {
				uriScheme = splitVar[0];
				useSsl = (uriScheme == "https") ? true : false;
				ipadres = splitVar[1].slice(2);
				poortnummer = splitVar[2];
			}
			if (poortnummer.length < 2) {
				poortnummer = (useSsl) ? "443" : "80";
			}
			refreshrate = userSettingsJSON['refreshrate'];
			authtoken = userSettingsJSON['authtoken'];
		} catch(e) {
		}
		refreshScreen();
		datetimeTimer.start()
	}

// refresh screen
	function refreshScreen() {
		readPiHolePHPData();
	}

// save user settings
	function saveSettings(){
		uriScheme = (useSsl) ? "https" : "http";
		if (poortnummer == '80' && useSsl) {
			poortnummer = '443'
		}
		if (poortnummer == '443' && !useSsl) {
			poortnummer = '80'
		}
		connectionPath = uriScheme + "://" + ipadres + ":" + poortnummer;

 		var tmpUserSettingsJSON = {
			"connectionPath" : connectionPath,
			"refreshrate" : refreshrate,
			"authtoken" : authtoken,
			"ShowTrayIcon" : (showAppIcon) ? "yes" : "no",
		}

  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/piholestats.userSettings.json");
   		doc3.send(JSON.stringify(tmpUserSettingsJSON));
	}

// read json file
    function readPiHolePHPData()  {

		if ( connectionPath.length > 4 ) {
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.open("GET", connectionPath+"/admin/api.php", true);
			xmlhttp.onreadystatechange = function() {

				if (xmlhttp.readyState == XMLHttpRequest.DONE) {

					if (xmlhttp.status === 200) {
						piholeConfigJSON = JSON.parse(xmlhttp.responseText);
						tmp_ads_blocked_today = piholeConfigJSON['ads_blocked_today'];
						tmp_ads_percentage_today = Math.round(piholeConfigJSON['ads_percentage_today']) + "%";
						status = piholeConfigJSON['status'];
						var tmp = new Date();
						lastupdated = tmp.getFullYear() + "-" + ("0" + (tmp.getMonth() + 1)).slice(-2) + "-" + ("0" + tmp.getDate()).slice(-2) + " " + ("0" + tmp.getHours() ).slice(-2) + ":" + ("0" + tmp.getMinutes()).slice(-2);
					}
					if (xmlhttp.status === 0) {
						piholeConfigJSON = emptyPiholeConfigJSON;
					}
					if (piholeConfigJSON['status'] == "geen connectie") {
						tileColor = "#FF0000";
						textBgColor = "#FF0000";
						textColor = "#FFFFFF";
					} else {
						if (piholeConfigJSON['status'] == "disabled") {
							tileColor = "#FFA500";
							textBgColor = "#FFA500";
							textColor = "#000000";
						} else {
							tileColor = "#FFFFFF";
							textBgColor = dimmableColors.tileBackground;
							textColor = dimmableColors.clockTileColor;
						}
					}
				}
			}
 		       	xmlhttp.send();
		} else {
			tmp_ads_blocked_today = "empty settings";
			tmp_ads_percentage_today = "empty settings";
		}
    }

// Timer in s * 1000
	Timer {
		id: datetimeTimer
		interval: refreshrate * 1000;
		running: false
		repeat: true
		onTriggered: refreshScreen()
	}
}
