class 'News'

function News:__init()
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

	self.HelpActive = false

	self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.57, 0.86 ) )
	self.window:SetPositionRel( Vector2( 0.69, 0.5 ) - self.window:GetSizeRel()/2 )
	self.window:SetTitle( "ⓘ Новости" )
	self.window:SetVisible( self.HelpActive )
	self.window:Subscribe( "WindowClosed", self, self.WindowClosed )

	self.tab_control = TabControl.Create( self.window )
	self.tab_control:SetDock( GwenPosition.Fill )
	self.tab_control:SetTabStripPosition( GwenPosition.Top )

	self.tabs = {}

	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "OpenNewsMenu", self, self.OpenNewsMenu )
	Events:Subscribe( "CloseNewsMenu", self, self.CloseNewsMenu )
	Events:Subscribe( "LocalPlayerInput", self,	self.LocalHelpInput )
	Events:Subscribe( "NewsAddItem", self, self.AddItem )
	Events:Subscribe( "NewsRemoveItem", self, self.RemoveItem )
end

function News:Lang()
	self.window:SetTitle( "ⓘ News" )
end

function News:GetActive()
	return self.HelpActive
end

function News:SetActive( state )
	self.HelpActive = state
	self.window:SetVisible( self.HelpActive )
	Mouse:SetVisible( self.HelpActive )
end

function News:OpenNewsMenu()
	if self.HelpActive then
		ClientEffect.Create(AssetLocation.Game, {
			effect_id = 383,
	
			position = Camera:GetPosition(),
			angle = Angle()
		})
	else
		ClientEffect.Play(AssetLocation.Game, {
			effect_id = 382,

			position = Camera:GetPosition(),
			angle = Angle()
		})
	end

	self:SetActive( not self:GetActive() )
end

function News:CloseNewsMenu()
	if Game:GetState() ~= GUIState.Game then return end
	if self:GetActive() then
		self:SetActive( false )
	end
end

function News:LocalHelpInput( args )
	if self:GetActive() and Game:GetState() == GUIState.Game then
		if args.input == Action.GuiPause then
			self:SetActive( false )
		end
		if self.actions[args.input] then
			return false
		end
	end
end

function News:WindowClosed( args )
	self:SetActive( false )
	ClientEffect.Create(AssetLocation.Game, {
		effect_id = 383,

		position = Camera:GetPosition(),
		angle = Angle()
	})
end

function News:AddItem( args )
	if label ~= nil then
		self:RemoveItem( args )
	end
	local page = self.window

	local scroll_control = ScrollControl.Create( page )
	scroll_control:SetMargin( Vector2( 10, 15 ), Vector2( 10, 15 ) )
	scroll_control:SetScrollable( false, true )
	scroll_control:SetDock( GwenPosition.Fill )

	label = Label.Create( scroll_control )

	label:SetPadding( Vector2.Zero, Vector2( 14, 0 ) )
	label:SetText( args.text )
	label:SetTextSize( 15 )
	label:SizeToContents()
	label:SetTextColor( Color.LightSkyBlue )
	label:SetWrap( true )

	label:Subscribe( "Render", function(label)
		label:SetWidth( label:GetParent():GetWidth() )
	end )
end

function News:RemoveItem( args )
	if label == nil then return end
	label:Remove()
	label = nil
end

news = News()