var VeraFlux = (function (api) {
	// example of unique identifier for this plugin...
	var uuid = '471e3a91-d2aa-4fb7-b8a3-3bbed7186c71';
	var veraflux_svs = 'urn:livehouse-automation:serviceId:VeraFlux1';
	var myModule = {};
	
	var deviceID = api.getCpanelDeviceId();
	
	function onBeforeCpanelClose(args){
        console.log('handler for before cpanel close');
    }
    
	function init(){
        // register to events...
        api.registerEventHandler('on_ui_cpanel_before_close', myModule, 'onBeforeCpanelClose');
    }
	
	///////////////////////////
	function staticTags_set(deviceID, varVal) {
	  api.setDeviceStateVariablePersistent(deviceID, veraflux_svs, "StaticTags", varVal, 0);
	}

	function period_set(deviceID, varVal) {
	  api.setDeviceStateVariablePersistent(deviceID, veraflux_svs, "Period", varVal, 0);
	} 
	
	function db_set(deviceID, varVal) {
	  api.setDeviceStateVariablePersistent(deviceID, veraflux_svs, "InfluxDB", varVal, 0);
	}
	
	function ip_set(deviceID, varVal) {
	  api.setDeviceStateVariablePersistent(deviceID, veraflux_svs, "InfluxIP", varVal, 0);
	}

	function port_set(deviceID, varVal) {
	  api.setDeviceStateVariablePersistent(deviceID, veraflux_svs, "InfluxPort", varVal, 0);
	}
	
	function username_set(deviceID, varVal) {
	  api.setDeviceStateVariablePersistent(deviceID, veraflux_svs, "InfluxUser", varVal, 0);
	} 
	
	function passwd_set(deviceID, varVal) {
	  api.setDeviceStateVariablePersistent(deviceID, veraflux_svs, "InfluxPassword", varVal, 0);
	}

	function capacitor_set(deviceID, varVal) {
	  api.setDeviceStateVariablePersistent(deviceID, veraflux_svs, "FluxCapacitor", varVal, 0);
	}
	
	
	function ReloadEngine(){
		api.luReload();
	}
	
	function VeraFluxSettings(deviceID) {
		try {
			init();
			
			var period  = api.getDeviceState(deviceID,  veraflux_svs, 'Period');
			var staticTags  = api.getDeviceState(deviceID,  veraflux_svs, 'StaticTags');
			var db  = api.getDeviceState(deviceID,  veraflux_svs, 'InfluxDB');
			var ip  = api.getDeviceState(deviceID,  veraflux_svs, 'InfluxIP');
			var port  = api.getDeviceState(deviceID,  veraflux_svs, 'InfluxPort');
			var username  = api.getDeviceState(deviceID,  veraflux_svs, 'InfluxUser');
			var passwd  = api.getDeviceState(deviceID,  veraflux_svs, 'InfluxPassword');
			var capacitor = api.getDeviceState(deviceID,  veraflux_svs, 'FluxCapacitor');

			var html =  '<table>' +
			' <tr><td>Static Tags </td><td><input  type="text" id="static_tags" size=100 value="' +  staticTags + '" onchange="VeraFlux.staticTags_set(' + deviceID + ', this.value);"></td></tr>' +
				' <tr><td>Period </td><td><input  type="text" id="update_period" size=16 value="' +  period + '" onchange="VeraFlux.period_set(' + deviceID + ', this.value);"> seconds</td></tr>' +
				' <tr><td>Influx DB </td><td><input type="text" id="influx_db" size=16 value="' +  db + '" onchange="VeraFlux.db_set(' + deviceID + ', this.value);"></td></tr>' +
				' <tr><td>Influx IP </td><td><input type="text" id="influx_ip" size=20 value="' +  ip + '" onchange="VeraFlux.ip_set(' + deviceID + ', this.value);"></td></tr>' +
				' <tr><td>Influx Port </td><td><input type="text" id="influx_port" size=10 value="' +  port + '" onchange="VeraFlux.port_set(' + deviceID + ', this.value);"></td></tr>' +
				' <tr><td>Influx Username </td><td><input type="text" id="influx_user" size=16 value="' +  username + '" onchange="VeraFlux.username_set(' + deviceID + ', this.value);"></td></tr>' +
				' <tr><td>Influx Password </td><td><input type="text" id="influx_passwd" size=16 value="' +  passwd + '" onchange="VeraFlux.passwd_set(' + deviceID + ', this.value);"></td></tr>' +
				'</table>';
			html += '<input type="button" value="Save and Reload" onClick="VeraFlux.ReloadEngine()"/>';
			api.setCpanelContent(html);
		} catch (e) {
            Utils.logError('Error in VeraFlux.VeraFluxSettings(): ' + e);
        }
	}
	///////////////////////////
	myModule = {
		uuid: uuid,
		init: init,
		onBeforeCpanelClose: onBeforeCpanelClose,
		VeraFluxSettings: VeraFluxSettings,
		staticTags_set: staticTags_set,
		period_set: period_set,
		db_set: db_set,
		ReloadEngine: ReloadEngine,
		ip_set: ip_set,
		port_set: port_set,
		username_set: username_set,
		passwd_set: passwd_set,
		capacitor_set: capacitor_set
	};

	return myModule;

})(api);


//*****************************************************************************
// Extension of the Array object:
//  indexOf : return the index of a given element or -1 if it doesn't exist
//*****************************************************************************
if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function (element /*, from*/) {
        var len = this.length;

        var from = Number(arguments[1]) || 0;
        if (from < 0) {
            from += len;
        }

        for (; from < len; from++) {
            if (from in this && this[from] === element) {
                return from;
            }
        }
        return -1;
    };
}