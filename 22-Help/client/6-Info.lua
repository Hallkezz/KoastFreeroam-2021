class 'HControls'

function HControls:__init()
	Events:Subscribe( "ModulesLoad", self, self.ModulesLoad )
	Events:Subscribe( "EngHelp", self, self.EngHelp )
end

function HControls:EngHelp()
	Events:Fire( "HelpRemoveItem",
		{
			name = "Информация"
		} )
	Events:Fire( "HelpAddItem",
		{
			name = "Information",
			text =
			    "> Main:\n" ..
                "    Group in VK              vk.com/rusjc\n" ..
                "    Group in Steam         steamcommunity.com/groups/rusjc\n" ..
				"    We're in Discord           discord.gg/vzew9mDpYn\n" ..
				"    Telegram Channel        t.me/rusjc\n \n" ..
				"> Donat:\n" ..
				"    – VIP - 2$\n" ..
				"    – Game Money - 2$\n" ..
				"    – Admin - 16$\n" ..
				"     *Payment method: Not available. Please contact the administration for the purchase.\n \n" ..
				"> Our servers:\n" ..
				"    Just Cause 2 Multiplayer Mod:\n" ..
				"     Рашан Koast Freeroam - 46.174.50.65:7785 (You are here)\n" ..
				"      - Group in Steam - steamcommunity.com/groups/rusjc\n" ..
				"     Panau Crisis - 46.174.50.65:7781\n" ..
				"      - Group in VK - vk.com/jcsurv\n \n" ..
				"> Developer:\n" ..
				"     I'm (Hallkezz)\n \n" ..
				"> Also thanks for scripts:\n" ..
				"     Proxwian\n" ..
				"     Neon\n" ..
				"     JasonMRC\n" ..
				"     Lord_Farquaad\n" ..
				"     Dev_34\n" ..
				"     DaAlpha\n" ..
				"     SinisterRectus\n" ..
				"     SK83RJOSH\n" ..
				"     dreadmullet\n" ..
				"     Trix\n" ..
				"     And many other developers..."
		} )
end

function HControls:ModulesLoad()
	Events:Fire( "HelpAddItem",
		{
			name = "Информация",
			text =
			    "> Главное:\n" ..
                "    Группа в VK               vk.com/rusjc\n" ..
                "    Группа в Steam         steamcommunity.com/groups/rusjc\n" ..
				"    Мы в Discord             discord.gg/vzew9mDpYn\n" ..
				"    Телеграм канал         t.me/rusjc\n \n" ..
				"> Донат:\n" ..
				"    - VIP – 99 рублей.\n" ..
				"    - Игровая валюта – 100 рублей = $10.000.\n" ..
				"    - Админка – 999 рублей.\n" ..
				"     *донат в группе в VK!\n \n" ..
				"> Наши сервера:\n" ..
				"    Just Cause 2 Multiplayer Mod:\n" ..
				"     Рашан Koast Freeroam - 46.174.50.65:7785 (Вы тут)\n" ..
				"      - Группа в вк - vk.com/rusjc\n" ..
				"     Panau Crisis - 46.174.50.65:7781\n" ..
				"      - Группа в вк - vk.com/jcsurv\n \n" ..
				"> Разработчик:\n" ..
				"     Я (Hallkezz)\n \n" ..
				"> Заимствованный код:\n" ..
				"     Proxwian\n" ..
				"     Neon\n" ..
				"     JasonMRC\n" ..
				"     Lord_Farquaad\n" ..
				"     Dev_34\n" ..
				"     DaAlpha\n" ..
				"     SinisterRectus\n" ..
				"     SK83RJOSH\n" ..
				"     dreadmullet\n" ..
				"     Trix\n" ..
				"     И много других разработчиков...\n \n" ..
				"> Также спасибо:\n" ..
				"     Delistmar (Художник)\n" ..
				"     Dragonshifter (Исходный код сервера RUSSIAN FREEROAM MAYHEM)"
		} )
end

hcontrols = HControls()