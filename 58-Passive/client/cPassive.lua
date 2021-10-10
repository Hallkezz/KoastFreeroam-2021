class 'Passive'

function Passive:__init()
	self.cooldown = 10
	self.tagOffset = 10
	self.textSize = 16

	if LocalPlayer:GetValue( "Lang" ) and LocalPlayer:GetValue( "Lang" ) == "ENG" then
		self:Lang()
	else
		self.name = "Мирный"
		self.pvpblock = "Вы не можете использовать мирный режим во время боя!"
		self.w = "Подождите "
		self.ws = " секунд, чтобы включить/отключить мирный!"
		self.notusable = "Вы не можете использовать это здесь!"
	end

	self.passiveColor = Color( 255, 255, 255, 55 )

	self.cooltime = 0
	self.actions  = {
		[11] = true, [12] = true, [13] = true, [14] = true,
		[15] = true, [137] = true, [138] = true, [139] = true
		}

	Network:Subscribe( "Text", self, self.Text )

	Events:Subscribe( "PassiveOn", self, self.PassiveOn )
	Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	Events:Subscribe( "InputPoll", self, self.InputPoll )
	Events:Subscribe( "LocalPlayerBulletHit", self, self.LocalPlayerDamage )
	Events:Subscribe( "LocalPlayerExplosionHit", self, self.LocalPlayerDamage )
	Events:Subscribe( "LocalPlayerForcePulseHit", self, self.LocalPlayerDamage )
	Events:Subscribe( "NetworkObjectValueChange", self, self.NetworkObjectValueChange )
	Events:Subscribe( "Render", self, self.Render )
	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "LocalPlayerWorldChange", self, self.LocalPlayerWorldChange )
end

function Passive:Lang( args )
	self.name = "Passive"
	self.pvpblock = "You cannot use Passive Mode during combat!"
	self.w = "Wait "
	self.ws = " seconds to enable/disable passive mode!"
	self.notusable = "You cannot use it here!"
end

function Passive:LocalPlayerWorldChange()
	Network:Send( "Disable" )
end

function Passive:LocalPlayerInput( args )
	if self.actions[args.input] and (LocalPlayer:GetValue("Passive") or LocalPlayer:InVehicle() and LocalPlayer:GetVehicle():GetInvulnerable()) then
		return false
	end
end

function Passive:InputPoll( args )
	if not LocalPlayer:GetValue("Passive") then return end
	Input:SetValue( Action.FireRight, 0 )
	Input:SetValue( Action.FireLeft, 0 )
end

function Passive:Text( message )
	Events:Fire( "CastCenterText", { text = message, time = 3, color = Color( 0, 222, 0, 250 ) } )
end

function Passive:PassiveOn( args )
	if LocalPlayer:GetWorld() ~= DefaultWorld then
		Events:Fire( "CastCenterText", { text = self.notusable, time = 3, color = Color.Red } )
		return
	end

	local time = Client:GetElapsedSeconds()
	if not LocalPlayer:GetValue( "Passive" ) then
		if LocalPlayer:GetValue( "PVPMode" ) then
			Events:Fire( "CastCenterText", { text = self.pvpblock, time = 6, color = Color.Red } )
			return false
		end

		if time < self.cooltime then
			Events:Fire( "CastCenterText", { text = self.w .. math.ceil( self.cooltime - time ) .. self.ws, time = 6, color = Color.Red } )
			return false
		end
	end

	Network:Send( "Toggle", not LocalPlayer:GetValue("Passive") )
	self.cooltime = time + self.cooldown
	return false
end

function Passive:LocalPlayerDamage( args )
	if LocalPlayer:GetValue("Passive") or args.attacker and (args.attacker:GetValue("Vbhys")
		or args.attacker:InVehicle() and args.attacker:GetVehicle():GetInvulnerable()) then
	return false
	end

	if not LocalPlayer:GetValue( "Passive" ) then
		if not self.pvpTimer then
			self.pvpTimer = Timer()
			Network:Send( "TogglePVPMode", { enabled = true } )
		else
			self.pvpTimer:Restart()
		end
	end
end

function Passive:NetworkObjectValueChange( args )
	if args.key == "Passive" and args.object.__type == "LocalPlayer" then
		if args.value then
			Game:FireEvent( "ply.invulnerable" )
			Events:Fire( "GetGod", {godactive = true} )
			Events:Fire( "AntiCheat", {acActive = false} )
		else
			Game:FireEvent( "ply.vulnerable" )
			Events:Fire( "GetGod", {godactive = false} )
			Events:Fire( "AntiCheat", {acActive = true} )
		end
	end
end

function Passive:Render()
	if Game:GetState() ~= GUIState.Game then return end
	if LocalPlayer:GetWorld() ~= DefaultWorld then return end
	if not LocalPlayer:GetValue( "PassiveModeVisible" ) then return end
	if LocalPlayer:GetValue( "SystemFonts" ) then
		Render:SetFont( AssetLocation.SystemFont, "Impact" )
	end

	if self.pvpTimer and self.pvpTimer:GetSeconds() >= 10 then
		Network:Send( "TogglePVPMode", { enabled = false } )
		self.pvpTimer = nil
	end
	--if LocalPlayer:GetValue("Passive") then
	--	if LocalPlayer:GetVehicle() then
	--		if LocalPlayer:GetVehicle():GetLinearVelocity():Length() >= 20 then
	--			Network:Send( "CheckPassive" )
	--		end
	--	end
	--end

    local width = Render:GetTextWidth( self.name )
    local textpos = Vector2( Render.Width/1.52 - width/1.8 + Render:GetTextWidth( self.name, 18 ) / 25, 2 )

	Render:FillArea( Vector2( Render.Width/1.52 - width/1.8, 0 ), Vector2( Render:GetTextWidth( self.name, 18 ) + 5, Render:GetTextHeight( self.name, 18 ) + 2 ), Color( 0, 0, 0, Game:GetSetting(4) * 2.25 / 2.4 ) )

	Render:FillTriangle( Vector2( (Render.Width / 1.52 - width/1.8 - 10), 0 ), Vector2( (Render.Width / 1.52 - width/1.8), 0 ), Vector2( (Render.Width / 1.52 - width/1.8), Render:GetTextHeight( self.name, 18 ) + 2 ), Color( 0, 0, 0, Game:GetSetting(4) * 2.25 / 2.4 ) )
	Render:FillTriangle( Vector2( (Render.Width / 1.52 - width/1.8 + Render:GetTextWidth( self.name, 18 ) + 15), 0 ), Vector2( (Render.Width / 1.52 - width/1.8 + Render:GetTextWidth( self.name, 18 ) + 5), 0 ), Vector2( (Render.Width / 1.52 - width/1.8 + Render:GetTextWidth( self.name, 18 ) + 5 ), Render:GetTextHeight( self.name, 18 ) + 2 ), Color( 0, 0, 0, Game:GetSetting(4) * 2.25 / 2.4 ) )

	if LocalPlayer:GetValue( "Passive" ) then
		Render:DrawText( textpos + Vector2.One, self.name, Color( 0, 0, 0, Game:GetSetting(4) * 2.25 ), 18 )
		self.passiveColor = Color( 0, 250, 154, Game:GetSetting(4) * 2.25 )
	else
		self.passiveColor = Color( 255, 255, 255, Game:GetSetting(4) * 2.25 / 4 )
	end

	Render:DrawText( textpos, self.name, self.passiveColor, 18 )
end

passive = Passive()