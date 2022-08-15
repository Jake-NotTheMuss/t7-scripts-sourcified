#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai\zombie_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\zm_tomb_quest_crypt;

function main()
{
	clientfield::register( "world", "light_show", VERSION_DLC5, 2, "int" );

	// special flag to force showing morse code
	level flag::init( "show_morse_code" );

	// set the character codes, messages, and cipher key
	init_morse_code();

	while ( !level flag::exists( "start_zombie_round_logic" ) )
	{
		WAIT_SERVER_FRAME;
	}
	level flag::wait_till( "start_zombie_round_logic" );

	chamber_discs = GetEntArray( "crypt_puzzle_disc", "script_noteworthy" );
	lit_discs = [];
	foreach ( disc in chamber_discs )
	{
		if ( isdefined( disc.script_int ) )
		{
			lit_discs[ disc.script_int - 1 ] = disc;
		}
	}

	// wait for the right time
	level flag::wait_till_any( array( "ee_all_staffs_upgraded", "show_morse_code" ) );

	while( 1 )
	{
		clientfield::set( "light_show", 1 );

		if ( RandomInt( 100 ) < 10 )
		{
			turn_all_lights_off( lit_discs );

			wait 10;

			clientfield::set( "light_show", 3 );
			light_show_morse( lit_discs, "GIOVAN BATTISTA BELLASO" );

			clientfield::set( "light_show", 1 );
		}

		turn_all_lights_off( lit_discs );

		wait 10;

		clientfield::set( "light_show", 2 );

		light_show_morse( lit_discs, level.cipher_key );

		foreach( message in level.morse_messages )
		{
			clientfield::set( "light_show", 1 );

			cipher = phrase_convert_to_cipher( message, level.cipher_key );

			turn_all_lights_off( lit_discs );

			wait 10;

			light_show_morse( lit_discs, cipher );
		}
	}
}

function init_morse_code()
{
	// character mapping
	level.morse_letters = [];
	level.morse_letters[ "A" ] = ".-";
	level.morse_letters[ "B" ] = "-...";
	level.morse_letters[ "C" ] = "-.-.";
	level.morse_letters[ "D" ] = "-..";
	level.morse_letters[ "E" ] = ".";
	level.morse_letters[ "F" ] = "..-.";
	level.morse_letters[ "G" ] = "--.";
	level.morse_letters[ "H" ] = "....";
	level.morse_letters[ "I" ] = "..";
	level.morse_letters[ "J" ] = ".---";
	level.morse_letters[ "K" ] = "-.-";
	level.morse_letters[ "L" ] = ".-..";
	level.morse_letters[ "M" ] = "--";
	level.morse_letters[ "N" ] = "-.";
	level.morse_letters[ "O" ] = "---";
	level.morse_letters[ "P" ] = ".--.";
	level.morse_letters[ "Q" ] = "--.-";
	level.morse_letters[ "R" ] = ".-.";
	level.morse_letters[ "S" ] = "...";
	level.morse_letters[ "T" ] = "-";
	level.morse_letters[ "U" ] = "..-";
	level.morse_letters[ "V" ] = "...-";
	level.morse_letters[ "W" ] = ".--";
	level.morse_letters[ "X" ] = "-..-";
	level.morse_letters[ "Y" ] = "-.--";
	level.morse_letters[ "Z" ] = "--..";

	// messages
	level.morse_messages = [];
	level.morse_messages[ 0 ] = "WARN MESSINES";
	level.morse_messages[ 1 ] = "SOMETHING BLUE IN THE EARTH";
	level.morse_messages[ 2 ] = "NOT CLAY";
	level.morse_messages[ 3 ] = "WE GREW WEAK";
	level.morse_messages[ 4 ] = "THOUGHT IT WAS FLU";
	level.morse_messages[ 5 ] = "MEN BECAME BEASTS";
	level.morse_messages[ 6 ] = "BLOOD TURNED TO ASH";
	level.morse_messages[ 7 ] = "LIBERATE TUTE DE INFERNIS";

	// key
	level.cipher_key = "INFERNO";
}

function turn_all_lights_off( a_discs )
{
	foreach( disc in a_discs )
	{
		disc zm_tomb_quest_crypt::bryce_cake_light_update( false );
	}
}

function turn_all_lights_on( a_discs )
{
	foreach( disc in a_discs )
	{
		disc zm_tomb_quest_crypt::bryce_cake_light_update( true );
	}
}

function phrase_convert_to_cipher( str_phrase, str_key )
{
	alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	alphabet_vals = [];
	num = 0;

	for ( i = 0; i < alphabet.size; i++ )
	{
		letter = alphabet[ i ];
		alphabet_vals[ letter ] = num;
		num++;
	}

	encrypted_phrase = [];
	j = 0;

	for ( i = 0; i < str_phrase.size; i++ )
	{
		cipher_letter = str_key[ j % str_key.size ];
		original_letter = str_phrase[ i ];
		n_original_letter = alphabet_vals[ original_letter ];

		if ( !isdefined( n_original_letter ) )
		{
			encrypted_phrase[ encrypted_phrase.size ] = original_letter;
		}
		else
		{
			n_cipher_offset = alphabet_vals[ cipher_letter ];
			n_ciphered_letter = ( n_original_letter + n_cipher_offset ) % alphabet.size;
			encrypted_phrase[ encrypted_phrase.size ] = alphabet[ n_ciphered_letter ];
			j++;
		}
	}

	return encrypted_phrase;
}

function light_show_morse( a_discs, message )
{
	for ( i = 0; i < message.size; i++ )
	{
		letter = message[ i ];
		letter_code = level.morse_letters[ letter ];

		if ( isdefined( letter_code ) )
		{
			for ( j = 0; j < letter_code.size; j++ )
			{
				turn_all_lights_on( a_discs );

				if ( letter_code[ j ] == "." )
					wait .2;
				else if ( letter_code[ j ] == "-" )
					wait 1;

				turn_all_lights_off( a_discs );

				wait .5;
			}
		}
		else
		{
			wait 2;
		}

		wait 1.5;
	}
}
