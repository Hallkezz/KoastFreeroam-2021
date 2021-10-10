class 'Mapping'

function Mapping:__init()
	Events:Subscribe( "ModuleLoad", self, self.StaticObject )
	Events:Subscribe( "ModuleUnload", self, self.ModuleUnload )
end

function Mapping:StaticObject( args )
	local args     = {}
	args.position  = Vector3( 12772.375976563,1378.9853515625,6049.072265625 )
	args.angle     = Angle( 0.0073636039160192,0.045337688177824,0.20024675130844,0.97866827249527 )
	args.model     = "17x48.nl/go666-a.lod"
	args.collision = "17x48.nl/go666_lod1-a_col.pfx"

	self.object = StaticObject.Create(args)

	local argsTw     = {}
	argsTw.position  = Vector3( 12774.028320313,1379.1522216797,6067.2001953125 )
	argsTw.angle     = Angle( 0.0073636039160192,0.045337688177824,0.20024675130844,0.97866827249527 )
	argsTw.model     = "17x48.nl/go666-a.lod"
	argsTw.collision = "17x48.nl/go666_lod1-a_col.pfx"

	self.objectTw = StaticObject.Create(argsTw)

	local argsR     = {}
	argsR.position  = Vector3( 15053.65625,2087.8701171875,5845.6416015625 )
	argsR.angle     = Angle( 0,0.044913966208696,0,0.99899083375931 )
	argsR.model     = "17x25.nl/gb028-a.lod"
	argsR.collision = "17x25.nl/gb028_lod1-a_col.pfx"

	self.objectR = StaticObject.Create(argsR)

	local argsRTw     = {}
	argsRTw.position  = Vector3( 14768.958984375,2087.8498535156,5871.3208007813 )
	argsRTw.angle     = Angle( 0,0.044913966208696,0,0.99899083375931 )
	argsRTw.model     = "17x25.nl/gb028-a.lod"
	argsRTw.collision = "17x25.nl/gb028_lod1-a_col.pfx"

	self.objectRTw = StaticObject.Create(argsRTw)

	local argsRTh     = {}
	argsRTh.position  = Vector3( 14529.494140625,2038.7054443359,5893.6396484375 )
	argsRTh.angle     = Angle( 0.0073636039160192,0.045337688177824,0.20024675130844,0.97866827249527 )
	argsRTh.model     = "17x25.nl/gb028-a.lod"
	argsRTh.collision = "17x25.nl/gb028_lod1-a_col.pfx"

	self.objectRTh = StaticObject.Create(argsRTh)

	local argsRFo     = {}
	argsRFo.position  = Vector3( 14267.790039063,1926.4476318359,5918.1645507813 )
	argsRFo.angle     = Angle( 0.0073636039160192,0.045337688177824,0.20024675130844,0.97866827249527 )
	argsRFo.model     = "17x25.nl/gb028-a.lod"
	argsRFo.collision = "17x25.nl/gb028_lod1-a_col.pfx"

	self.objectRFo = StaticObject.Create(argsRFo)

	local argsRFi     = {}
	argsRFi.position  = Vector3( 14006.322265625,1814.2984619141,5942.701171875 )
	argsRFi.angle     = Angle( 0.0073636039160192,0.045337688177824,0.20024675130844,0.97866827249527 )
	argsRFi.model     = "17x25.nl/gb028-a.lod"
	argsRFi.collision = "17x25.nl/gb028_lod1-a_col.pfx"

	self.objectRFi = StaticObject.Create(argsRFi)

	local argsRSi     = {}
	argsRSi.position  = Vector3( 13744.618164063,1702.0406494141,5967.2260742188 )
	argsRSi.angle     = Angle( 0.0073636039160192,0.045337688177824,0.20024675130844,0.97866827249527 )
	argsRSi.model     = "17x25.nl/gb028-a.lod"
	argsRSi.collision = "17x25.nl/gb028_lod1-a_col.pfx"

	self.objectRSi = StaticObject.Create(argsRSi)

	local argsRSe     = {}
	argsRSe.position  = Vector3( 13482.999023438,1589.8735351563,5991.7387695313 )
	argsRSe.angle     = Angle( 0.0073636039160192,0.045337688177824,0.20024675130844,0.97866827249527 )
	argsRSe.model     = "17x25.nl/gb028-a.lod"
	argsRSe.collision = "17x25.nl/gb028_lod1-a_col.pfx"

	self.objectRSe = StaticObject.Create(argsRSe)

	local argsRNi     = {}
	argsRNi.position  = Vector3( 13221.689453125,1477.8264160156,6016.2080078125 )
	argsRNi.angle     = Angle( 0.0073636039160192,0.045337688177824,0.20024675130844,0.97866827249527 )
	argsRNi.model     = "17x25.nl/gb028-a.lod"
	argsRNi.collision = "17x25.nl/gb028_lod1-a_col.pfx"

	self.objectRNi = StaticObject.Create(argsRNi)

	local argsRX     = {}
	argsRX.position  = Vector3( 12960.0703125,1365.6593017578,6040.720703125 )
	argsRX.angle     = Angle( 0.0073636039160192,0.045337688177824,0.20024675130844,0.97866827249527 )
	argsRX.model     = "17x25.nl/gb028-a.lod"
	argsRX.collision = "17x25.nl/gb028_lod1-a_col.pfx"

	self.objectRX = StaticObject.Create(argsRX)

	local argsSub     = {}
	argsSub.position  = Vector3( 16275, 212.5, -7800 )
	argsSub.angle     = Angle.Zero
	argsSub.model     = "km04.submarine.eez/key014_02-a.lod"
	argsSub.collision = "km07.submarine.eez/key014_02_lod1-a_col.pfx"

	self.objectSub = StaticObject.Create(argsSub)

	local argsSubInt     = {}
	argsSubInt.position  = Vector3( 16275, 212.5, -7800 )
	argsSubInt.angle     = Angle.Zero
	argsSubInt.model     = "km04.submarine.eez/key014_02-interior.lod"
	argsSubInt.collision = ""

	self.objectSubInt = StaticObject.Create(argsSubInt)
end

function Mapping:ModuleUnload()
	self.object:Remove()
	self.objectTw:Remove()
	self.objectR:Remove()
	self.objectRTw:Remove()
	self.objectRTh:Remove()
	self.objectRFo:Remove()
	self.objectRFi:Remove()
	self.objectRSi:Remove()
	self.objectRSe:Remove()
	self.objectRNi:Remove()
	self.objectRX:Remove()
	self.objectSub:Remove()
	self.objectSubInt:Remove()
end

mapping = Mapping()