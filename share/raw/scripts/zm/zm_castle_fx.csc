#using scripts\codescripts\struct;

#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

// electric trap fx
#precache( "client_fx", "dlc1/castle/fx_elec_trap_castle" );

// rocket test effects
#precache( "client_fx", "smoke/fx_smk_ambient_cieling_newworld" );
#precache( "client_fx", "explosions/fx_exp_vtol_crash_trail_prologue" );
#precache( "client_fx", "fire/fx_fire_side_lrg" );

// zombie death ray effect
#precache( "client_fx", "zombie/fx_tesla_shock_eyes_zmb" );

function precache_util_fx()
{
}

function main()
{
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
}

function precache_scripted_fx()
{
	// electric trap fx
	level._effect[ "zapper" ]								= "dlc1/castle/fx_elec_trap_castle";

	// rocket test effects
	level._effect[ "rocket_warning_smoke" ]					= "smoke/fx_smk_ambient_cieling_newworld";
	level._effect[ "rocket_warning_fire" ]					= "explosions/fx_exp_vtol_crash_trail_prologue";
	level._effect[ "rocket_side_blast" ]					= "fire/fx_fire_side_lrg";

	// zombie death ray effect
	level._effect[ "death_ray_shock_eyes" ]					= "zombie/fx_tesla_shock_eyes_zmb";
}

function precache_createfx_fx()
{
}
