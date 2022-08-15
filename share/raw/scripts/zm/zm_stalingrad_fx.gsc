#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

// Drop pod effects
#precache( "fx", "dlc3/stalingrad/fx_drop_pod_ground_marker" );
#precache( "fx", "dlc3/stalingrad/fx_drop_pod_zombie_soul" );
#precache( "fx", "dlc3/stalingrad/fx_drop_pod_smk_ground" );
#precache( "fx", "dlc3/stalingrad/fx_drop_pod_exp_success" );
#precache( "fx", "dlc3/stalingrad/fx_drop_pod_exp_fail" );
#precache( "fx", "dlc3/stalingrad/fx_drop_pod_glow_pick_up" );
#precache( "fx", "dlc3/stalingrad/fx_drop_pod_health_light_green" );
#precache( "fx", "dlc3/stalingrad/fx_drop_pod_health_light_yellow" );
#precache( "fx", "dlc3/stalingrad/fx_drop_pod_health_light_red" );

// underwater fx
#precache( "fx", "debris/fx_debris_underwater_current_sgen_os" );

// powerup fx
#precache( "fx", "zombie/fx_powerup_on_red_zmb" );
#precache( "fx", "zombie/fx_powerup_grab_red_zmb" );

// dragon strike fx
#precache( "fx", "dlc3/stalingrad/fx_dragon_strike_lock_box" );

// player electrified fx
#precache( "fx", "zombie/fx_elec_player_md_zmb" );
#precache( "fx", "zombie/fx_elec_player_sm_zmb" );
#precache( "fx", "zombie/fx_elec_player_torso_zmb" );

// dragon fx
#precache( "fx", "dlc3/stalingrad/fx_dragon_weak_point_bleeding" );

// raps fx
#precache( "fx", "zombie/fx_meatball_impact_ground_tell_zod_zmb" );

// fx overrides
#precache( "fx", "dlc3/stalingrad/fx_perk_juggernaut_sta" );
#precache( "fx", "dlc3/stalingrad/fx_perk_doubletap_sta" );
#precache( "fx", "dlc3/stalingrad/fx_perk_mule_kick_sta" );
#precache( "fx", "dlc3/stalingrad/fx_perk_quick_revive_sta" );
#precache( "fx", "dlc3/stalingrad/fx_perk_sleight_of_hand_sta" );
#precache( "fx", "dlc3/stalingrad/fx_perk_stamin_up_sta" );


function init()
{
	precache_scripted_fx();
	precache_createfx_fx();
}

function precache_scripted_fx()
{
	// Drop pod effects
	level._effect[ "drop_pod_marker" ]							= "dlc3/stalingrad/fx_drop_pod_ground_marker";
	level._effect[ "drop_pod_charge_kill" ]						= "dlc3/stalingrad/fx_drop_pod_zombie_soul";
	level._effect[ "drop_pod_smoke" ]							= "dlc3/stalingrad/fx_drop_pod_smk_ground";
	level._effect[ "drop_pod_115_bomb" ]						= "dlc3/stalingrad/fx_drop_pod_exp_success";
	level._effect[ "drop_pod_go_boom" ]							= "dlc3/stalingrad/fx_drop_pod_exp_fail";
	level._effect[ "drop_pod_reward_glow" ]						= "dlc3/stalingrad/fx_drop_pod_glow_pick_up";
	level._effect[ "current_effect" ]							= "debris/fx_debris_underwater_current_sgen_os";
	level._effect[ "drop_pod_hp_light_green" ]					= "dlc3/stalingrad/fx_drop_pod_health_light_green";
	level._effect[ "drop_pod_hp_light_yellow" ]					= "dlc3/stalingrad/fx_drop_pod_health_light_yellow";
	level._effect[ "drop_pod_hp_light_red" ]					= "dlc3/stalingrad/fx_drop_pod_health_light_red";

	// powerup fx
	level._effect[ "powerup_on_red" ]							= "zombie/fx_powerup_on_red_zmb";
	level._effect[ "powerup_grabbed_red" ]						= "zombie/fx_powerup_grab_red_zmb";

	// dragon strike fx
	level._effect[ "lockbox_unlock_light" ]						= "dlc3/stalingrad/fx_dragon_strike_lock_box";

	// player electrified fx
	level._effect[ "elec_md" ]									= "zombie/fx_elec_player_md_zmb";
	level._effect[ "elec_sm" ]									= "zombie/fx_elec_player_sm_zmb";
	level._effect[ "elec_torso" ]								= "zombie/fx_elec_player_torso_zmb";

	// dragon fx
	level._effect[ "dragon_weakpoint_destroyed" ]				= "dlc3/stalingrad/fx_dragon_weak_point_bleeding";

	// raps fx
	level._effect[ "meatball_impact" ]							= "zombie/fx_meatball_impact_ground_tell_zod_zmb";
}

function precache_createfx_fx()
{
}

function fx_overrides()
{
	level._effect[ "jugger_light" ]								= "dlc3/stalingrad/fx_perk_juggernaut_sta";
	level._effect[ "doubletap2_light" ]							= "dlc3/stalingrad/fx_perk_doubletap_sta";
	level._effect[ "additionalprimaryweapon_light" ]			= "dlc3/stalingrad/fx_perk_mule_kick_sta";
	level._effect[ "revive_light" ]								= "dlc3/stalingrad/fx_perk_quick_revive_sta";
	level._effect[ "sleight_light" ]							= "dlc3/stalingrad/fx_perk_sleight_of_hand_sta";
	level._effect[ "marathon_light" ]							= "dlc3/stalingrad/fx_perk_stamin_up_sta";
}
