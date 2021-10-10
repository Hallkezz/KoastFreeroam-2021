class 'HControls'

function HControls:__init()
	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "ModulesLoad", self, self.ModulesLoad )
	Events:Subscribe( "ModuleUnload", self, self.ModuleUnload )

	Network:Subscribe( "LoadNews", self, self.LoadNews )
end

function HControls:Lang( args )
	Network:Send( "GetENGNews" )
end

function HControls:ModulesLoad( args )
	if LocalPlayer:GetValue( "Lang" ) and LocalPlayer:GetValue( "Lang" ) == "ENG" then
		self:Lang()
	else
		Network:Send( "GetRUNews" )
	end
end

function HControls:LoadNews( args )
	Events:Fire( "NewsAddItem",
	{
		name = "Новости",
		text = args.ntext
	} )
end

function HControls:ModuleUnload()
    Events:Fire( "NewsRemoveItem" )
end

hcontrols = HControls()