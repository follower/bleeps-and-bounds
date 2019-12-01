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

    var NUM_BEATS = self.beat_indicators.size()

    # Ensures the first visible beat indicator transition is from the last beat to the first beat.
    var active_beat: int = self.beat_indicators.size() - 1

    for counter in range(16):
        var next_beat: int = (active_beat + 1) % NUM_BEATS

        self._tweener.remove_all()

        self._tweener.interpolate_property(self.beat_indicators[active_beat].material, "emission_energy", 0.25, 0.0, 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)

        self._tweener.interpolate_property(self.beat_indicators[next_beat].material, "emission_energy", 0.0, 0.25, 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)

        self._tweener.start()

        yield(get_tree().create_timer(0.5), "timeout")

        active_beat = next_beat
