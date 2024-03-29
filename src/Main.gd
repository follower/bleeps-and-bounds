extends Node

onready var MIDI_PLAYER = $"Sound/GodotMIDIPlayer"

onready var MUSIC_WORLD = $"Spatial/MusicWorld"

var current_note_index = 0

func _ready():

    print(MIDI_PLAYER.file)
    print(MIDI_PLAYER.soundfont)

    MIDI_PLAYER._prepare_to_play() # Ensures SoundFont is loaded.

    print(MIDI_PLAYER.channel_status.size())


var notes = [60, 62, 60, 64, 60, 64, 60, 67]

func _on_Button_pressed() -> void:

    var channel = MIDI_PLAYER.channel_status[4]

    var event = {
                    "type": MIDI_PLAYER.SMF.MIDIEventType.note_on,
                    "note": notes[self.current_note_index],
                    "velocity": 100,
                } # via SMF.gd

    self.current_note_index = (self.current_note_index + 1) % notes.size()

    ##MIDI_PLAYER._stop_all_notes() ## TODO: Handle this properly

    MIDI_PLAYER._process_track_event_note_on(channel, event)


func play_note(note_value: int) -> void:
    var channel = MIDI_PLAYER.channel_status[4]

    var event = {
                    "type": MIDI_PLAYER.SMF.MIDIEventType.note_on,
                    "note": note_value,
                    "velocity": 100,
                } # via SMF.gd

    MIDI_PLAYER._process_track_event_note_on(channel, event)


func _on_SeqPlayButton_pressed() -> void:

    # Automatically stop the note platform before starting playback.
    MUSIC_WORLD.stop_note_platform()

    # TODO: Mute or wait to allow playing note to stop.

    MUSIC_WORLD.play_note_sequence()


func _on_JumpButton_pressed() -> void:
    # This button is primarily for mobile.
    # TODO: Handle this better? e.g. a screen tap.
    MUSIC_WORLD.handle_jump()
