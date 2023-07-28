#include <amxmodx>

#define PLUGIN "rjtbot"
#define VERSION "1.0"
#define AUTHOR "BESTIA"

new bool:rjt_enabled;
new g_totalPlayersRjt = 0;

//new g_MaxPlayers; //total de jugadores en el servidor (debe ser global?)

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	/*
	register_clcmd("say !rjt", "cmdRjt",ADMIN_MAP);
	register_clcmd("say !add","cmdAdd");
	register_clcmd("say !remove", "cmdRemove");
	register_clcmd("say !mesclar", "cmdMesclar", ADMIN_MAP);
	*/
	register_clcmd("say !capitanes","cmdCapitanes",ADMIN_CFG);
	register_clcmd("say !spect", "cmdSpectator", ADMIN_CFG);
	register_clcmd("say !alltalkon", "cmdAlltalkon",ADMIN_CFG);
	register_clcmd("say !alltalkoff", "cmdAlltalkoff",ADMIN_CFG);
	register_clcmd("say !spectchaton", "cmdSpectchaton", ADMIN_CFG);
	register_clcmd("say !spectchatoff", "cmdSpectchatoff", ADMIN_CFG);
	register_clcmd("say !pm","cmdPm", ADMIN_CFG);
	register_clcmd("say !rates","cmdRates");
	register_clcmd("say !timeleft","cmdTimeleft");
}

public cmdPm(id,level)
{
	if(get_user_flags(id) & level)
	{
		new Client[21] 
		get_user_name(id,Client,20);
		server_cmd("tfc_clanbattle_prematch 0");
		server_exec();
		client_print(0,print_chat,"%s desactivo el prematch",Client);
	}
}

public cmdRjt(id)
{
	rjt_enabled = true;
	client_print(id,print_chat,"Las inscripciones están abiertas!");
}

public cmdAdd(id)
{
	//cuando agregas un jugador, guardar la id para luego usarla en el shuffle, hacer un array con ids
	if(rjt_enabled){
		new p_name[33];
		get_user_name(id,p_name,32);
		g_totalPlayersRjt++;
		
		client_print(id,print_chat,"Te has suscrito al rjt");
	}else{
		client_print(id,print_chat,"Las inscripciones aun no están abiertas");
	}
}
public cmdRemove(id)
{
	if(rjt_enabled){
		new p_name[33];
		get_user_name(id,p_name,32);
		g_totalPlayersRjt--;
		client_print(id,print_chat,"Te has removido del rejunte exitosamente");
	}else{
		client_print(id,print_chat,"No estabas participando de una inscripcion de rejunte");
	}
}


public cmdSpectator(id,level)
{
	if(get_user_flags(id) & level){

        
		client_print(0, print_chat, "moviendo jugadores a spectator.. go pick");
		client_cmd(0,"spectate"); //enviarlo a spectator
		/*
  		for (new i = 0; i < num; i++)
  		{
   			id = players[i]
    		engclient_cmd(0 , "jointeam", finalteam )  //unirlos a un equiipo
  		}
		*/

        
		new admname[32]
		get_user_name(id,admname,31)
		client_print(0,print_chat,"[AMXX]: Admin %s has transfered all players to spectator!",admname)
		return PLUGIN_CONTINUE;
    }
	else{
        client_print(id, print_console, "You do not have access to this command.")
        return PLUGIN_CONTINUE
    }
	return PLUGIN_CONTINUE;
	}
public cmdMesclar(id,level)
{
    new Client[21] 
    get_user_name(id,Client,20)
    if(id && get_user_flags(id) & ADMIN_CFG)
    {
        client_print(id,print_chat,"Mezclando los equipos...");
        new players[32], num, i, team_num_as_str[2], num_of_teams
        get_players(players, num, "") // Check teams of all connected players.
        for (i = 0; i < num; i++){
            if(get_user_team(players[i]) != 1 || get_user_team(players[i]) != 2){ //aca obtiene el team
                num_of_teams = max(num_of_teams, get_user_team(players[i])) 
                client_print(id,print_chat,"Obteniendo equipos de los jugadores")
            }
        }
        get_players(players, num, "ch") // skip bots and hltv
        for (i=0;i<num;i++)
        {
            //aca los une a un equipo random
            num_to_str(random_num(1, 3), team_num_as_str, charsmax(team_num_as_str));
            engclient_cmd(players[i], "jointeam", team_num_as_str);
            client_print(players[i],print_chat,"Redistribuyendo los jugadores");
        }
    }
}
public cmdAlltalkon(id,level)
{
	
	if(get_user_flags(id) & level)
	{
		new admname[32]
		get_user_name(id,admname,31);
		server_cmd("sv_alltalk 1");
		server_exec();
		client_print(0,print_chat,"Alltalk activado por %s",admname)
		return PLUGIN_CONTINUE	
	}
	return PLUGIN_CONTINUE;
}
public cmdAlltalkoff(id,level)
{
	if(get_user_flags(id) & level)
	{
		new admname[32]
		get_user_name(id,admname,31);
		server_cmd("sv_alltalk 0")
		server_exec();
		client_print(0,print_chat,"Alltalk desativado por %s",admname)
		return PLUGIN_CONTINUE	
	}
	return PLUGIN_CONTINUE;
}

/*
if( g_totalPlayers = 8 )
{
	
    engclient_cmd(player, "jointeam", equipo )  //unirlos a un equiipo
}
*/

public cmdCapitanes(id,level)
{
	//revisar si el jugador esta en spect y enviar a un equipo, posiblemente también podamos 
	//que todos se vayan spectator antes de realizar lo anterior
	
	cmdSpectator(id,level);
	if(get_user_flags(id) & level)
	{
		client_print(0,print_chat, "Eligiendo capitanes...")
		
		//recorre todos los jugadores online y elige 2 aleatoriamente
		new players[32], num
		
		
		new playerName[32];
		get_players(players, num, "") // Check teams of all connected players.
		
		new numRandom1 = random_num(1,8)//establecer numero random
		

		client_print(0,print_chat,"Numero random 1 es: %i",numRandom1);
		
		for (new i = 0; i < num; ++i){	
			if(numRandom1 == players[i])
			{
				get_user_name(players[i],playerName,31);
				client_print(0,print_chat,"Se ha seleccionado como capitan a %s",playerName);
				client_cmd(players[i],"jointeam 1")//mover al player elegido al equipo azul
			}
		}
		
		get_players(players, num, "") // Check teams of all connected players.

		new numRandom2 = random_num(1,num)
		while(numRandom1 == numRandom2)
		{
			numRandom2 = random_num(1,num)
		}
		
		
		client_print(0,print_chat,"Numero random 2 es: %i",numRandom2);
		
		
		for (new i = 0; i < num; ++i){	
			if(numRandom2 == players[i])
			{
				get_user_name(players[i],playerName,31);
				client_print(0,print_chat,"Se ha seleccionado como capitan a %s",playerName);
				client_cmd(players[i],"jointeam 2")//mover al player elegido al equipo azul
			}
		
		
	}
	}
	
	
	
	return PLUGIN_CONTINUE
}
public cmdSpectchaton(id, level)
{
	if(get_user_flags(id) & level)
	{
		new admname[32]
		get_user_name(id,admname,31);
		server_cmd("tfc_spectchat 1");
		server_exec();
		client_print(0,print_chat,"Spectator chat activado por %s",admname)
		return PLUGIN_CONTINUE	
	}
	return PLUGIN_CONTINUE;
}
public cmdSpectchatoff(id, level)
{
	if(get_user_flags(id) & level)
	{
		new admname[32]
		get_user_name(id,admname,31);
		server_cmd("tfc_spectchat 0");
		server_exec();
		client_print(0,print_chat,"Spectator chat desactivado por %s",admname)
		return PLUGIN_CONTINUE	
	}
	return PLUGIN_CONTINUE;
}
public cmdRates()
{
	server_cmd("say rates 30000 cl_cmdrate fps + 5 cl_updaterate 101");
	server_exec();
	return PLUGIN_HANDLED;
}


public cmdTimeleft(id)
{
	if (get_cvar_float("mp_timelimit"))
	{
		new a = get_timeleft()
		
		client_print(id, print_chat, "%L:  %d:%02d", LANG_PLAYER, "TIME_LEFT", (a / 60), (a % 60))
	}
	else
		client_print(id, print_chat, "%L", LANG_PLAYER, "NO_T_LIMIT")
	
	
	return PLUGIN_CONTINUE;
}

