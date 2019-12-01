extends Spatial

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var BAR01_BEAT1_INDICATOR = $"Bar01Beat1Indicator"
onready var BAR01_BEAT2_INDICATOR = $"Bar01Beat2Indicator"
onready var BAR01_BEAT3_INDICATOR = $"Bar01Beat3Indicator"
onready var BAR01_BEAT4_INDICATOR = $"Bar01Beat4Indicator"

onready var beat_indicators = [
                BAR01_BEAT1_INDICATOR,
                BAR01_BEAT2_INDICATOR,
                BAR01_BEAT3_INDICATOR,
                BAR01_BEAT4_INDICATOR]

var _tweener: Tween = Tween.new()

onready var NEW_NOTE_PLATFORM = $"Bar01Beat3Indicator/Platform1"
onready var NEW_NOTE_PLATFORM_TIMER: Timer = $"PlatformTimer"

onready var NOTE_PLAYER = $"../.."

var note_info = [
    {"value": 57, "name": "A", "offset": -2},
    {"value": 59, "name": "B", "offset": -1},
    {"value": 60, "name": "C", "offset": 0},
    {"value": 62, "name": "D", "offset": 1},
    {"value": 64, "name": "E", "offset": 2},
    ]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

    add_child(self._tweener, true)


    var current_beat_indicator: CSGBox # Note: `CSGShape` doesn't have `material` due to `CSGMesh`?
    var current_material: SpatialMaterial # TODO: Use GLES3 so we can enable `glow` in environment?

    for current_beat_indicator in self.beat_indicators:
        # Make it so we can control "flash" of each indicator separately.
        # TODO: Figure out how to do this properly...
        current_beat_indicator.material = current_beat_indicator.material.duplicate()
        current_material = current_beat_indicator.material

    self._tweener.start()

    yield(get_tree().create_timer(1.0), "timeout")

    if false:
        self._play_demo_with_beat_indicators()
    else:
        self._begin_recording_session()


var session_active_beat_index: int = 2 # Note: Beats are numbered 0-3 here

func _begin_recording_session() -> void:
    NOTE_PLAYER.notes = [60, 60] # TODO: Remove second note.


    self._tweener.interpolate_property(self.beat_indicators[self.session_active_beat_index].material, "emission_energy", 0.0, 0.25, 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)

    self._tweener.start()

    self.NEW_NOTE_PLATFORM_TIMER.start()


func _play_demo_with_beat_indicators() -> void:

    var NUM_BEATS = self.beat_indicators.size()

    # Ensures the first visible beat indicator transition is from the last beat to the first beat.
    var active_beat: int = self.beat_indicators.size() - 1

    for counter in range(16):
        var next_beat: int = (active_beat + 1) % NUM_BEATS

        self._tweener.remove_all()

        self._tweener.interpolate_property(self.beat_indicators[active_beat].material, "emission_energy", 0.25, 0.0, 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)

        self._tweener.interpolate_property(self.beat_indicators[next_beat].material, "emission_energy", 0.0, 0.25, 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)

        self._tweener.start()

        $"../.."._on_Button_pressed()

        yield(get_tree().create_timer(0.5), "timeout")

        active_beat = next_beat

    NOTE_PLAYER.notes.clear()

    self.NEW_NOTE_PLATFORM_TIMER.start()

func play_note_sequence() -> void:

    # TODO: Actually use MIDI player for this?

    for current_note in NOTE_PLAYER.notes:
        NOTE_PLAYER.play_note(current_note)
        yield(get_tree().create_timer(0.5), "timeout")


# warning-ignore:unused_argument
func _on_StaticBody_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
 #   print(event, shape_idx)

    if event.is_pressed():
        $"../..".play_note(60)


func _on_StaticBody2_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:

    if event.is_pressed():

        $"../..".play_note(62)


func _on_StaticBody3_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
    if event.is_pressed():

        $"../..".play_note(64)


var current_note_platform_position = 2
func update_note_platform_position() -> void:
    self.current_note_platform_position = (self.current_note_platform_position + 1) % self.note_info.size()
    self.NEW_NOTE_PLATFORM.translation.y = self.note_info[self.current_note_platform_position].offset * 2

    NOTE_PLAYER.play_note(self.note_info[self.current_note_platform_position].value)


func stop_note_platform() -> void:
    self.NEW_NOTE_PLATFORM_TIMER.stop()


func add_note_from_current_platform_position() -> void:
    NOTE_PLAYER.notes.append(self.note_info[self.current_note_platform_position].value)


func _on_PlatformTimer_timeout() -> void:
    self.update_note_platform_position()


func _unhandled_key_input(event: InputEventKey) -> void:
    if event.is_action_pressed("ui_accept"):
        self.add_note_from_current_platform_position()
    elif event.is_action_pressed("ui_cancel"):
        self.stop_note_platform()
