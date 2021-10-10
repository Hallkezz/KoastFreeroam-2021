Loads = {
	"BackgroundImage",
	"BackgroundImageTw",
	"BackgroundImageTh",
	"BackgroundImageFo",
	"BackgroundImageFi",
	"BackgroundImageSi"
}

class 'Load'

function Load:__init()
	self.BackgroundImage = Image.Create( AssetLocation.Resource, Loads[math.random(#Loads)] )
	self.LoadingCircle_Outer = Image.Create( AssetLocation.Resource, "LoadingCircle_Outer" )

	self.name = "СОВЕТ: Нажмите [ B ], чтобы открыть меню сервера."
	self.wtitle = "ОШИБКА :С"
	self.wtext = "Возможно вы застряли на экране загрузки. \nЖелаете покинуть сервер?"
	self.wbutton = "Покинуть сервер"

	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "ModuleLoad", self, self.ModuleLoad )
	Events:Subscribe( "GameLoad", self, self.GameLoad )
	Events:Subscribe( "LocalPlayerDeath", self, self.LocalPlayerDeath )
	self.PostRender = Events:Subscribe( "PostRender", self, self.PostRender )

	IsJoining = false

	self.border_width = Vector2( Render.Width, 25 )
end

function Load:Lang( args )
	self.name = "TIP: Press [ B ] to open Server Menu."
	self.wtitle = "ERROR :С"
	self.wtext = "You maybe stuck on the loading screen. \nWant to leave the server?"
	self.wbutton = "Leave Server"
end

function Load:ModuleLoad()
	if Game:GetState() ~= GUIState.Loading then
		IsJoining = false
	else
		IsJoining = true
		FadeInTimer = Timer()
	end
end

function Load:GameLoad()
	FadeInTimer = nil
end

function Load:LocalPlayerDeath()
	self.BackgroundImage = Image.Create( AssetLocation.Resource, Loads[math.random(#Loads)] )
	FadeInTimer = Timer()
end

function Load:PostRender()
	if Game:GetState() == GUIState.Loading then
		local TxtSizePos = Render.Size.x / 0.55 / Render:GetTextWidth( "BTextResoliton" )
		local TxtSize = Render:GetTextSize( self.name, TxtSizePos )
		local CircleSize = Vector2( 70, 70 )
		local TransformOuter = Transform2()
		local TxtPos = Vector2( ( Render.Size.x/2 ) - ( TxtSize.x/2 ), Render.Size.y / 1.100 )
		local Rotation = self.GetRotation()
		local Pos = Vector2( 40, Render.Size.y / 1.075 )
		local PosTw = Vector2( 40.5, Render.Size.y / 1.074 )
		local PosTh = Vector2( (Render.Width - 60), 60 )

		self.BackgroundImage:SetPosition( Vector2.Zero )
		self.BackgroundImage:SetSize( Vector2( Render.Width, Render.Height ) )
		self.BackgroundImage:Draw()

		Render:FillArea( TxtPos-self.border_width, Vector2( Render.Width, 100 ) + self.border_width*2, Color( 0, 0, 0, 150 ) )

		if LocalPlayer:GetValue( "SystemFonts" ) then
			Render:SetFont( AssetLocation.SystemFont, "Impact" )
		end
		Render:DrawText( PosTw, self.name, Color( 0, 0, 0 ), TxtSizePos )
		Render:DrawText( Pos, self.name, Color.White, TxtSizePos )

		if FadeInTimer then
			TransformOuter:Translate( PosTh )
			TransformOuter:Rotate( math.pi * Rotation )

			Render:SetTransform( TransformOuter )
			self.LoadingCircle_Outer:Draw( -(CircleSize / 2), CircleSize, Vector2.Zero, Vector2.One )
			Render:ResetTransform()

			if FadeInTimer:GetMinutes() >= 1 then
				Events:Unsubscribe( self.PostRender )
				self:ExitWindow()
			end
		end
	end
end

function Load:ExitWindow()
	FadeInTimer = nil
	Mouse:SetVisible( true )
	self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.2, 0.2 ) )
	self.window:SetMinimumSize( Vector2( 500, 200 ) )
	self.window:SetPositionRel( Vector2( 0.7, 0.5 ) - self.window:GetSizeRel()/2 )
	self.window:SetVisible( true )
	self.window:SetTitle( self.wtitle )
	self.window:Subscribe( "WindowClosed", self, self.WindowClosed )

	self.errorText = Label.Create( self.window )
	self.errorText:SetPosition( Vector2( 20, 30 ) )
	self.errorText:SetSize( Vector2( 450, 100 ) )
	self.errorText:SetText( self.wtext )
	self.errorText:SetTextSize( 20 )

	self.leaveButton = Button.Create( self.window )
	self.leaveButton:SetSize( Vector2( 100, 40 ) )
	self.leaveButton:SetDock( GwenPosition.Bottom )
	self.leaveButton:SetText( self.wbutton )
	self.leaveButton:Subscribe( "Press", self, self.Exit )
end

function Load:WindowClosed()
	self.window:Remove()
	Mouse:SetVisible( false )
end

function Load:Exit()
	self.window:Remove()
	Chat:SetEnabled( false )
	Network:Send( "KickPlayer" )
end

function Load:GetRotation()
	if FadeInTimer then
		local RotationValue = FadeInTimer:GetSeconds()* 3
		return RotationValue
	end
end

Load = Load()