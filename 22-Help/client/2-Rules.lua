class 'HCommands'

function HCommands:__init()
	Events:Subscribe( "ModulesLoad", self, self.ModulesLoad )
	Events:Subscribe( "EngHelp", self, self.EngHelp )
end

function HCommands:EngHelp()
	Events:Fire( "HelpRemoveItem",
		{
			name = "ПРАВИЛА"
		} )
	Events:Fire( "HelpAddItem",
		{
			name = "RULES",
			text =
					"> Players, please, pay attention to NOT-TO-DO list:\n" ..
					"    1. Aggression aside of parents and friends:\n" ..
					"           - Ban for 1 days(If the violation of this rule was detected again, the ban will be for 7 days).\n \n" ..
					"    2. Aggression aside of players and admin:\n" ..
					"           - Punishment matter from admin. (in other ways, the ban will be for 7 days).\n \n" ..
					"    3. Using the admin nicknames:\n" ..
					"           - Ban for 30 minutes. (If the violation of this rule will be detected again, the ban will be for 3 days).\n \n" ..
					"    4. Trying to be like an admin(if you are not):\n" ..
					"           - Can be promoted as a cock, or something like... (If the violation will be detected again, the ban will be for 1 days).\n \n" ..
					"    5. WRITING EVERY GODDAMN MESSAGE WITH THAT CAPS LOCK BUTTON!:\n" ..
					"           - KICK (IF THE VIOLATION OF THIS RULE WILL BE DETECTED AGAIN, THE BAN WILL BE FOR 1 DAY).\n \n" ..
					"    6. Spam every minute or unplesant adds in chat:\n" ..
					"           - Kick (If the violation of this rule will be detected again, the ban will be for 1 day).\n \n" ..
					"    7. Provoking players for rules' violation:\n" ..
					"           - Ban for 2 dayse (If the violation of this rule will be detected again, the ban will be for 7 days).\n \n" ..
					"    8. Using the cheats:\n" ..
					"           - Kick (If the violation of this rule will be detected again, the ban will be for 4 days).\n \n" ..
					"    9. Have a clan name that offends the player/server administration:\n" ..
					"           - Deleting a clan (Money for creating a clan is not refundable).\n \n" ..
					"> Admins' NOT-TO-DO list:\n" ..
					"    1. Don't be aggressive!\n" ..
					"    2. Don't harassment players! (may be exceptions)\n" ..
					"    3. PLEASE, keep order for server!\n" ..
					"    4. PLEASE, answer the players' questions! (if they are not dumb)\n" ..
					"    5. Don't give money for players (admin-panel)!\n \n" ..
					"> To creator:\n" ..
					"    1. *Prohibited to write in English in chat(Hallkezz, PLEASE, LEARN THE GODDAMN ENGLISH!!!)*\n \n" ..
					"Ignorance of the rules of the server does not relieve you of responsibility!"
		} )
end

function HCommands:ModulesLoad()
	Events:Fire( "HelpAddItem",
		{
			name = "ПРАВИЛА",
			text =
					"> Игрокам:\n" ..
					"    1. Оскорбления в общем чате:\n" ..
					"           - Наказание зависит от степени нарушения. (В кранйем случае БАН СРОКОМ В 7 ДНЕЙ).\n \n" ..
					"    2. Оскорбления администрации:\n" ..
					"           - Наказание зависит от админа. (В кранйем случае БАН СРОКОМ В 7 ДНЕЙ).\n \n" ..
					"    3. Использование админских ников:\n" ..
					"           - БАН НА 30 МИНУТ (При ПОВТОРНОМ нарушении БАН СРОКОМ В 3 ДНЯ).\n \n" ..
					"    4. Притворяться админом, но со своим ником:\n" ..
					"           - Могут выдать петуха и тому подобное (При ПОВТОРНОМ нарушении БАН СРОКОМ В 1 ДЕНЬ).\n \n" ..
					"    5. Употребление КАПСА / ЧеРедОВаНиЯ РеГиСтТрА в общем чате 3-х или более раз подряд:\n" ..
					"           - Кик (При ПОВТОРНОМ нарушении БАН СРОКОМ В 1 ДЕНЬ).\n \n" ..
					"    6. Спам каждую минуту или реклама в чате:\n" ..
					"           - Кик (При ПОВТОРНОМ нарушении БАН СРОКОМ В 1 ДЕНЬ).\n \n" ..
					"    7. Использование читерских программ:\n" ..
					"           - Кик (При ПОВТОРНОМ нарушении БАН СРОКОМ В 3 ДНЯ).\n \n" ..
					"    8. Намеренные убийства находясь в мирном режиме или убийства мирных игроков:\n" ..
					"           - Кик (При ПОВТОРНОМ нарушении БАН СРОКОМ В 3 ДНЯ).\n" ..
					"           P.S. Необходимо предъявить видео с нарушением.\n \n" ..
					"    9. Иметь название клана, оскорбляющее игрока/администрацию сервера:\n" ..
					"           - Удаление клана (Деньги за создание клана не возвращается).\n \n" ..
					">  Администраторам запрещено:\n" ..
					"     1. Оскорблять игроков на сервере.\n" ..
					"     2. Использовать админские привилегии для любого негативного взаимодействия с игроками.\n" ..
					"       - Не считается если администратора попросили сделать то или иное действие над игроком.\n" ..
					"       - Не считается если негативное взаимодействие происходит над другим администратором.\n" ..
					"     3. Выдавать деньги другим игрокам (с помощью админ-панели).\n" ..
					"       - Не считается при проведении Гл. Админом или Создателем сервера внутриигровых событий.\n \n" ..
					">  Администратор должен:\n" ..
					"     1. Давать ответы на вопросы, касающиеся сервера.\n" ..
					"     2. Следить за порядком сервера.\n" ..
					"     3. Знать >90% функционала сервера и/или уметь ориентироваться в меню помощи.\n" ..
					"     - Эти обязанности не актуальны до момента пока администратор не включил свой префикс.\n" ..
					"     - Эти обязанности не актуальны для людей, которые купили привилегию за деньги.\n" ..
					"         (у таких людей значок $ на конце префикса)\n \n" ..
					">  Создателю:\n" ..
					"     1. *курлык*\n \n" ..
					"При многочисленных нарушениях бан выдается перманентно (навсегда).\n" ..
					"Забаненный игрок может купить разблокировку вне зависимости от количества нарушений :)\n" ..
					"Незнание правил сервера не освобождает вас от ответственности!"
		} )
end

hcommands = HCommands()