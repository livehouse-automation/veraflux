module("L_VeraFlux1", package.seeall)

--
-- VeraFlux Plugin
-- 
-- Created by Mike Nye and Antony Winn
--
-- https://www.livehouseautomation.com.au
-- https://github.com/livehouse-automation
--
--

local VERAFLUX_SID = "urn:livehouse-automation:serviceId:VeraFlux1"
local SWITCH_SID = "urn:upnp-org:serviceId:SwitchPower1"
local SECURITY_SID = "urn:micasaverde-com:serviceId:SecuritySensor1"
local HADEVICE_SID = "urn:micasaverde-com:serviceId:HaDevice1"
local GATEWAY_SID = "urn:micasaverde-com:serviceId:HomeAutomationGateway1"

local INFLUX_IP = "192.168.0.29" -- influxdb IP
local INFLUX_PORT = "8086" -- influxdb port, default 8086
local INFLUX_DB = "vera" -- database within influxdb to store data
local INFLUX_EXTRATAGS = "" -- comma separated list with no whitespace or special chars
local INFLUX_URL = "http://" .. INFLUX_IP .. ":" .. INFLUX_PORT .. "/write?db=" .. INFLUX_DB

local DEFAULT_PERIOD = 60 -- number of seconds between polling variables
-- note: watched variables will be polled every DEFAULT_PERIOD and also on variable change
	
-- Define services and values we want to send to Influx.
local servicesTable = {}

servicesTable['urn:micasaverde-com:serviceId:HaDevice1'] = {}
servicesTable['urn:micasaverde-com:serviceId:HaDevice1']['fields'] = {"BatteryLevel", "PollRatings", "WakeupRatings", "LastUpdate"}
servicesTable['urn:micasaverde-com:serviceId:HaDevice1']['watchedFields'] = {}
servicesTable['urn:micasaverde-com:serviceId:HaDevice1']['tags'] = {}

servicesTable['urn:micasaverde-com:serviceId:ZWaveDevice1'] = {}
servicesTable['urn:micasaverde-com:serviceId:ZWaveDevice1']['fields'] = {"Health"}
servicesTable['urn:micasaverde-com:serviceId:ZWaveDevice1']['watchedFields'] = {}
servicesTable['urn:micasaverde-com:serviceId:ZWaveDevice1']['tags'] = {"ConfiguredName","MeterType"}

servicesTable['urn:upnp-org:serviceId:SwitchPower1'] = {}
servicesTable['urn:upnp-org:serviceId:SwitchPower1']['fields'] = {"Target", "Status"}
servicesTable['urn:upnp-org:serviceId:SwitchPower1']['watchedFields'] = {"Status"}
servicesTable['urn:upnp-org:serviceId:SwitchPower1']['tags'] = {}

servicesTable['urn:upnp-org:serviceId:Dimming1'] = {}
servicesTable['urn:upnp-org:serviceId:Dimming1']['fields'] = {"LoadLevelTarget", "LoadLevelStatus"}
servicesTable['urn:upnp-org:serviceId:Dimming1']['watchedFields'] = {}
servicesTable['urn:upnp-org:serviceId:Dimming1']['tags'] = {}

servicesTable['urn:micasaverde-com:serviceId:DoorLock1'] = {}
servicesTable['urn:micasaverde-com:serviceId:DoorLock1']['fields'] = {"Target", "Status"}
servicesTable['urn:micasaverde-com:serviceId:DoorLock1']['watchedFields'] = {"Status"}
servicesTable['urn:micasaverde-com:serviceId:DoorLock1']['tags'] = {}

servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1'] = {}
servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1']['fields'] = {"SetpointTarget", "CurrentSetpoint"}
servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1']['watchedFields'] = {}
servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1']['tags'] = {}

servicesTable['urn:upnp-org:serviceId:TemperatureSensor1'] = {}
servicesTable['urn:upnp-org:serviceId:TemperatureSensor1']['fields'] = {"CurrentTemperature"}
servicesTable['urn:upnp-org:serviceId:TemperatureSensor1']['watchedFields'] = {}
servicesTable['urn:upnp-org:serviceId:TemperatureSensor1']['tags'] = {}

servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1_Heat'] = {}
servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1_Heat']['fields'] = {"CurrentSetpoint"}
servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1_Heat']['watchedFields'] = {}
servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1_Heat']['tags'] = {}

servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1_Cool'] = {}
servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1_Cool']['fields'] = {"CurrentSetpoint"}
servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1_Cool']['watchedFields'] = {}
servicesTable['urn:upnp-org:serviceId:TemperatureSetpoint1_Cool']['tags'] = {}

servicesTable['urn:micasaverde-com:serviceId:GenericSensor1'] = {}
servicesTable['urn:micasaverde-com:serviceId:GenericSensor1']['fields'] = {"CurrentLevel"}
servicesTable['urn:micasaverde-com:serviceId:GenericSensor1']['watchedFields'] = {}
servicesTable['urn:micasaverde-com:serviceId:GenericSensor1']['tags'] = {}

servicesTable['urn:micasaverde-com:serviceId:LightSensor1'] = {}
servicesTable['urn:micasaverde-com:serviceId:LightSensor1']['fields'] = {"CurrentLevel"}
servicesTable['urn:micasaverde-com:serviceId:LightSensor1']['watchedFields'] = {}
servicesTable['urn:micasaverde-com:serviceId:LightSensor1']['tags'] = {}

servicesTable['urn:micasaverde-com:serviceId:HumiditySensor1'] = {}
servicesTable['urn:micasaverde-com:serviceId:HumiditySensor1']['fields'] = {"CurrentLevel"}
servicesTable['urn:micasaverde-com:serviceId:HumiditySensor1']['watchedFields'] = {}
servicesTable['urn:micasaverde-com:serviceId:HumiditySensor1']['tags'] = {}

servicesTable['urn:micasaverde-com:serviceId:EnergyMetering1'] = {}
servicesTable['urn:micasaverde-com:serviceId:EnergyMetering1']['fields'] = {"Watts", "KWH", "Volts", "Amps"}
servicesTable['urn:micasaverde-com:serviceId:EnergyMetering1']['watchedFields'] = {}
servicesTable['urn:micasaverde-com:serviceId:EnergyMetering1']['tags'] = {}

servicesTable['urn:micasaverde-com:serviceId:WaterMetering1'] = {}
servicesTable['urn:micasaverde-com:serviceId:WaterMetering1']['fields'] = {"Flow", "Volume"}
servicesTable['urn:micasaverde-com:serviceId:WaterMetering1']['watchedFields'] = {}
servicesTable['urn:micasaverde-com:serviceId:WaterMetering1']['tags'] = {}

servicesTable['urn:cd-jackson-com:serviceId:SystemMonitor'] = {}
servicesTable['urn:cd-jackson-com:serviceId:SystemMonitor']['fields'] = {"memoryFree", "memoryTotal", "memoryUsed", "memoryAvailable", "cpuLoad1", "cpuLoad5", "cpuLoad15", "systemLuupRestartUnix", "systemVeraRestartUnix", "cmhLastRebootUnix", "uptimeTotal"}
servicesTable['urn:cd-jackson-com:serviceId:SystemMonitor']['watchedFields'] = {}
servicesTable['urn:cd-jackson-com:serviceId:SystemMonitor']['tags'] = {}

-- servicesTable['urn:upnp-arduino-cc:serviceId:arduinonode1'] = {}
-- servicesTable['urn:upnp-arduino-cc:serviceId:arduinonode1']['fields'] = {"Children"}
-- servicesTable['urn:upnp-arduino-cc:serviceId:arduinonode1']['tags'] = {"ArduinoLibVersion", "RelayNode", "RelayNodeHR", "SketchName", "SketchVersion"}

-- servicesTable['urn:upnp-arduino-cc:serviceId:arduino1'] = {}
-- servicesTable['urn:upnp-arduino-cc:serviceId:arduino1']['fields'] = {}
-- servicesTable['urn:upnp-arduino-cc:serviceId:arduino1']['tags'] = {"ArduinoLibVersion", "PluginVersion", "GWAddress"}

servicesTable['urn:micasaverde-com:serviceId:SecuritySensor1'] = {}
servicesTable['urn:micasaverde-com:serviceId:SecuritySensor1']['fields'] = {"LastTrip", "Tripped", "Armed", "ArmedTripped"}
servicesTable['urn:micasaverde-com:serviceId:SecuritySensor1']['watchedFields'] = {"Tripped", "ArmedTripped"}
servicesTable['urn:micasaverde-com:serviceId:SecuritySensor1']['tags'] = {}

servicesTable['urn:upnp-org:serviceId:IPhoneLocator1'] = {}
servicesTable['urn:upnp-org:serviceId:IPhoneLocator1']['fields'] = {"HomeLat", "CurLat", "PrevLat", "HomeLong", "CurLong", "PrevLong", "PrevUpdate", "RTSpeed", "Present", "Muted", "ETA", "Distance", "PrevDistance", "Range"}
servicesTable['urn:upnp-org:serviceId:IPhoneLocator1']['watchedFields'] = {"Present"}
servicesTable['urn:upnp-org:serviceId:IPhoneLocator1']['tags'] = {"DistanceMode", "Version", "PollingMap", "Location"}
	
servicesTable['urn:upnp-org:serviceId:DistanceSensor1'] = {}
servicesTable['urn:upnp-org:serviceId:DistanceSensor1']['fields'] = {"CurrentDistance"}
servicesTable['urn:upnp-org:serviceId:DistanceSensor1']['watchedFields'] = {}
servicesTable['urn:upnp-org:serviceId:DistanceSensor1']['tags'] = {}
	
-- Finish define services and values we want to send to Influx.
	
local http  = require("socket.http")
local url   = require("socket.url")
local ltn12 = require("ltn12")
http.TIMEOUT = 3

local LINE_PROTOCOL = ""

local function veraFluxLog(text)
	local id = VF_PARENT_DEVICE or "unknown"
	luup.log("VeraFlux #" .. id .. " " .. text)
end

local function veraFluxDebugLog(text)
	if (VF_DEBUG_MODE == "1") then
		veraFluxLog("DEBUG " .. text)
	end
end

--
-- Initializes variables if none were found in config
--
local function initSettings(staticTags, period, enable, debugMode, database, ip, port, username, passwd)
	--
	-- Create a fallback delay if no parameters are given    
	--
	if (period == nil or tonumber(period) <= DEFAULT_PERIOD) then
		period = DEFAULT_PERIOD
	end
	-- Defaults
	
	staticTags = staticTags or INFLUX_EXTRATAGS
	enable = enable or 1
	debugMode = debugMode or 0
	
	ip = ip or INFLUX_IP
	port = port or INFLUX_PORT
	database = database or INFLUX_DB
	username = username or "admin"
	passwd = passwd or "password"

	luup.variable_set(VERAFLUX_SID, "Period", period, parentDevice)
	luup.variable_set(VERAFLUX_SID, "StaticTags", staticTags, parentDevice)
	luup.variable_set(VERAFLUX_SID, "FluxCapacitor", enable, parentDevice)
	luup.variable_set(VERAFLUX_SID, "Debug", debugMode, parentDevice)
	luup.variable_set(VERAFLUX_SID, "InfluxDB", database, parentDevice)
	luup.variable_set(VERAFLUX_SID, "InfluxIP", ip, parentDevice)
	luup.variable_set(VERAFLUX_SID, "InfluxPort", port, parentDevice)
	luup.variable_set(VERAFLUX_SID, "InfluxUser", username, parentDevice)
	luup.variable_set(VERAFLUX_SID, "InfluxPassword", passwd, parentDevice)
	luup.variable_set(HADEVICE_SID, "LastUpdate", os.time(os.date('*t')), parentDevice)
	luup.variable_set(HADEVICE_SID, "Configured", "1", parentDevice)

	veraFluxLog("Initialized variable: 'Tags' = " .. staticTags)
	veraFluxLog("Initialized variable: 'Period' = " .. period)
	veraFluxLog("Initialized variable: 'FluxCapacitor' = " .. enable)
	veraFluxLog("Initialized variable: 'Debug' = " .. debugMode)
	veraFluxLog("Initialized variable: 'DB' = " .. database)
	veraFluxLog("Initialized variable: 'IP' = " .. ip)
	veraFluxLog("Initialized variable: 'Port' = " .. port)
	veraFluxLog("Initialized variable: 'User' = " .. username)
	veraFluxLog("Initialized variable: 'Pass' = " .. passwd)

	luup.task("Please restart Luup to initialize the plugin.", 1, "VeraFlux", -1)
	
	return staticTags, period, enable, debugMode, database, ip, port, username, passwd
end


local function readSettings(parentDevice)
	--
	-- Get local address and delay between repetition from configuration
	--
	local staticTags, tstamp = luup.variable_get(VERAFLUX_SID, "StaticTags", parentDevice)
	local period, tstamp = luup.variable_get(VERAFLUX_SID, "Period", parentDevice)
	local enable, tstamp = luup.variable_get(VERAFLUX_SID, "FluxCapacitor", parentDevice)
	local debugMode, tstamp = luup.variable_get(VERAFLUX_SID, "Debug", parentDevice)
	local database, tstamp = luup.variable_get(VERAFLUX_SID, "InfluxDB", parentDevice)
	local ip, tstamp = luup.variable_get(VERAFLUX_SID, "InfluxIP", parentDevice)
	local port, tstamp = luup.variable_get(VERAFLUX_SID, "InfluxPort", parentDevice)	  
	local username, tstamp = luup.variable_get(VERAFLUX_SID, "InfluxUser", parentDevice)
	local passwd, tstamp = luup.variable_get(VERAFLUX_SID, "InfluxPassword", parentDevice)
	--
	-- init configuration variables if they were empty
	--
	if (staticTags == nil or period == nil or enable == nil or debugMode == nil or database == nil or ip == nil or port == nil or username == nil or passwd == nil) then
		staticTags, period, enable, debugMode, database, ip, port, username, passwd = initSettings(staticTags, period, enable, debugMode, database, ip, port, username, passwd)
	end

	INFLUX_URL = "http://" .. ip .. ":" .. port .. "/write?db=" .. database
	VF_DEBUG_MODE = debugMode
	
	return staticTags, period, enable, debugMode, database, ip, port, username, passwd
end


local function sendVeraFluxData()
	veraFluxDebugLog("Payload is: " .. LINE_PROTOCOL) 
	veraFluxDebugLog("Submitting payload to InfluxDB at: " .. INFLUX_URL) 
	
	-- perform http request
	local response_body = { }
	local res, code, response_headers, status = http.request {
		url = INFLUX_URL,
		method = "POST",
		headers = {
			["Content-Type"] = "text/plain",
			["Content-Length"] = LINE_PROTOCOL:len()
		},
		-- include line protocol payload
		source = ltn12.source.string(LINE_PROTOCOL),
		-- get response body
		sink = ltn12.sink.table(response_body)
	}
	
	veraFluxDebugLog("InfluxDB server replied: " .. code) 
	
	-- reset line protocol variable to avoid memory leak
	LINE_PROTOCOL = ""
end

local function sanitizeTagKeysAndValues(tag)
	-- firstly convert to string
	tag = tostring(tag)
	-- InfluxDB line protocol dictates:
	--  * commas "," must be escaped:
	tag = string.gsub(tag, ",", "\\,")
	--  * equal signs "=" must be escaped:
	tag = string.gsub(tag, "=", "\\=")
	--  * spaces " " must be escaped:
	tag = string.gsub(tag, " ", "\\ ")
	-- lastly, if the tag is "", then change to nil
	if tag == "" then tag = 'nil' end
	return tag
end

local function sanitizeMeasurement(measurement)
	-- firstly convert to string
	measurement = tostring(measurement)
	-- InfluxDB line protocol dictates:
	--  * commas "," must be escaped:
	measurement = string.gsub(measurement, ",", "\\,")
	--  * spaces " " must be escaped:
	measurement = string.gsub(measurement, " ", "\\ ")
	return measurement
end

local function processDevice(deviceId, d, svcsTbl, howTriggered)
	-- prepare the line protocol for an individual device
	--   * deviceId is the device ID number
	--   * d is the device as an object
	--   * svcsTbl is a dictionary with the style of "ServicesTable" declared earlier in the code
	
	local PER_DEVICE_LINE_PROTOCOL = ""
	
	local lineProtocolDeviceTags = ""
	
	veraFluxDebugLog("Processing device " .. tostring(deviceId) .. ": " .. tostring(d.device_type)) 
	--
	-- build the line protocol
	-- 
	-- Start tag section
	-- add INFLUX_EXTRATAGS
	if INFLUX_EXTRATAGS ~= "" then
		lineProtocolDeviceTags = lineProtocolDeviceTags .. "," .. INFLUX_EXTRATAGS
	end
	
	-- "pk_accesspoint" (Vera Serial Number) tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",serial_number=" .. sanitizeTagKeysAndValues(luup.pk_accesspoint)
	-- "luup_engine_version" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",luup_engine_version=" .. sanitizeTagKeysAndValues(luup.version)
	-- "longitude" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",longitude=" .. sanitizeTagKeysAndValues(luup.longitude)
	-- "latitude" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",latitude=" .. sanitizeTagKeysAndValues(luup.latitude)
	-- "timezone" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",timezone=" .. sanitizeTagKeysAndValues(luup.timezone)
	-- "city" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",city=" .. sanitizeTagKeysAndValues(luup.city)
	-- "room_num" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",room_num=" .. sanitizeTagKeysAndValues(d.room_num)
	-- "room_name" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",room_name=" .. sanitizeTagKeysAndValues(luup.rooms[d.room_num])
	-- "device_type" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",device_type=" .. sanitizeTagKeysAndValues(d.device_type)
	-- "category_num" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",category_num=" .. sanitizeTagKeysAndValues(d.category_num)
	-- "subcategory_num" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",subcategory_num=" .. sanitizeTagKeysAndValues(d.subcategory_num)
	-- "deviceID" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",id=" .. sanitizeTagKeysAndValues(deviceId)
	-- "device_num_parent" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",device_num_parent=" .. sanitizeTagKeysAndValues(d.device_num_parent)
	-- "ip" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",ip=" .. sanitizeTagKeysAndValues(d.ip)
	-- "mac" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",mac=" .. sanitizeTagKeysAndValues(d.mac)
	-- "id" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",altid=" .. sanitizeTagKeysAndValues(d.id)
	-- "embedded" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",embedded=" .. sanitizeTagKeysAndValues(d.embedded)
	-- "hidden" tag: 
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",hidden=" .. sanitizeTagKeysAndValues(d.hidden)
	-- "description" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",description=" .. sanitizeTagKeysAndValues(d.description)
	-- "udn" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",udn=" .. sanitizeTagKeysAndValues(d.udn)
	-- "input_method" tag:
	lineProtocolDeviceTags = lineProtocolDeviceTags .. ",input_method=" .. sanitizeTagKeysAndValues(howTriggered or "unknown")
	-- Finish tag section
	
	-- for each service...
	for serviceId, serviceTable in pairs(svcsTbl) do
		
		-- check if the current device supports the service
		if luup.device_supports_service(serviceId, deviceId) then
			
			-- prep variable to hold additional line protocol
			local newLineProtocol = ""
			-- prep variable to use to signify whether or not to put a comma before each successive field
			local firstField = true
			-- prep variable to determine whether we submit line protocol or not
			local submitLineProtocol = false
			
			-- fetch tags
			for i, tag in ipairs(svcsTbl[serviceId]['tags']) do
				tag_value, tstamp = luup.variable_get(serviceId, tag, deviceId)
				tag = sanitizeTagKeysAndValues(tag)
				tag_value = sanitizeTagKeysAndValues(tag_value)
				newLineProtocol = newLineProtocol .. "," .. tag .. "=" .. tag_value
			end
			newLineProtocol = newLineProtocol .. " "
			
			-- fetch values
			for i, field in ipairs(svcsTbl[serviceId]['fields']) do
				field_value, tstamp = luup.variable_get(serviceId, field, deviceId)
				field = sanitizeTagKeysAndValues(field)
				
				-- ensure field value is valid prior to adding
				if field_value ~= nil then
					if not firstField then newLineProtocol = newLineProtocol .. "," end
					newLineProtocol = newLineProtocol .. field .. "=" .. tostring(field_value)
					submitLineProtocol = true
					firstField = false
				end
			end
			
			-- if we've retrieved at least one valid field value, then we should have valid line protocol
			if submitLineProtocol then
				-- add to line protocol payload
				newLineProtocol = sanitizeMeasurement(serviceId) .. lineProtocolDeviceTags .. newLineProtocol .. "\n"
				veraFluxDebugLog("New Line Protocol: " .. newLineProtocol)
				PER_DEVICE_LINE_PROTOCOL = PER_DEVICE_LINE_PROTOCOL .. newLineProtocol
			end
		end
	end
	return PER_DEVICE_LINE_PROTOCOL
end


local function addAllDeviceValues()
	-- loop through all devices
	for deviceId,d in pairs(luup.devices) do
		if not d.invisible then -- ignore "for internal use only" devices
			LINE_PROTOCOL = LINE_PROTOCOL .. processDevice(deviceId, d, servicesTable, "polled")
		end
	end
end


function veraFluxWatchedVariableCallback(lul_device, lul_service, lul_variable, lul_value_old, lul_value_new)
	-- function to be registered as a call back for luup.variable_watch
	--   * lul_device is a number that is the device ID
	--   * lul_service is the service ID (string?)
	--   * lul_variable is the variable name (string?)
	--   * lul_value_old / lul_value_new are the values
	veraFluxDebugLog("veraFluxWatchedVariableCallback: Called with lul_device='" .. tostring(lul_device) .. "', lul_service='" .. tostring(lul_service) .. "', lul_variable='" .. tostring(lul_variable) .. "', lul_value_old='" .. tostring(lul_value_old) .. "', lul_value_new='" .. tostring(lul_value_new))
	
	--  determine if plugin is enabled
	local enable, tstamp = luup.variable_get(VERAFLUX_SID, "FluxCapacitor", VF_PARENT_DEVICE)
	
	-- if plugin is enabled then continue
	if (enable == "1") then
		
		-- loop through all devices to find the changed device
		for deviceId,d in pairs(luup.devices) do
			-- if we've found the watched device...
			if (deviceId == lul_device) then
				
				-- loop through services table to find the watched service
				for serviceId, serviceTable in pairs(servicesTable) do
					-- if we've found the watched service...
					if (lul_service == serviceId) then
						
						veraFluxDebugLog("LiveHouseInflux: watchedVariableCallBack: Fetching data for device " .. tostring(deviceId) .. ", service " .. tostring(serviceId) .. ", variable " .. lul_variable)
						
						-- prepare a servicesTable-type dict to pass to processDevice
						local st = {}
						st[serviceId] = {}
						st[serviceId]['fields'] = {tostring(lul_variable)}      -- we're only interested in the changed variable...
						st[serviceId]['tags'] = servicesTable[serviceId]['tags'] -- but we still want all the tags.
						
						-- process the device and generate line protocol
						LINE_PROTOCOL = LINE_PROTOCOL .. processDevice(deviceId, d, st, "watched")
						
					end
				end
			end
		end
		-- submit line protocol
		sendVeraFluxData() -- send all generated line protocol to influx
		veraFluxDebugLog("veraFluxWatchedVariableCallback: Finished with device " .. tostring(lul_device) .. ", service " .. tostring(lul_service) .. ", variable " .. lul_variable)
	else
		veraFluxDebugLog("LiveHouseInflux: watchedVariableCallBack: Plugin not enabled, discarding changed value for " .. tostring(lul_device))
	end
end


function veraFluxSetupCallbacks()
	-- check to see if the FluxCapacitor is charged before setting up callbacks
	if (enable == "1") then
		-- loop through all devices
		for deviceId,d in pairs(luup.devices) do
			if not d.invisible then -- ignore "for internal use only" devices
				-- for each watched service...
				for serviceId, serviceTable in pairs(servicesTable) do
					-- check if the current device supports the service
					if luup.device_supports_service(serviceId, deviceId) then
						-- for each watched value
						for i, field in ipairs(servicesTable[serviceId]['watchedFields']) do
							-- register the callback
							veraFluxDebugLog("veraFluxSetupCallbacks: Registering variable_watch callback for: serviceId='" .. tostring(serviceId) .. "', variable='" .. tostring(field) .. "', deviceId='" .. tostring(deviceId) .. "'")
							luup.variable_watch("veraFluxWatchedVariableCallback", serviceId, field, deviceId)
						end
					end
				end
			end
		end
	end
end


--
-- The main function is used for starting up device
--
function main(parentDevice)
	--
	-- Note these are "pass-by-Global" values that veraFluxOnTimer will later use.
	--
	VF_PARENT_DEVICE = parentDevice
	
	veraFluxLog("If my calculations are correct, when this baby hits eighty-eight miles per hour, you're gonna see some serious shit.")
	
	-- Validate that parameters are configured in Vera, otherwise this
	-- code wont work.
	--
	local staticTags, period, enable, debugMode, database, ip, port, username, passwd = readSettings(parentDevice)
	
	if (ip == nil or period == nil or database == nil or port == nil) then
		veraFluxLog("That ended badly.")
		luup.set_failure(true, parentDevice)
		return false
	end
	
	-- Do this deferred to avoid slowing down startup processes.
	--
	veraFluxDebugLog("main function - initialise OnTimer and Callbacks")
	luup.call_timer("veraFluxOnTimer", 1, "1", "")
	luup.call_timer("veraFluxSetupCallbacks", 1, "2", "")
	return true
end

--
-- Here are all functions started in the correct sequence
-- triggered by a timer
--
function veraFluxOnTimer()
	--
	-- Reset the timer at the beginning, just in case the subsequent code fails.
	--
	-- The last parameter is temporary, can be removed in later builds once bug fix
	-- is in place (http://forum.micasaverde.com/index.php?topic=1608.0)
	--
	veraFluxDebugLog("Starting veraFluxOnTimer function - readSettings")
	local staticTags, period, enable, debugMode, database, ip, port, username, passwd = readSettings(VF_PARENT_DEVICE)
	veraFluxDebugLog("veraFluxOnTimer function - luup.call_timer")
	luup.call_timer("veraFluxOnTimer", 1, tostring(period), "")
	
	--
	-- To avoid having to be able to "cancel" a running timer, esp after repeated
	-- enable/disable calls, we simply "do nothing" in this code if the timer is
	-- disabled.  The actual timer itself is never stopped, we simply don't respond
	-- if we're disabled.
	--
	if (enable == "1") then
		
		VF_DEBUG_MODE, tstamp = luup.variable_get(VERAFLUX_SID, "Debug", VF_PARENT_DEVICE)
		
		veraFluxDebugLog("STARTING SCHEDULED POLLING")
		addAllDeviceValues() -- cycle through all non-invisible devices and collect values for supported devices
		sendVeraFluxData() -- send all generated line protocol to influx
		veraFluxDebugLog("FINISHED SCHEDULED POLLING") -- may want to comment this out when this script is working	
		veraFluxLog("Flux Capacitor Online, 1.21 Gigawatts available.")
	else
		veraFluxLog("Flux Capacitor Offline. Insert banana skin and beer into Mr. Fusion canister." .. (enable or "No value"))
	end
end