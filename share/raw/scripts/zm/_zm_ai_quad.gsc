#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;

#insert scripts\shared\ai\systems\animation_state_machine.gsh;
#insert scripts\shared\ai\systems\behavior.gsh;
#insert scripts\shared\ai\systems\behavior_tree.gsh;
#insert scripts\shared\ai\systems\blackboard.gsh;
#insert scripts\shared\archetype_shared\archetype_shared.gsh;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#insert scripts\shared\aat_zm.gsh;
#insert scripts\shared\shared.gsh;

#precache( "fx", "dlc5/zmhd/fx_zombie_quad_gas_nova6" );
#precache( "fx", "dlc5/zmhd/fx_zombie_quad_trail" );

#namespace zm_ai_quad;

REGISTER_SYSTEM( "zm_ai_quad", &__init__, undefined )

function __init__()
{
	init_quad_zombie_fx();

	if( !isdefined( level.ai_quad_register_overlay_override ) || level.ai_quad_register_overlay_override )
	{
		register_overlay();
	}

	// NOTETRACKS
	ASM_REGISTER_NOTETRACK_HANDLER( "quad_melee", &quadNotetrackMeleeFire );

	// ACTIONS
	BT_REGISTER_API( "quadDeathAction", &quadDeathAction );

	// AAT IMMUNITIES
	level thread aat::register_immunity( ZM_AAT_DEAD_WIRE_NAME, ARCHETYPE_ZOMBIE_QUAD, true, true, true );
	level thread aat::register_immunity( ZM_AAT_TURNED_NAME, ARCHETYPE_ZOMBIE_QUAD, true, true, true );
}

function quadNotetrackMeleeFire( entity )
{
	entity Melee();
	/# Record3DText( "melee", self.origin, (1,0,0), "Script", entity ); #/
}

function quadDeathAction( entity )
{
	if ( isdefined( entity.fx_quad_trail ) )
	{
		entity.fx_quad_trail unlink();
		entity.fx_quad_trail delete();
	}

	if ( entity.can_explode && !IS_TRUE( entity.guts_explosion ) )
	{
		entity thread quad_gas_explo_death();
	}

	entity StartRagdoll();
}

function activate_quad_spawners()
{
	level.quad_spawners = GetEntArray( "quad_zombie_spawner", "script_noteworthy" );
	array::thread_all( level.quad_spawners,&spawner::add_spawn_function, &zm_ai_quad::quad_prespawn );
	zm::register_custom_ai_spawn_check( "quads", &quad_spawn_check, &get_quad_spawners );
}

function register_overlay()
{
	if ( !IsDefined( level.vsmgr_prio_overlay_zm_ai_quad_blur ) )
	{
		level.vsmgr_prio_overlay_zm_ai_quad_blur = 50;
	}	
	visionset_mgr::register_info( "overlay", "zm_ai_quad_blur", VERSION_SHIP, level.vsmgr_prio_overlay_zm_ai_quad_blur, 1, true );	
}

function quad_spawn_check()
{
	return ( isdefined( level.zm_loc_types[ "quad_location" ] ) && level.zm_loc_types[ "quad_location" ].size > 0 );
}

function get_quad_spawners()
{
	return level.quad_spawners;
}

function quad_prespawn()
{
	self.animname = "quad_zombie";
	
	self.no_gib = true;
	
	self.no_eye_glow = true;

	self.no_widows_wine = true;

	self.canBeTargetedByTurnedZombies = true;

	self.custom_location =&quad_location;	// needs to be set before the regular zombie init is called

	self zm_spawner::zombie_spawn_init( true );

	self.zombie_can_sidestep = false;
	
	self.maxhealth = int( self.maxhealth * 0.75 );
	self.health = self.maxhealth;

	self.freezegun_damage = 0;

	self.meleeDamage = 45;
	
	self playsound( "zmb_quad_spawn" );
	
	//C. Ayers: This is the TEMP version of the Quad Gas Explosion Mechanic
	self.death_explo_radius_zomb        = 96;      //Radius around the Quad the explosion will affect Zombies
    self.death_explo_radius_plr         = 96;      //Radius around the Quad the explosion will affect Players
    self.death_explo_damage_zomb        = 1.05;     //Damage done to Zombies with explosion, percentage of maxhealth
    self.death_gas_radius               = 125;      //Radius around the Quad the gas will affect Players and Zombies
    self.death_gas_time                 = 7;        //Length of time Gas Cloud lasts on a specific quad

	if ( isdefined( level.quad_explode ) && level.quad_explode == true )
	{
		self.deathfunction =&quad_post_death;
		self.actor_killed_override =&quad_killed_override;
	}

	self set_default_attack_properties();

	//self.thundergun_disintegrate_func =&quad_thundergun_disintegrate;
	self.thundergun_knockdown_func = &quad_thundergun_knockdown;

	//self.custom_damage_func =&quad_damage_func;

	self.pre_teleport_func =&quad_pre_teleport;
	self.post_teleport_func =&quad_post_teleport;

	self.can_explode = false;
	self.exploded = false;

	self thread quad_trail();

	self AllowPitchAngle(1);

	// jump over quads
	self setPhysParams( 15, 0, 24 );
	
	if ( isdefined( level.quad_prespawn ) )
	{
		self thread [[ level.quad_prespawn ]]();
	}
	
}

function init_quad_zombie_fx()
{
	level._effect[ "quad_explo_gas" ]		        = "dlc5/zmhd/fx_zombie_quad_gas_nova6";
	level._effect[ "quad_trail" ]					= "dlc5/zmhd/fx_zombie_quad_trail";
}

function quad_location()
{
	self endon("death");

	if ( level.zm_loc_types[ "quad_location" ].size <= 0 )
	{
		//It is possible with proper timing that no quad zones will be active after getting spawned in.
		//In this rare case, we need to fail out properly and kill the quad
		/#println( "Warning: No quad spawn locations found" + "\n" );#/
		self DoDamage( self.health * 2, self.origin );
		return;
	}

	spot = array::random( level.zm_loc_types[ "quad_location" ] );

	// give target from spawn location to spawner to path
	if(isdefined(spot.target))
	{
		self.target = spot.target;
	}

	if(IsDefined(spot.zone_name))
	{
		self.zone_name = spot.zone_name;
	}	

	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);
	
	if( !isdefined( spot.angles ) )
	{
		spot.angles = (0, 0, 0);
	}
			
	self Ghost();
	self.anchor moveto(spot.origin, .05);
	self.anchor waittill("movedone");
			
	// face goal
	target_org = zombie_utility::get_desired_origin();
	if (isdefined(target_org))
	{
		anim_ang = VectorToAngles(target_org - self.origin);
		self.anchor RotateTo((0, anim_ang[1], 0), .05);
		self.anchor waittill("rotatedone");
	}
	if(isdefined(level.zombie_spawn_fx))
	{
		playfx(level.zombie_spawn_fx,spot.origin);
	}
	self unlink();
	if(isdefined(self.anchor))
	{
		self.anchor delete();
	}
	self Show();
	
	self notify("risen", spot.script_string );
}

function quad_vox()
{
	self endon( "death" );
	
	wait( 5 );
	
	quad_wait = 5;
	
	while(1)
	{
		players = getplayers();
		
		for(i=0;i<players.size;i++)
		{
			if(DistanceSquared(self.origin, players[i].origin) > 1200 * 1200)
			{
				self playsound( "zmb_quad_amb" );	
				quad_wait = 7;		
			}
			else if(DistanceSquared(self.origin, players[i].origin) > 200 * 200)
			{
				self playsound( "zmb_quad_vox" );	
				quad_wait = 5;		
			}
			else if(DistanceSquared(self.origin, players[i].origin) < 150 * 150)
			{
				wait(.05);
			}
		}
		wait randomfloatrange( 1, quad_wait );		
	}
}

function set_default_attack_properties()
{
	//self.pathEnemyFightDist = 64;
	//self.meleeAttackDist = 64;
	self.goalradius = 16;

	self.maxsightdistsqrd = 128 * 128;
	self.can_leap = false;
}

function quad_thundergun_knockdown( player, gib )
{
	self endon( "death" );

	damage = int( self.maxhealth * 0.5 );
	self DoDamage( damage, player.origin, player );
}

function quad_gas_explo_death()
{   
    death_vars = [];
    death_vars["explo_radius_zomb"]     = self.death_explo_radius_zomb;
    death_vars["explo_radius_plr"]      = self.death_explo_radius_plr;
    death_vars["explo_damage_zomb"]     = self.death_explo_damage_zomb;
    death_vars["gas_radius"]            = self.death_gas_radius;
    death_vars["gas_time"]              = self.death_gas_time;
	
	self thread quad_death_explo( self.origin, death_vars );
	level thread quad_gas_area_of_effect( self.origin, death_vars );
	//self Delete();

}

function quad_death_explo( origin, death_vars )
{
    playsoundatposition( "zmb_quad_explo", origin );
    //PlayFx( level._effect["dog_gib"], origin );
    
    players = GetPlayers();
    zombies = GetAiTeamArray( level.zombie_team );

	/*
    for(i = 0; i < zombies.size; i++)
    {
        if( Distance( origin, zombies[i].origin ) <= death_vars["explo_radius_zomb"] )
        {
            if( zombies[i].animname != "quad_zombie" )
            {
                zombies[i] DoDamage( zombies[i].maxhealth * death_vars["explo_damage_zomb"], origin );
                
                if( zombies[i].health <= 0 )
                {
                    zombies[i] StartRagdoll();
                    zombies[i] LaunchRagdoll( zombies[i].origin - origin );
                }
            }
        }
    }
	*/

    for(i = 0; i < players.size; i++)
    {
        if( Distance( origin, players[i].origin ) <= death_vars["explo_radius_plr"] )
        {
			is_immune = false;
			if ( isdefined( level.quad_gas_immune_func ) )
			{
				is_immune = players[i] thread [[ level.quad_gas_immune_func ]]();
			}

			if ( !is_immune )
			{
				players[i] ShellShock( "explosion", 2.5 );
			}
        }
    }

	self.exploded = true;
	self RadiusDamage( origin, death_vars["explo_radius_zomb"], level.zombie_health, level.zombie_health, self, "MOD_EXPLOSIVE" ); 


    //PhysicsExplosionSphere( origin, death_vars["explo_radius_zomb"], 175, 2 );
}

function quad_damage_func( player )
{
	if ( self.exploded )
	{
		//player ShellShock( "explosion", 2.5 );
		return 0;
	}

	return self.meleeDamage;
}

function quad_gas_area_of_effect( origin, death_vars )
{
		effectArea = spawn( "trigger_radius", origin, 0, death_vars["gas_radius"], 100 );
		//soundent = Spawn( "script_origin", origin );
		
		//soundent PlayLoopSound( "wpn_gas_hiss_lp", 1 );
		PlayFX( level._effect[ "quad_explo_gas" ], origin );
		
		gas_time = 0;
    
		while( gas_time <= death_vars["gas_time"] )
		{
			players = get_players();
//			zombies = GetAIArray( "axis" );
			
			for(i = 0; i < players.size; i++)
			{
				is_immune = false;
				if ( isdefined( level.quad_gas_immune_func ) )
				{
					is_immune = players[i] thread [[ level.quad_gas_immune_func ]]();
				}

				if( players[i] IsTouching( effectArea ) && !is_immune )
				{
					//players[i] ShellShock( "flashbang", 1.5 );
					visionset_mgr::activate( "overlay", "zm_ai_quad_blur", players[i] );
				}
				else
				{
					visionset_mgr::deactivate( "overlay", "zm_ai_quad_blur", players[i] );
				}
			}
			
			wait(1);
			gas_time = gas_time + 1;
		}

		players = get_players();
		for ( i = 0; i < players.size; i++ )
		{
			visionset_mgr::deactivate( "overlay", "zm_ai_quad_blur", players[i] );
		}
		
		//soundent StopLoopSound( 1 );
		effectArea Delete();
		//wait(1);
		//soundent Delete();
}

function quad_trail()
{
	self endon( "death" );

	//Add in the smoke effect from the dogs
	self.fx_quad_trail = Spawn( "script_model", self GetTagOrigin( "tag_origin" ) );
	self.fx_quad_trail.angles = self GetTagAngles( "tag_origin" );
	self.fx_quad_trail SetModel( "tag_origin" );
	self.fx_quad_trail LinkTo( self, "tag_origin" );
	zm_net::network_safe_play_fx_on_tag( "quad_fx", 2, level._effect[ "quad_trail" ], self.fx_quad_trail, "tag_origin" );
}

function quad_post_death( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime )
{
	self zm_spawner::zombie_death_animscript();
	return false;
}

function quad_killed_override( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime )
{
	if ( sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET" )
	{
		self.can_explode = true;
	}
	else
	{
		self.can_explode = false;

		if ( isdefined( self.fx_quad_trail ) )
		{
			self.fx_quad_trail unlink();
			self.fx_quad_trail delete();
		}
	}
	
	if(isDefined(level._override_quad_explosion))
	{
		[[level._override_quad_explosion]](self);
	}
	
}

function quad_pre_teleport()
{
	if ( isDefined( self.fx_quad_trail ) )
	{
		self.fx_quad_trail unlink();
		self.fx_quad_trail delete();
		wait( .1 );
	}
}

function quad_post_teleport()
{
	if ( isDefined( self.fx_quad_trail ) )
	{
		self.fx_quad_trail unlink();
		self.fx_quad_trail delete();
	}

	if ( self.health > 0 )
	{
		self.fx_quad_trail = Spawn( "script_model", self GetTagOrigin( "tag_origin" ) );
		self.fx_quad_trail.angles = self GetTagAngles( "tag_origin" );
		self.fx_quad_trail SetModel( "tag_origin" );
		self.fx_quad_trail LinkTo( self, "tag_origin" );
		zm_net::network_safe_play_fx_on_tag( "quad_fx", 2, level._effect[ "quad_trail" ], self.fx_quad_trail, "tag_origin" );
	}
}


