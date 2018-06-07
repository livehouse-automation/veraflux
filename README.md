# veraflux
Vera Plugin to send device data to InfluxDB

To use this plugin you'll need a working local InfluxDB instance and a database created with appropriate retention policy. Default database name is "vera".

To create the database within InfluxDB, launch the command line interface on your InfluxDB server with the command ```influx```. Create the database with the following command:

```CREATE DATABASE "vera" WITH DURATION 365d NAME "default-1-year"```

This will create a database named "vera", with a default retention policy of 1 year (365 days). Measurement points older than 1 year will be dropped automatically by InfluxDB. Feel free to lengthen/shorten the retention policy as your requirements dictate.

Copy the Plugin files to Apps->Develop Apps->Luup Files. Then create a device using device file D_VeraFlux1.xml and implementation file I_VeraFlux1.xml then reload Luup.

Use the Settings menu in the device to set the IP, Port and other stuff for the plugin to use.

It currently pulls in data from Vera itself and these services.

-   'urn:micasaverde-com:serviceId:HaDevice1'
-  'urn:micasaverde-com:serviceId:ZWaveDevice1'
-  'urn:upnp-org:serviceId:SwitchPower1'
-  'urn:upnp-org:serviceId:Dimming1'
-  'urn:micasaverde-com:serviceId:DoorLock1'
-  'urn:upnp-org:serviceId:TemperatureSetpoint1'
-  'urn:upnp-org:serviceId:TemperatureSensor1'
-  'urn:upnp-org:serviceId:TemperatureSetpoint1_Heat'
-  'urn:upnp-org:serviceId:TemperatureSetpoint1_Cool'
-  'urn:micasaverde-com:serviceId:GenericSensor1'
-  'urn:micasaverde-com:serviceId:LightSensor1'
-  'urn:micasaverde-com:serviceId:HumiditySensor1'
-  'urn:micasaverde-com:serviceId:EnergyMetering1'
-  'urn:micasaverde-com:serviceId:WaterMetering1'
-  'urn:cd-jackson-com:serviceId:SystemMonitor'
-  'urn:micasaverde-com:serviceId:SecuritySensor1'
-  'urn:upnp-org:serviceId:IPhoneLocator1'
-  'urn:upnp-org:serviceId:DistanceSensor1'

All values are sent to Influx on the polling period. In addition there are watched values for SecuritySensor1, IPhoneLocator1, DoorLock1 and SwitchPower1 which are sent immediately on change. This is to allow more real time dsahboards without polling the hell out of Vera.
   
Known limitations in current beta:

- http only
- Username/Password for InfluxDB don't do anything yet.
- Only way to change what Services/Values get logged to Influx is by editing the implementation file.
- Logs contain cheesy references to Back to the Future.
