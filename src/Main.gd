extends Node

onready var MIDI_PLAYER = $"Sound/GodotMIDIPlayer"

var current_note_index = 0

func _ready():

    print(MIDI_PLAYER.file)
    print(MIDI_PLAYER.soundfont)

    MIDI_PLAYER._prepare_to_play() # Ensures SoundFont is loaded.

    print(MIDI_PLAYER.channel_status.size())


func _on_Button_pressed() -> void:

    var channel = MIDI_PLAYER.channel_status[4]

    var notes = [60, 62, 60, 64, 60, 64, 60, 67]

    var event = {
                    "type": MIDI_PLAYER.SMF.MIDIEventType.note_on,
                    "note": notes[self.current_note_index],
                    "velocity": 100,
                } # via SMF.gd

    self.current_note_index = (self.current_note_index + 1) % notes.size()

    ##MIDI_PLAYER._stop_all_notes() ## TODO: Handle this properly

    MIDI_PLAYER._process_track_event_note_on(channel, event)
