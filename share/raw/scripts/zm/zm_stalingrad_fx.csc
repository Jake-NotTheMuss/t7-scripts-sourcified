#using scripts\codescripts\struct;

// electric trap fx
#precache( "client_fx", "dlc3/stalingrad/fx_elec_trap_stalingrad" );

// dragon breath hint fx
#precache( "client_fx", "dlc3/stalingrad/fx_player_screen_fire_embers_hazard" );

// lockdown light fx
#precache( "client_fx", "dlc3/stalingrad/fx_light_emergency_flash_loop_stalingrad" );

// dragon egg fx
#precache( "client_fx", "dlc3/stalingrad/fx_dragon_gauntlet_egg_heat" );

// drop pod fx
#precache( "client_fx", "dlc3/stalingrad/fx_drop_pod_health_light_green" );
#precache( "client_fx", "dlc3/stalingrad/fx_drop_pod_health_light_yellow" );
#precache( "client_fx", "dlc3/stalingrad/fx_drop_pod_health_light_red" );

// perk fx overrides
#precache( "client_fx", "dlc3/stalingrad/fx_perk_juggernaut_sta" );
#precache( "client_fx", "dlc3/stalingrad/fx_perk_doubletap_sta" );
#precache( "client_fx", "dlc3/stalingrad/fx_perk_mule_kick_sta" );
#precache( "client_fx", "dlc3/stalingrad/fx_perk_quick_revive_sta" );
#precache( "client_fx", "dlc3/stalingrad/fx_perk_sleight_of_hand_sta" );
#precache( "client_fx", "dlc3/stalingrad/fx_perk_stamin_up_sta" );

// explosion
#precache( "client_fx", "explosions/fx_exp_grenade_default" );

// ambient
#precache( "client_fx", "dlc3/stalingrad/fx_exp_mortar_stalingrad_exp_sm_os" );
#precache( "client_fx", "dlc3/stalingrad/fx_exp_mortar_stalingrad_exp_os" );
#precache( "client_fx", "dlc3/stalingrad/fx_exp_mortar_stalingrad_exp_lg_os" );
#precache( "client_fx", "dlc3/stalingrad/fx_exp_artillery_sm" );
#precache( "client_fx", "dlc3/stalingrad/fx_exp_artillery_md" );
#precache( "client_fx", "dlc3/stalingrad/fx_exp_artillery_lg" );

// dragon transport fx
#precache( "client_fx", "dlc3/stalingrad/fx_dragon_transport_saddle_jump" );

// dragon boss fx
#precache( "client_fx", "dlc3/stalingrad/fx_dragon_mouth_drips_tongue_boss" );
#precache( "client_fx", "dlc3/stalingrad/fx_dragon_mouth_drips_boss" );
#precache( "client_fx", "dlc3/stalingrad/fx_dragon_glow_eye_L" );
#precache( "client_fx", "dlc3/stalingrad/fx_dragon_glow_eye_R" );
#precache( "client_fx", "dlc3/stalingrad/fx_dragon_hit_lava" );

// nikolai mech fx
#precache( "client_fx", "dlc3/stalingrad/fx_mech_vdest_heat_vent_tell" );
#precache( "client_fx", "dlc3/stalingrad/fx_mech_vdest_heat_vent_loop" );
#precache( "client_fx", "dlc3/stalingrad/fx_mech_wpn_cannon_tell" );
#precache( "client_fx", "dlc3/stalingrad/fx_mech_wpn_harpoon_ground_impact" );
#precache( "client_fx", "vehicle/fx_nikolai_raps_trail_small" );
#precache( "client_fx", "dlc3/stalingrad/fx_mech_wpn_raps_landing" );

// audio wisp fx
#precache( "client_fx", "dlc3/stalingrad/fx_voice_log_blue" );


function init()
{
	precache_scripted_fx();
}

function precache_scripted_fx()
{
	// electric trap fx
	level._effect[ "zapper" ]									= "dlc3/stalingrad/fx_elec_trap_stalingrad";

	// dragon breath hint fx
	level._effect[ "dragon_fire_burn_tell" ]					= "dlc3/stalingrad/fx_player_screen_fire_embers_hazard";

	// lockdown light fx
	level._effect[ "pavlov_lockdown_light" ]					= "dlc3/stalingrad/fx_light_emergency_flash_loop_stalingrad";

	// dragon egg fx
	level._effect[ "dragon_egg_heat" ]							= "dlc3/stalingrad/fx_dragon_gauntlet_egg_heat";

	// drop pod fx
	level._effect[ "drop_pod_hp_light_green" ]					= "dlc3/stalingrad/fx_drop_pod_health_light_green";
	level._effect[ "drop_pod_hp_light_yellow" ]					= "dlc3/stalingrad/fx_drop_pod_health_light_yellow";
	level._effect[ "drop_pod_hp_light_red" ]					= "dlc3/stalingrad/fx_drop_pod_health_light_red";

	// perk fx overrides
	level._effect[ "jugger_light" ]								= "dlc3/stalingrad/fx_perk_juggernaut_sta";
	level._effect[ "doubletap2_light" ]							= "dlc3/stalingrad/fx_perk_doubletap_sta";
	level._effect[ "additionalprimaryweapon_light" ]			= "dlc3/stalingrad/fx_perk_mule_kick_sta";
	level._effect[ "revive_light" ]								= "dlc3/stalingrad/fx_perk_quick_revive_sta";
	level._effect[ "sleight_light" ]							= "dlc3/stalingrad/fx_perk_sleight_of_hand_sta";
	level._effect[ "marathon_light" ]							= "dlc3/stalingrad/fx_perk_stamin_up_sta";

	// explosion
	level._effect[ "generic_explosion" ]						= "explosions/fx_exp_grenade_default";

	// ambient
	level._effect[ "ambient_mortar_small" ]						= "dlc3/stalingrad/fx_exp_mortar_stalingrad_exp_sm_os";
	level._effect[ "ambient_mortar_medium" ]					= "dlc3/stalingrad/fx_exp_mortar_stalingrad_exp_os";
	level._effect[ "ambient_mortar_large" ]						= "dlc3/stalingrad/fx_exp_mortar_stalingrad_exp_lg_os";
	level._effect[ "ambient_artillery_small" ]					= "dlc3/stalingrad/fx_exp_artillery_sm";
	level._effect[ "ambient_artillery_medium" ]					= "dlc3/stalingrad/fx_exp_artillery_md";
	level._effect[ "ambient_artillery_large" ]					= "dlc3/stalingrad/fx_exp_artillery_lg";

	// dragon transport fx
	level._effect[ "transport_eject" ]							= "dlc3/stalingrad/fx_dragon_transport_saddle_jump";

	// dragon boss fx
	level._effect[ "dragon_tongue" ]							= "dlc3/stalingrad/fx_dragon_mouth_drips_tongue_boss";
	level._effect[ "dragon_mouth" ]								= "dlc3/stalingrad/fx_dragon_mouth_drips_boss";
	level._effect[ "dragon_eye_l" ]								= "dlc3/stalingrad/fx_dragon_glow_eye_L";
	level._effect[ "dragon_eye_r" ]								= "dlc3/stalingrad/fx_dragon_glow_eye_R";
	level._effect[ "dragon_wound_hit" ]							= "dlc3/stalingrad/fx_dragon_hit_lava";

	// nikolai mech fx
	level._effect[ "nikolai_weakpoint_fx" ]						= "dlc3/stalingrad/fx_mech_vdest_heat_vent_tell";
	level._effect[ "nikolai_weakpoint_destroyed" ]				= "dlc3/stalingrad/fx_mech_vdest_heat_vent_loop";
	level._effect[ "nikolai_gatling_tell" ]						= "dlc3/stalingrad/fx_mech_wpn_cannon_tell";
	level._effect[ "nikolai_harpoon_impact" ]					= "dlc3/stalingrad/fx_mech_wpn_harpoon_ground_impact";
	level._effect[ "nikolai_raps_trail" ]						= "vehicle/fx_nikolai_raps_trail_small";
	level._effect[ "nikolai_raps_landing" ]						= "dlc3/stalingrad/fx_mech_wpn_raps_landing";

	// audio wisp fx
	level._effect[ "audio_log" ]								= "dlc3/stalingrad/fx_voice_log_blue";
}
