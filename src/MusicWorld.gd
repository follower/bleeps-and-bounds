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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

    var current_beat_indicator: CSGBox # Note: `CSGShape` doesn't have `material` due to `CSGMesh`?
    var current_material: SpatialMaterial # TODO: Use GLES3 so we can enable `glow` in environment?

    for current_beat_indicator in self.beat_indicators:
        # Make it so we can control "flash" of each indicator separately.
        # TODO: Figure out how to do this properly...
        current_beat_indicator.material = current_beat_indicator.material.duplicate()
        current_material = current_beat_indicator.material

    self.beat_indicators[0].material.set("emission_energy", 0.25)
