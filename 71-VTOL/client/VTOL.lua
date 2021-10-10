class 'VTOL'

function VTOL:__init()
	self.namept = "Нажмите R чтобы включить автопилот."
	AutoLandActive		=	true	--	Whether or not Auto Land is active by default.		Default: true
	ReverseThrustActive	=	true	--	Whether or not Reverse Thrust is active by default.	Default: true
	self.Display		=	true
	ReverseKey			=	88		--	The key to activate Reverse Thrust, this is X by default.						Default: 88
	NoseKey				=	87		--	The key to pitch the nose, this is W by default.								Default: 87
	TailKey				=	83		--	The key to pitch the tail, this is S by default.								Default: 83
	PlaneVehicles		=	{24, 30, 34, 39, 51, 59, 81, 85}	--	A list of all vehicle IDs of planes.
	PitchSpeedLimit		=	25		--	The max speed in MPS that forced pitching of the nose/tail is allowed. 			Default: 25

	MaxThrust				=	0.3		--	The maximum thrust speed.						Default: 10
	MinThrust				=	0.1		--	The minimum thrust speed.						Default: 0.1
	CurrentThrust			=	0		--	The starting thrust speed.						Default: 0
	MaxReverseThrust		=	1.5		--	The maximum speed a plane can go in reverse.	Default: 1.5
	ThrustIncreaseFactor	=	1.05	--	How quickly thrust is increased.				Default: 1.05

	if LocalPlayer:InVehicle() then
		self.RenderEvent = Events:Subscribe( "Render", self, self.Render )
		self.PreTickEvent = Events:Subscribe( "PreTick", self, self.Thrust )
		self.KeyUpEvent = Events:Subscribe( "KeyUp", self, self.KeyUp )
	end

	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "LocalPlayerEnterVehicle", self, self.LocalPlayerEnterVehicle )
	Events:Subscribe( "LocalPlayerExitVehicle", self, self.LocalPlayerExitVehicle )
end

function VTOL:Lang( args )
	self.namept = "Press R to enable autopilot panel."
end

function VTOL:LocalPlayerEnterVehicle()
	local vehicle = LocalPlayer:GetVehicle()
	if LocalPlayer:GetState() == PlayerState.InVehicle and IsValid(vehicle) and vehicle:GetDriver() == LocalPlayer then
		LocalVehicleModel = vehicle:GetModelId()
		if self:CheckList(PlaneVehicles, LocalVehicleModel) then
			if not self.RenderEvent then
				self.RenderEvent = Events:Subscribe( "Render", self, self.Render )
			end

			if not self.PreTickEvent then
				self.PreTickEvent = Events:Subscribe( "PreTick", self, self.Thrust )
			end

			if not self.KeyUpEvent then
				self.KeyUpEvent = Events:Subscribe( "KeyUp", self, self.KeyUp )
			end

			if not self.hinttimer then
				self.hinttimer = Timer()
			else
				self.hinttimer:Restart()
			end

			CurrentThrust = 0
		end
	end
end

function VTOL:LocalPlayerExitVehicle()
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end

	if self.PreTickEvent then
		Events:Unsubscribe( self.PreTickEvent )
		self.PreTickEvent = nil
	end

	if self.KeyUpEvent then
		Events:Unsubscribe( self.KeyUpEvent )
		self.KeyUpEvent = nil
	end
end

function VTOL:Render()
	local alpha = 255

	if self.hinttimer then
		if self.hinttimer:GetSeconds() > 10 then
			alpha = math.clamp( 255 - ( ( self.hinttimer:GetSeconds() - 10 ) * 500), 0, 255 )
		end
		if self.hinttimer:GetSeconds() > 12 then
			if self.hinttimer then
				self.hinttimer = nil
			end
		end
	end

	if Game:GetState() ~= GUIState.Game then return end
	if LocalPlayer:GetWorld() ~= DefaultWorld then return end
	if not LocalPlayer:GetVehicle() then return end
	if not self.Display then return end
	if not self.hinttimer then return end
	if LocalPlayer:GetValue( "SystemFonts" ) then
		Render:SetFont( AssetLocation.SystemFont, "Impact" )
	end
	local vehicle = LocalPlayer:GetVehicle()
	if LocalPlayer:GetState() == PlayerState.InVehicle and IsValid(vehicle) and vehicle:GetDriver() == LocalPlayer then
		LocalVehicleModel = vehicle:GetModelId()
		if self:CheckList(PlaneVehicles, LocalVehicleModel) then
			local size = Render:GetTextSize( self.namept, 14 )
			local pos = Vector2( ( Render.Width - size.x ) / 2, Render.Height - size.y - 30 )
			if LocalPlayer:GetValue( "Boost" ) then
				pos = Vector2( ( Render.Width - size.x ) / 2, Render.Height - size.y - 30 )
			else
				pos = Vector2( ( Render.Width - size.x ) / 2, Render.Height - size.y - 10 )
			end

			Render:DrawText( pos + Vector2.One, self.namept, Color( 0, 0, 0, alpha ), 14 )
			Render:DrawText( pos, self.namept, Color( 255, 255, 255, alpha ), 14 )
		end
	end
end

function VTOL:CheckThrust()
	CurrentThrust	=	CurrentThrust * ThrustIncreaseFactor
	if CurrentThrust < MinThrust then
		CurrentThrust	=	MinThrust
	elseif CurrentThrust > MaxThrust then
		CurrentThrust	=	MaxThrust
	end
	ReverseThrust	=	CurrentThrust
	if ReverseThrust > MaxReverseThrust then
		ReverseThrust = MaxReverseThrust
	end
end

function VTOL:Thrust( args )
	if Game:GetState() ~= GUIState.Game then return end
	local vehicle = LocalPlayer:GetVehicle()
	if LocalPlayer:GetState() == PlayerState.InVehicle and IsValid(vehicle) and vehicle:GetDriver() == LocalPlayer then
		LocalVehicleModel = vehicle:GetModelId()
		if self:CheckList(PlaneVehicles, LocalVehicleModel) then
			local VehicleVelocity = vehicle:GetLinearVelocity()
			if IsValid(vehicle) then
				if Key:IsDown(ReverseKey) and ReverseThrustActive then
					self:CheckThrust()
					local VehicleAngle = vehicle:GetAngle()
					local SetThrust	= VehicleVelocity + VehicleAngle * Vector3( 0, 0, ReverseThrust )
					local SendInfo = {}
						SendInfo.Player		=	LocalPlayer
						SendInfo.Vehicle	=	vehicle
						SendInfo.Thrust		=	SetThrust
					Network:Send( "ActivateThrust", SendInfo )
				end
				if VehicleVelocity:Length() <= PitchSpeedLimit then
					if Key:IsDown(NoseKey) then
						local VehicleAngle		=	vehicle:GetAngle()
						local SetThrust			=	VehicleAngle * Vector3( -0.25, 0, 0 )
						local SendInfo	=	{}
							SendInfo.Player		=	LocalPlayer
							SendInfo.Vehicle	=	vehicle
							SendInfo.Thrust		=	SetThrust
						Network:Send("ActivateAngularThrust", SendInfo )
					end
					if Key:IsDown(TailKey) then
						local VehicleAngle		=	vehicle:GetAngle()
						local SetThrust			=	VehicleAngle * Vector3( 0.25, 0, 0 )
						local SendInfo	=	{}
							SendInfo.Player		=	LocalPlayer
							SendInfo.Vehicle	=	vehicle
							SendInfo.Thrust		=	SetThrust
						Network:Send( "ActivateAngularThrust", SendInfo )
					end
				end
			end
		end
	end
end

function VTOL:CheckList( tableList, modelID )
	for k,v in pairs(tableList) do
		if v == modelID then return true end
	end
	return false
end

function VTOL:KeyUp( args )
	if args.key == VirtualKey.F11 then
		self.Display = not self.Display
	end
end

vtol = VTOL()