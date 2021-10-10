class 'Bank'

function Bank:__init()
	self.rows = {}

	Events:Subscribe( "GetOption", self, self.GetOption )
	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "SendMoney", self, self.ShowPlayersMenu )
	Events:Subscribe( "CloseSendMoney", self, self.PListWindowClosed )
	Events:Subscribe( "LocalPlayerMoneyChange", self, self.MoneyChange )

	self.opyt = "Баланс: $"

	self.timer = Timer()
	self.message_size = TextSize.VeryLarge
	self.submessage_size = 25
end

function Bank:GetOption( args )
	self.money = args.actSt
	self.id = args.actStTw
end

function Bank:Lang( args )
	self.opyt = "Money: $"
end

function Bank:ShowPlayersMenu()
	if not self.LocalPlayerInputEvent then
        self.LocalPlayerInputEvent = Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
		Mouse:SetVisible( true )

		self.plist = {}

		self.plist.window = Window.Create()
        self.plist.window:SetSizeRel( Vector2( 0.2, 0.22 ) )
        self.plist.window:SetMinimumSize( Vector2( 370, 240 ) )
        self.plist.window:SetPositionRel( Vector2( 0.8, 0.5 ) - self.plist.window:GetSizeRel()/2 )
		self.plist.window:SetVisible( true )
		self.plist.window:SetTitle( "Отправить деньги" )
		self.plist.window:Subscribe( "WindowClosed", self, self.PListWindowClosed )

		self.plist.moneytosend = TextBoxNumeric.Create( self.plist.window )
		self.plist.moneytosend:SetDock( GwenPosition.Top )
		self.plist.moneytosend:SetMargin( Vector2( 5, 5 ), Vector2( 5, 5 ) )
		self.plist.moneytosend:SetHeight( 20 )

		self.plist.text = Label.Create( self.plist.window )
		self.plist.text:SetDock( GwenPosition.Fill )
		self.plist.text:SetMargin( Vector2( 10, 10 ), Vector2( 10, 10 ) )
		self.plist.text:SetText( "Выберете игрока" )
		self.plist.text:SetTextSize( 20 )
		self.plist.text:SizeToContents()

		self.plist.playerList = SortedList.Create( self.plist.window )
		self.plist.playerList:SetMargin( Vector2.Zero, Vector2( 0, 4 ) )
		self.plist.playerList:SetBackgroundVisible( false )
		self.plist.playerList:AddColumn( "Игрок" )
		self.plist.playerList:SetButtonsVisible( true )
		self.plist.playerList:SetDock( GwenPosition.Fill )

		self.plist.okay = Button.Create( self.plist.window )
		self.plist.okay:SetDock( GwenPosition.Bottom )
		self.plist.okay:SetHeight( 35 )
		self.plist.okay:SetText( "Отправить" )
		self.plist.okay:Subscribe( "Press", self, self.SendToPlayer )

		for player in Client:GetPlayers() do
			self:AddPlayer( player )
		end
	else
		self:PListWindowClosed()
	end
end

function Bank:AddPlayer( player )
	local playerSteamId = tostring(player:GetSteamId().id)
	local playerName = player:GetName()
	local playerColor = player:GetColor()
	local playerId = tostring( player:GetId() )

	local item = self.plist.playerList:AddItem( playerSteamId )

	item:SetCellText( 0, playerName )
	item:SetTextColor( playerColor )
	item:SetName( playerId )

	self.rows[playerSteamId] = item
end

function Bank:SendToPlayer()
	if self.plist.playerList:GetSelectedRow() then
		if LocalPlayer:GetMoney() >= self.plist.moneytosend:GetValue() then
			Network:Send( "SendMoney", { selectedplayer = tonumber( self.plist.playerList:GetSelectedRow():GetName() ), money = self.plist.moneytosend:GetValue() } )
		else
			Events:Fire( "CastCenterText", { text = "У вас нет столько денег!", time = 2, color = Color( 255, 0, 0 ) } )
		end
	else
		Events:Fire( "CastCenterText", { text = "Игрок не выбран!", time = 2, color = Color( 255, 0, 0 ) } )
	end
	self:PListWindowClosed()
end

function Bank:LocalPlayerInput( args )
	if args.input == Action.GuiPause then
		self:PListWindowClosed()
	end

    return false
end

function Bank:PListWindowClosed()
	if self.LocalPlayerInputEvent then
		self.plist.window:Remove()
		self.plist.window = nil
		Mouse:SetVisible( false )
		Events:Unsubscribe( self.LocalPlayerInputEvent )
		self.LocalPlayerInputEvent = nil
	end
end

function Bank:Render()
	if self.message_timer and self.message then
		local alpha = 4

		if self.message_timer:GetSeconds() > 4 and self.message_timer:GetSeconds() < 5 then
			alpha = 4 - (self.message_timer:GetSeconds() - 1)
		elseif self.message_timer:GetSeconds() >= 5 then
			self.message_timer = nil
			self.message = nil
			self.submessage = nil
			if self.RenderEvent then
				Events:Unsubscribe( self.RenderEvent )
				self.RenderEvent = nil
			end
			return
		end

		if LocalPlayer:GetValue( "SystemFonts" ) then
			Render:SetFont( AssetLocation.SystemFont, "Impact" )
		end

		local pos_2d = Vector2( (Render.Size.x / 2) - (Render:GetTextSize( self.message .. " | " .. self.submessage, self.submessage_size ).x / 2), 100 )
		local col = Copy( self.colour )
		local colS = Copy( Color( 25, 25, 25, 150 ) )
		col.a = col.a * alpha
		colS.a = colS.a * alpha
	
		Render:DrawText( pos_2d + Vector2.One, self.message .. " | " .. self.submessage, colS, self.submessage_size )
		Render:DrawText( pos_2d, self.message .. " | " .. self.submessage, col, self.submessage_size )
	end
end

function Bank:MoneyChange( args )
	if Game:GetState() ~= GUIState.Game then return end
	if not self.RenderEvent then
		self.RenderEvent = Events:Subscribe( "Render", self, self.Render )
	end
	local diff = args.new_money - args.old_money

	-- Very unlikely you'll be able to get any money in the first 2 seconds!
	if diff > 0 and self.timer:GetSeconds() > 2 then
		self.message_timer = Timer()
		self.message = "+ $" .. formatNumber( diff )
		self.submessage = self.opyt .. formatNumber( args.new_money )
		self.colour = Color( 251, 184, 41 )
	end

	local diff = args.old_money - args.new_money

	if diff > 0 and self.timer:GetSeconds() > 2 then
		self.message_timer = Timer()
		self.message = "- $" .. formatNumber( diff )
		self.submessage = self.opyt .. formatNumber( args.new_money )
		self.colour = Color.OrangeRed
	end	
end

bank = Bank()