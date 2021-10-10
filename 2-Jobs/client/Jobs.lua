class 'PanauDrivers'

function PanauDrivers:__init()
	self.markers = true
	self.flooder = true
	self.locationsVisible = true
	self.locationsAutoHide = true
	self.locations = {}
	self.availableJob = nil
	self.availableJobKey = 0
	self.taskscomplatedcount = 0
	self.job = nil
	self.jobUpdateTimer = Timer()
	self.opcolor = Color( 251, 184, 41 )
	self.jobcolor = Color( 192, 255, 192 )

	if LocalPlayer:GetValue( "Lang" ) and LocalPlayer:GetValue( "Lang" ) == "ENG" then
		self:Lang()
	else
		self.rewardtip = "Награда: $"
		self.vehicletip = "Транспорт: "
		self.delivto = "Доставить к "
		self.target = "● Цель: "
		self.taskstartedtxt = "Задание начато!"
		self.taskfailedtxt = "Задание провалено!"
		self.taskcompletedtxt = "Задание выполнено!"
		self.taskcomplatedcounttxt = "Заданий выполнено: "
	end

	self.window = Rectangle.Create()
	self.window:SetColor( Color( 0, 0, 0, 200 ) )
	self.window:SetSize( Vector2( 300, 110 ))
	self.window:SetPositionRel( Vector2( 0.5, 0.8 ) - self.window:GetSizeRel()/2 )
	self.window:SetVisible( false )

	self.descriptionLabel = Label.Create( self.window )
	self.descriptionLabel:SetDock( GwenPosition.Fill )

	self.windowL1 = Label.Create( self.descriptionLabel, "job description" )
	self.windowL2 = Label.Create( self.descriptionLabel, "job money" )
	self.windowL3 = Label.Create( self.descriptionLabel, "job vehicle" )
	self.windowButton = Rectangle.Create( self.window, "job start" )
	self.StartJobLabel = Label.Create( self.windowButton, "job start" )

	self.descriptionLabel:SetMargin( Vector2( 5, 10 ), Vector2( 5, 5 ) )

	self.windowL2:SetText( self.rewardtip .. "777" )
	self.windowL2:SetTextColor( self.opcolor )
	self.windowL2:SetSize( Vector2( 290, 16 ))
	self.windowL2:SetTextSize( 15 )
	self.windowL3:SetText( self.vehicletip .. "Вилка" )
	self.windowL3:SetSize( Vector2( 290, 16 ))
	self.windowL3:SetPosition( Vector2( 0, self.windowL2:GetPosition().y + 20 ))
	self.windowL1:SetText( "-" )
	self.windowL1:SetSize( Vector2( 290, 30 ) )
	self.windowL1:SetPosition( Vector2( 0, self.windowL3:GetPosition().y + 15 ) )

	self.StartJobLabel:SetText( "Нажмите J, чтобы начать задание" )
	self.StartJobLabel:SetDock( GwenPosition.Top )
	self.StartJobLabel:SetTextSize( 15 )
	self.StartJobLabel:SetMargin( Vector2( 0, 6 ), Vector2() )
	self.StartJobLabel:SetAlignment( GwenPosition.CenterH )
	self.StartJobLabel:SizeToContents()

	self.windowButton:SetColor( Color( 255, 255, 255, 30 ) )
	self.windowButton:SetDock( GwenPosition.Top )
	self.windowButton:SetHeight( 25 )

	Network:Subscribe( "Locations", self, self.Locations )
	Network:Subscribe( "Jobs", self, self.Jobs )
	Network:Subscribe( "JobStart", self, self.JobStart )
	Network:Subscribe( "JobFinish", self, self.JobFinish )
	Network:Subscribe( "JobsUpdate", self, self.JobsUpdate )
	Network:Subscribe( "JobCancel", self, self.JobCancel )

	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "Render", self, self.Render )
	Events:Subscribe( "Render", self, self.GameRender )
	Events:Subscribe( "GameRenderOpaque", self, self.GameRenderOpaque )

	if not self.LocalPlayerInputEvent then
		self.LocalPlayerInputEvent = Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	end
	if not self.KeyUpEvent then
		self.KeyUpEvent = Events:Subscribe( "KeyUp", self, self.KeyUp )
	end
end

function PanauDrivers:Lang()
	if self.StartJobLabel then
		self.StartJobLabel:SetText( "Press J to start task" )
	end
	self.rewardtip = "Reward: $"
	self.vehicletip = "Vehicle: "
	self.delivto = "Deliver to "
	self.target = "● Objective: "
	self.taskstartedtxt = "Task started!"
	self.taskfailedtxt = "Task failed!"
	self.taskcompletedtxt = "Task completed!"
	self.taskcomplatedcounttxt = "Tasks completed: "
end

function PanauDrivers:Locations( args )
	self.locations = args
end

function PanauDrivers:Jobs( args )
	self.jobsTable = args
end

function PanauDrivers:JobsUpdate( args )
	if self.jobsTable then
		self.jobsTable[args[1]] = args[2]
	end
end

function PanauDrivers:JobStart( args )
	self.job = args
	Waypoint:SetPosition(self.locations[self.job.destination].position)
	if self.locationsAutoHide == true then
		Events:Fire( "CastCenterText", { text = self.taskstartedtxt, time = 6, color = Color( 0, 255, 0 ) } )
		self.sound = ClientSound.Create(AssetLocation.Game, {
			bank_id = 25,
			sound_id = 47,
			position = Camera:GetPosition(),
			angle = Camera:GetAngle()
		})

		self.sound:SetParameter(0,1)
		self.locationsVisible = false

		if not self.PreTickEvent then
			self.jobCompleteTimer = Timer()
			self.PreTickEvent = Events:Subscribe( "PreTick", self, self.PreTick )
		end
	end
	if self.LocalPlayerInputEvent then
		Events:Unsubscribe( self.LocalPlayerInputEvent )
		self.LocalPlayerInputEvent = nil
	end
	if self.KeyUpEvent then
		Events:Unsubscribe( self.KeyUpEvent )
		self.KeyUpEvent = nil
	end
end

function PanauDrivers:JobFinish( args )
	if self.job != nil then
		self.markers = true
		Events:Fire( "CastCenterText", { text = self.taskcompletedtxt, time = 6, color = Color( 0, 255, 0 ) } )
		self.sound = ClientSound.Create(AssetLocation.Game, {
			bank_id = 25,
			sound_id = 45,
			position = Camera:GetPosition(),
			angle = Camera:GetAngle()
		})
		self.sound:SetParameter(0,1)
		self.flooder = true
		Waypoint:Remove()
		self.job = nil
		self.taskscomplatedcount = self.taskscomplatedcount + 1
		Game:ShowPopup( self.taskcomplatedcounttxt .. self.taskscomplatedcount, true )
	end
	if self.locationsAutoHide == true then
		self.locationsVisible = true
	end
	if self.PreTickEvent then
		Events:Unsubscribe( self.PreTickEvent )
		self.PreTickEvent = nil
		self.jobCompleteTimer = nil
	end
	if not self.LocalPlayerInputEvent then
		self.LocalPlayerInputEvent = Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	end
	if not self.KeyUpEvent then
		self.KeyUpEvent = Events:Subscribe( "KeyUp", self, self.KeyUp )
	end
end

function PanauDrivers:JobCancel( args )
	if self.job != nil then
		self.markers = true
		Events:Fire( "CastCenterText", { text = self.taskfailedtxt, time = 6, color = Color.Red } )
		self.sound = ClientSound.Create(AssetLocation.Game, {
			bank_id = 25,
			sound_id = 46,
			position = Camera:GetPosition(),
			angle = Camera:GetAngle()
		})
		self.sound:SetParameter(0,1)
		self.flooder = true
		Waypoint:Remove()
		self.job = nil
	end
	if self.locationsAutoHide == true then
		self.locationsVisible = true
	end
	if self.PreTickEvent then
		Events:Unsubscribe( self.PreTickEvent )
		self.PreTickEvent = nil
		self.jobCompleteTimer = nil
	end
	if not self.LocalPlayerInputEvent then
		self.LocalPlayerInputEvent = Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	end
	if not self.KeyUpEvent then
		self.KeyUpEvent = Events:Subscribe( "KeyUp", self, self.KeyUp )
	end
end

function PanauDrivers:PreTick( args )
	if self.jobCompleteTimer and self.jobCompleteTimer:GetSeconds() > 1 and self.job != nil and LocalPlayer:GetVehicle() != nil then
		self.jobCompleteTimer:Restart()
		pVehicle = LocalPlayer:GetVehicle()
		jDist = self.locations[self.job.destination].position:Distance( pVehicle:GetPosition() )
		if jDist < 20 then
			Network:Send( "CompleteJob", nil )
		end
	end
end

function PanauDrivers:KeyUp( a )
	if Game:GetState() ~= GUIState.Game then return end
	local args = {}
	args.job = self.availableJobKey
	if a.key == string.byte("J") and args.job != 0 then
		Network:Send( "TakeJob", args )
		self.StartJobLabel:SetTextColor( Color( 255, 0, 0 ) )
	else
		self.StartJobLabel:SetTextColor( Color( 255, 255, 255 ) )
		self.flooder = true
	end
end

function PanauDrivers:LocalPlayerInput( a )
	if Game:GetState() ~= GUIState.Game then return end
	local args = {}
	args.job = self.availableJobKey
	if Game:GetSetting(GameSetting.GamepadInUse) == 1 then
		if self.flooder then
			if a.input == Action.EquipBlackMarketBeacon and args.job != 0 then
				Network:Send( "TakeJob", args )
				self.StartJobLabel:SetTextColor( Color( 255, 0, 0 ) )
				self.flooder = false
			else
				self.StartJobLabel:SetTextColor( Color( 255, 255, 255 ) )
			end
		end
	end
end

function PanauDrivers:DrawLocation(k, v, dist, dir, jobDistance)
	if self.locationsVisible == true and dist <= 100 and self.job == nil then
		t2 = Transform3()
		local upAngle = Angle(0, math.pi/2, 0)
		local textAlpha = 255
		if dist >= 10 then
			textAlpha = - dist * 2.55
		end
		t2:Translate(v.position):Rotate(upAngle)
		Render:SetTransform(t2)
		Render:DrawCircle( Vector3.Zero, 3, Color( 255, 255, 255, textAlpha ) )
	end
end	

function PanauDrivers:DrawLocation2(k, v, dist, dir, jobDistance)
	if dist >= 100 then return end

	local pos = v.position + Vector3( 0, 3, 0 )
	local angle = Angle( Camera:GetAngle().yaw, 0, math.pi ) * Angle( math.pi, 0, 0 )

	local textSize = 100
	local textScale = 0.005
	local textAlpha = 255
	if dist >= 10 then
		textAlpha = - dist * 2.55
	end

	local text = v.name
	local textBoxScale = Render:GetTextSize( text, textSize )

	local t = Transform3()
	t:Translate( pos )
	t:Scale( textScale )
    t:Rotate( angle )
    t:Translate( -Vector3( textBoxScale.x, textBoxScale.y, 0 )/2 )

    Render:SetTransform( t )

	if self.job == nil then
		if self.locationsVisible == true then
			Render:DrawText( Vector3( 0, 0, 0 ), text, Color( 255, 255, 255, textAlpha ), textSize ) end

		if self.locationsVisible == true then
			if self.job == nil then
				local arrowColor = Color( 0, 0, 0 , 128 )
				if jobDistance < 1000 then
					arrowColor = Color( 64, 255, 128, 58 )
				elseif jobDistance < 2000 then
					arrowColor = Color( 128, 255, 196, 58 )
				elseif jobDistance < 4000 then
					arrowColor = Color( 128, 255, 0, 58 )
				elseif jobDistance < 6000 then
					arrowColor = Color( 255, 255, 0, 58 )
				elseif jobDistance < 8000 then
					arrowColor = Color( 255, 128, 0, 58 )
				elseif jobDistance < 10000 then
					arrowColor = Color( 255, 128, 0, 58 )
				elseif jobDistance < 14000 then
					arrowColor = Color( 255, 0, 0, 58 )
				else
					arrowColor = Color( 128, 0, 255, 58 )
				end
				Render:ResetTransform()
			end
		end
	end

	Render:ResetTransform()

	if dist <= 5 and self.job == nil then
		local theJob = self.jobsTable[k]
		if self.jobUpdateTimer:GetSeconds() > 1 then
			self.windowL1:SetText( self.delivto .. theJob.description )
			self.windowL1:SetTextColor( self.jobcolor )
			self.windowL2:SetText( self.rewardtip .. tostring(theJob.reward) )
			self.windowL2:SetTextColor( self.opcolor )
			self.windowL3:SetText( self.vehicletip .. Vehicle.GetNameByModelId(theJob.vehicle) )
			self.jobUpdateTimer:Restart()
		end
		if Game:GetState() ~= GUIState.Game then return end
		if LocalPlayer:GetValue( "SystemFonts" ) then
			self.windowL2:SetFont( AssetLocation.SystemFont, "Impact")
			self.StartJobLabel:SetFont( AssetLocation.SystemFont, "Impact")
		end
		self.window:SetVisible( true )
		self.availableJobKey = k
		self.availableJob = theJob
	end
end

function PanauDrivers:Render()
	if LocalPlayer:GetWorld() ~= DefaultWorld then return end
	if not LocalPlayer:GetValue( "JobsVisible" ) then return end

	if self.sound then
		self.sound:SetPosition( Camera:GetPosition() )
		self.sound:SetParameter( 0, Game:GetSetting(GameSetting.MusicVolume) / 100 )
	end

	if Game:GetState() ~= GUIState.Game then return end

	if self.jobsTable != nil then
		for k, v in ipairs(self.locations) do
			local camPos = Camera:GetPosition()
			local jobToRender = self.jobsTable[k]
			if v.position.x > camPos.x - 1028 and v.position.x < camPos.x + 1028 and v.position.z > camPos.z - 1028 and v.position.z < camPos.z + 1028 and jobToRender.direction != nil then
				local mapPos = Render:WorldToMinimap( Vector3( v.position.x, v.position.y, v.position.z ) )
				if self.markers and LocalPlayer:GetValue( "JobsMarkersVisible" ) then
					Render:DrawCircle( mapPos, Render.Size.x / 450, Color( 0, 0, 0, Game:GetSetting(4) * 2.25 ) )
					Render:DrawCircle( mapPos, Render.Size.x / 650, Color( 255, 255, 255, Game:GetSetting(4) * 2.25 ) )
					Render:FillCircle( mapPos, Render.Size.x / 650,  Color( 255, 255, 255, Game:GetSetting(4) * 2.25 / 4 ) )
				end
			end
		end
	end

	if self.job != nil then
		self.markers = false
		if LocalPlayer:GetValue( "SystemFonts" ) then
			Render:SetFont( AssetLocation.SystemFont, "Impact" )
		end
		local textPos = Vector2( Render.Width / 2, Render.Height * 0.07 )
		local text = self.target .. self.delivto .. self.job.description
		textPos = textPos - Vector2( Render:GetTextWidth( text ) / 2, 0 )
		Render:DrawText( textPos + Vector2.One, text, Color( 0, 0, 0, 80 ) )
		Render:DrawText( textPos, text, Color( 192, 255, 192 ))

		destPos = self.locations[self.job.destination].position
		destDist = Vector3.Distance(destPos, LocalPlayer:GetPosition())
		if destDist < 500 then
			t2 = Transform3()
			local upAngle = Angle( 0, math.pi/2, 0)
			t2:Translate(destPos):Rotate(upAngle)
			Render:SetTransform(t2)
			Render:DrawCircle( Vector3( 0, 0, 0 ), 10, Color( 64, 255, 64, 64 ) )
		end

	pVehicle = LocalPlayer:GetVehicle()
		if pVehicle != nil then
			local multiArrow = 1
			while (multiArrow > 0) do
				arrowDir = pVehicle:GetPosition() - destPos
				arrowDir:Normalize()
				arrowDir = arrowDir + Vector3( 0, .1, 0 )
				arrowDir.y = -arrowDir.y
				arrowDir.z = -arrowDir.z
				arrowDir.x = -arrowDir.x
				local arrowAxis = Vector3( 0, 1, 0 )
				if (multiArrow == 3) then
					arrowAxis = Vector3( 0, 0, 1 )
				end
				if (multiArrow == 2) then
					arrowAxis = Vector3( 1, 0, 0 )
				end
				dirCp = arrowDir:Cross( arrowAxis )
				dirCn = arrowAxis:Cross( arrowDir )
				Render:ResetTransform()

				arrowScale = Render.Height * .05
				arrow1 = dirCp * arrowScale * 2
				arrow2 = dirCn * arrowScale * 2
				arrow3 = Vector3( 0, 0, 0 ) - ( arrowDir * arrowScale * 2 )
				shaft1 = dirCp * arrowScale
				shaft2 = dirCn * arrowScale
				shaft3 = shaft1 + ( arrowDir * arrowScale * 2 )
				shaft4 = shaft2 + ( arrowDir * arrowScale * 2 )

				local ang = Camera:GetAngle():Inverse()
				arrow1 = ang * arrow1
				arrow2 = ang * arrow2
				arrow3 = ang * arrow3
				shaft1 = ang * shaft1
				shaft2 = ang * shaft2
				shaft3 = ang * shaft3
				shaft4 = ang * shaft4

				center = Vector2( Render.Width / 2, Render.Height / 3 )
				arrow1 = Vector2( -arrow1.x, arrow1.y) + center
				arrow2 = Vector2( -arrow2.x, arrow2.y) + center
				arrow3 = Vector2( -arrow3.x, arrow3.y) + center
				shaft1 = Vector2( -shaft1.x, shaft1.y ) + center
				shaft2 = Vector2( -shaft2.x, shaft2.y ) + center
				shaft3 = Vector2( -shaft3.x, shaft3.y ) + center
				shaft4 = Vector2( -shaft4.x, shaft4.y ) + center

				local arrowColor = Color( 5, 255, 64, 128 )
				Render:FillTriangle( arrow1, arrow2, arrow3, arrowColor )
				Render:FillTriangle( shaft1, shaft2, shaft3, arrowColor )
				Render:FillTriangle( shaft2, shaft3, shaft4, arrowColor )

				multiArrow = multiArrow - 1
			end
		end
	end
end

function PanauDrivers:GameRender()
	if LocalPlayer:GetWorld() ~= DefaultWorld then return end
	if not LocalPlayer:GetValue( "JobsVisible" ) then return end

	availableJob = nil
	self.window:SetVisible( false )

	if Game:GetState() ~= GUIState.Game then return end

	if self.jobsTable != nil then
		for k, v in ipairs(self.locations) do
			local camPos = Camera:GetPosition()
			local jobToRender = self.jobsTable[k]
			if v.position.x > camPos.x - 1028 and v.position.x < camPos.x + 1028 and v.position.z > camPos.z - 1028 and v.position.z < camPos.z + 1028 and jobToRender.direction != nil then
				if LocalPlayer:GetValue( "SystemFonts" ) then
					Render:SetFont( AssetLocation.SystemFont, "Impact" )
				end
				self:DrawLocation2( k, v, v.position:Distance2D( Camera:GetPosition()), jobToRender.direction, jobToRender.distance )
			end
		end
	end	
end

function PanauDrivers:GameRenderOpaque()
	if LocalPlayer:GetWorld() ~= DefaultWorld then return end
	if Game:GetState() ~= GUIState.Game then return end
	if not LocalPlayer:GetValue( "JobsVisible" ) then return end

	if self.jobsTable != nil then
		for k, v in ipairs(self.locations) do
			local camPos = Camera:GetPosition()
			local jobToRender = self.jobsTable[k]
			if v.position.x > camPos.x - 1028 and v.position.x < camPos.x + 1028 and v.position.z > camPos.z - 1028 and v.position.z < camPos.z + 1028 and jobToRender.direction != nil then
				if LocalPlayer:GetValue( "SystemFonts" ) then
					Render:SetFont( AssetLocation.SystemFont, "Impact" )
				end
				self:DrawLocation( k, v, v.position:Distance2D( Camera:GetPosition()), jobToRender.direction, jobToRender.distance )
			end
		end
	end	
end

panaudrivers = PanauDrivers()