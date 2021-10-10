class 'WhatsNew'

function WhatsNew:__init()
	self.actions = {
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[11] = true,
		[12] = true,
		[13] = true,
		[14] = true,
		[17] = true,
		[18] = true,
		[105] = true,
		[137] = true,
		[138] = true,
		[139] = true,
		[16] = true
	}

	Events:Subscribe( "OpenWhatsNew", self, self.Open )
	Events:Subscribe( "Lang", self, self.Lang )
end

function WhatsNew:Lang()
	if self.Menu_button then
		self.Menu_button:SetText( "Continue ( ͡° ͜ʖ ͡°)" )
	end
end

function WhatsNew:Open( args )
	self.titletext = args.titletext
	self.text = args.text
	self.usepause = args.usepause

	if self.usepause then
		local sound = ClientSound.Create(AssetLocation.Game, {
			bank_id = 13,
			sound_id = 1,
			position = LocalPlayer:GetPosition(),
			angle = Angle()
		})

		sound:SetParameter(0,1)
	end

	if not self.RenderEvent then
		self.RenderEvent = Events:Subscribe( "Render", self, self.Render )
	end

	if not self.LocalPlayerInputEvent then
		self.LocalPlayerInputEvent = Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	end

	self.powersImage = Image.Create( AssetLocation.Resource, "Powers" )

	self.Menu_background = Rectangle.Create()
	self.Menu_background:SetHeight( Render.Size.x / 30 )
	self.Menu_background:SetWidth( Render.Size.x / 5 )
	self.Menu_background:SetPosition( Vector2( Render.Size.x / 2 - self.Menu_background:GetWidth() / 2, Render.Size.x / 2.7 ) )
	self.Menu_background:SetColor( Color( 255, 255, 255, 20 ) )

	self.Menu_button = MenuItem.Create( self.Menu_background )
	self.Menu_button:SetDock( GwenPosition.Fill )
	self.Menu_button:SetText( "Продолжить ( ͡° ͜ʖ ͡°)" )
	self.Menu_button:SetTextSize( 15 )
	self.Menu_button:Subscribe( "Press", self, self.Close )
end

function WhatsNew:LocalPlayerInput( args )
	if self.actions[args.input] then
		return false
	end
end

function WhatsNew:Render()
	Game:FireEvent( "gui.hud.hide" )
	Mouse:SetVisible( true )
	Chat:SetEnabled( false )

	Render:FillArea( Vector2.Zero, Render.Size, Color( 10, 10, 10, 200 ) )

	if LocalPlayer:GetValue( "SystemFonts" ) then
		Render:SetFont( AssetLocation.SystemFont, "Impact" )
	end
	Render:DrawText( Vector2( Render.Size.x / 2 - Render:GetTextWidth( self.titletext, Render.Size.x / 40 ) / 2, Render.Size.x / 7 ), self.titletext, Color.White, Render.Size.x / 40 )
	Render:DrawText( Vector2( Render.Size.x / 2 - Render:GetTextWidth( self.text, Render.Size.x / 70 ) / 2, Render.Size.x / 5 ), self.text, Color.White, Render.Size.x / 70 )
	if self.usepause then
		Game:FireEvent( "ply.pause" )
		Render:DrawText( Vector2( 20, (Render.Height - 40) ), "© JCGTeam 2021", Color.White, 15 )
	end
end

function WhatsNew:Menu()
	Network:Send( "Exit" )

	local sound = ClientSound.Create(AssetLocation.Game, {
		bank_id = 35,
		sound_id = 6,
		position = LocalPlayer:GetPosition(),
		angle = Angle()
	})

	sound:SetParameter(0,0.75)
	sound:SetParameter(1,0)
end

function WhatsNew:Close()
	Network:Send( "IsChecked" )
	if self.LocalPlayerInputEvent then
		Events:Unsubscribe( self.LocalPlayerInputEvent )
		self.LocalPlayerInputEvent = nil
	end

	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end

	if self.Menu_background then
		self.Menu_button:Remove()
		self.Menu_button = nil
		self.Menu_background:Remove()
		self.Menu_background = nil
	end

	if self.powersImage then
		self.powersImage = nil
	end

	if self.usepause then
		Game:FireEvent( "ply.unpause" )
	end

	Game:FireEvent( "gui.hud.show" )
	Mouse:SetVisible( false )
	Chat:SetEnabled( true )

	local sound = ClientSound.Create(AssetLocation.Game, {
		bank_id = 35,
		sound_id = 6,
		position = LocalPlayer:GetPosition(),
		angle = Angle()
	})

	sound:SetParameter(0,0.75)
	sound:SetParameter(1,0)
end

whatsnew = WhatsNew()