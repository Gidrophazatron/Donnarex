
/client/verb/who_advanced()
	set name = "Advanced Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights))
		for(var/client/C in GLOB.clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.stealthy_)
				entry += " <i>(as [C.holder.stealthy_])</i>"
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isghost(C.mob))
						var/mob/observer/ghost/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"

			var/age
			if(isnum(C.player_age))
				age = C.player_age
			else
				age = 0

			if(age <= 1)
				age = "<font color='#ff0000'><b>[age]</b></font>"
			else if(age < 10)
				age = "<font color='#ff8c00'><b>[age]</b></font>"

			entry += " - [age]"

			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"

			if(C.is_afk())
				entry += " (AFK - [C.inactivity2text()])"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in GLOB.clients)
			var/entry = "\t"
			if(C.holder && C.holder.stealthy_)
				entry += "[C.holder.stealthy_]"
			else
				entry += "[C.key]"
			var/mob/observer/ghost/O = C.mob
			if(isghost(C.mob))
				entry += " - <font color='gray'>Observing</font>"
			else if(istype(O,/mob/new_player))
				entry += " - <font color='blue'>In Lobby</font>"
			else
				entry += " - <font color='green'>Playing</font>"
			Lines += entry

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	to_chat(src, msg)