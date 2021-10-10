class 'HControls'

function HControls:__init()
	Network:Subscribe( "GetENGNews", self, self.GetENGNews )
	Network:Subscribe( "GetRUNews", self, self.GetRUNews )
end

function HControls:GetENGNews( args, sender )
	local getnewsfile = io.open("server/newsENG.txt", "r")
	if getnewsfile then
		s = getnewsfile:read("*a")

		if s then
			Network:Send( sender, "LoadNews", { ntext = s } )
		end
		getnewsfile:close()
	end
end

function HControls:GetRUNews( args, sender )
	local getnewsfile = io.open("server/newsRU.txt", "r")
	if getnewsfile then
		s = getnewsfile:read("*a")

		if s then
			Network:Send( sender, "LoadNews", { ntext = s } )
		end
		getnewsfile:close()
	end
end

hcontrols = HControls()