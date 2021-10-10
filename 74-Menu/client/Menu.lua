class 'Menu'

function Menu:__init()
	self.rusflag = Image.Create( AssetLocation.Resource, "RusFlag" )
	self.engflag = Image.Create( AssetLocation.Resource, "EngFlag" )

	if LocalPlayer:GetValue( "Tag" ) == "Creator" then
		self.status = "  [Пошлый Создатель]"
	elseif LocalPlayer:GetValue( "Tag" ) == "GlAdmin" then
		self.status = "  [Гл. Админ]"
	elseif LocalPlayer:GetValue( "Tag" ) == "Admin" then
		self.status = "  [Админ]"
	elseif LocalPlayer:GetValue( "Tag" ) == "AdminD" then
		self.status = "  [Админ $]"
	elseif LocalPlayer:GetValue( "Tag" ) == "ModerD" then
		self.status = "  [Модератор $]"
	elseif LocalPlayer:GetValue( "Tag" ) == "VIP" then
		self.status = "  [VIP]"
	elseif LocalPlayer:GetValue( "Tag" ) == "YouTuber" then
		self.status = "  [YouTube Деятель]"
	elseif LocalPlayer:GetValue( "NT_TagName" ) then
		self.status = "  [" .. LocalPlayer:GetValue( "NT_TagName" ) .. "]"
	end

	self.upgrade = true
	self.hider = true

	self.sbar = Color.Gold

	self.active = true

	self.tofreeroamtext = "Добро пожаловать в свободный режим!"
	self.tName = "Выберите язык / Language Select"

	self.pos = Vector2( Render.Size.x/2 / Render:GetTextHeight( self.tName, 30 ), 50 ) -- Center of screen.

	self.EventRender = Events:Subscribe( "Render", self, self.Render )

	self.rus_image = ImagePanel.Create()
	self.rus_image:SetVisible( false )
	self.rus_image:SetImage( self.rusflag )
	self.rus_image:SetHeight( Render.Size.x / 9 )
	self.rus_image:SetWidth( Render.Size.x / 5.5 )
	self.rus_image:SetPosition( Vector2( Render.Size.x / 3.5, (Render.Height - Render.Size.x / 4 ) ) )

	self.rus_button = MenuItem.Create()
	if LocalPlayer:GetValue( "SystemFonts" ) then
		self.rus_button:SetFont( AssetLocation.SystemFont, "Impact" )
	end
	self.rus_button:SetHeight( Render.Size.x / 7 )
	self.rus_button:SetWidth( Render.Size.x / 5.5 )
	self.rus_button:SetPosition( self.rus_image:GetPosition() )
	self.rus_button:SetText( "Русский" )
	self.rus_button:SetTextPadding( Vector2( 0, Render.Size.x / 9 ), Vector2.Zero )
	self.rus_button:SetTextSize( Render.Size.x / 0.65 / Render:GetTextWidth( "BTextResoliton" ) )
	if LocalPlayer:GetMoney() <= 0.5 then
		self.rus_button:Subscribe( "Press", self, self.Welcome )
	else
		self.rus_button:Subscribe( "Press", self, self.Rus )
	end

	self.eng_image = ImagePanel.Create()
	self.eng_image:SetVisible( false )
	self.eng_image:SetImage( self.engflag )
	self.eng_image:SetHeight( Render.Size.x / 9 )
	self.eng_image:SetWidth( Render.Size.x / 5.5 )
	self.eng_image:SetPosition( Vector2( self.rus_button:GetPosition().x + Render.Size.x / 4.8, self.rus_button:GetPosition().y ) )

	self.eng_button = MenuItem.Create()
	if LocalPlayer:GetValue( "SystemFonts" ) then
		self.eng_button:SetFont( AssetLocation.SystemFont, "Impact" )
	end
	self.eng_button:SetHeight( Render.Size.x / 7 )
	self.eng_button:SetWidth( Render.Size.x / 5.5 )
	self.eng_button:SetPosition( self.eng_image:GetPosition() )
	self.eng_button:SetText( "English" )
	self.eng_button:SetToolTip( "Not full. Recommended playing on Alpha's Salt Factory" )
	self.eng_button:SetTextPadding( Vector2( 0, Render.Size.x / 9 ), Vector2.Zero )
	self.eng_button:SetTextSize( Render.Size.x / 0.65 / Render:GetTextWidth( "BTextResoliton" ) )
	self.eng_button:Subscribe( "Press", self, self.Eng )

	Console:Subscribe( "misload", self, self.Mission )

	Events:Subscribe( "LocalPlayerWorldChange", self, self.LocalPlayerWorldChange )
	Events:Subscribe( "ModuleLoad", self, self.ModuleLoad )
	Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	Events:Subscribe( "ModuleUnload", self, self.ModuleUnload )
end

function Menu:Mission( args )
	if LocalPlayer:GetWorld() ~= DefaultWorld then return end
	if tonumber(args.text) == 1 then
		print( "Start msy.km01.completed" )
		print( "Please wait..." )
		Game:FireEvent( "msy.km01.completed" )
	elseif tonumber(args.text) == 6 then
		print( "Start msy.km06.completed" )
		print( "Please wait..." )
		Game:FireEvent( "msy.km06.completed" )
	end
end

function Menu:LocalPlayerWorldChange( args )
	self:Close()
end

function Menu:ModuleLoad()
	Game:FireEvent( "ply.pause" )
	Mouse:SetVisible( true )
	Chat:SetEnabled( false )

	local sound = ClientSound.Create(AssetLocation.Game, {
				bank_id = 13,
				sound_id = 1,
				position = LocalPlayer:GetPosition(),
				angle = Angle()
	})

	sound:SetParameter(0,1)
end

function Menu:LocalPlayerInput( args )
	if self.active then
		return false
	end
end

function Menu:GetActive()
	return self.active
end

function Menu:SetActive( active )
	if self.active ~= active then
		if not active then
			if self.EventRender then
				Events:Unsubscribe( self.EventRender )
				self.EventRender = nil
			end
			self.CleanUp()
			Game:FireEvent( "gui.hud.show" )
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
		self.active = active
		Mouse:SetVisible( self.active )
    end
end

function Menu:Render()
	local pos7 = Vector2( 60, (Render.Height - 40) )

	if self.active then
		Game:FireEvent( "gui.hud.hide" )
		Render:FillArea( Vector2.Zero, Render.Size, Color( 10, 10, 10, 200 ) )

		if AmbSound then
			AmbSound:SetParameter(0,Game:GetSetting(GameSetting.MusicVolume)/100)
		end
	end

	if self.hider then
		if Game:GetState() ~= GUIState.Loading then
			self.rus_image:SetVisible( true )
			self.rus_button:SetVisible( true )
			self.eng_image:SetVisible( true )
			self.eng_button:SetVisible( true )
			if LocalPlayer:GetValue( "SystemFonts" ) then
				self.rus_button:SetFont( AssetLocation.SystemFont, "Impact" )
				self.eng_button:SetFont( AssetLocation.SystemFont, "Impact" )
			end
		else
			self.rus_image:SetVisible( false )
			self.rus_button:SetVisible( false )
			self.eng_image:SetVisible( false )
			self.eng_button:SetVisible( false )
		end
	end

	if self.active then
		local version_txt = "KMod Version: " .. LocalPlayer:GetValue( "KoastBuild" )
		if self.upgrade then
			Game:FireEvent( "gui.minimap.hide" )
		end
		if LocalPlayer:GetValue( "KoastBuild" ) then
			Render:DrawText( Vector2( (Render.Width - Render:GetTextWidth( version_txt, 18 ) ), (Render.Height - 40) ), version_txt, Color( 255, 255, 255, 100 ), 15 )
		end
		if LocalPlayer:GetValue( "SystemFonts" ) then
			Render:SetFont( AssetLocation.SystemFont, "Impact" )
		end
		Render:DrawText( self.pos, self.tName, Color.White, 30 )
		Render:DrawText( pos7, LocalPlayer:GetName(), Color.White, 17 )
		if self.status then
			Render:DrawText( pos7 + Vector2( Render:GetTextWidth( LocalPlayer:GetName(), 17 ), 0 ), self.status, Color.DarkGray, 17 )
		end
		LocalPlayer:GetAvatar(1):Draw( Vector2( 20, (Render.Height - 50) ), Vector2( 30, 30 ), Vector2.Zero, Vector2.One )
	end
end

function Menu:Close()
	self:SetActive( false )
end

function Menu:Freeroam()
	self:Close()
	Game:FireEvent( "ply.unpause" )
	if LocalPlayer:GetValue( "Passive" ) then
		Game:FireEvent( "ply.invulnerable" )
	end
	Network:Send( "SetFreeroam" )
	Events:Fire( "CastCenterText", { text = self.tofreeroamtext, time = 2, color = Color( 255, 255, 255 ) } )
end

function Menu:CleanUp()
	if AmbSound then
		AmbSound:Remove()
		AmbSound = nil
	end
end

function Menu:ModuleUnload()
	self:CleanUp()
end

function Menu:Welcome()
    Network:Send( "SetRus" )
	WelcomeScreen:Open()
	self.hider = false
	self:SetActive( false )
	self.rus_image:Remove()
	self.rus_button:Remove()
	self.eng_image:Remove()
	self.eng_button:Remove()

	local sound = ClientSound.Create(AssetLocation.Game, {
				bank_id = 18,
				sound_id = 0,
				position = LocalPlayer:GetPosition(),
				angle = Angle()
	})

	sound:SetParameter(0,1)
end

function Menu:Selected()
	Network:Send( "JoinMessage" )
	self.hider = false
	self.rus_image:Remove()
	self.rus_button:Remove()
	self.eng_image:Remove()
	self.eng_button:Remove()

	self:Freeroam()
	local sound = ClientSound.Create(AssetLocation.Game, {
				bank_id = 18,
				sound_id = 1,
				position = LocalPlayer:GetPosition(),
				angle = Angle()
	})

	sound:SetParameter(0,1)
end

function Menu:Rus()
	Network:Send( "SetRus" )
	--if not LocalPlayer:GetValue( "Warned" ) then
	--	Events:Fire( "OpenWhatsNew", { titletext = "СКИДКА НА VIP В ТЕЧЕНИЕ НЕДЕЛИ!", text = "Сейчас действует скидка 50% на VIP!\nКупить - vk.com/market-75317987\nГруппа в VK - vk.com/rusjc", usepause = true } )
	--end
	self:Selected()
end

function Menu:Eng()
	Events:Fire( "SetEng" )
	Network:Send( "SetEng" )

	self.tofreeroamtext = "Welcome to freeroam mode!"

	Events:Fire( "EngHelp" )
	Events:Fire( "Lang" )

	self:Selected()
end

menu = Menu()