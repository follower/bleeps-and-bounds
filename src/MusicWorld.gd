extends Spatial

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var BAR01_BEAT1_INDICATOR = $"Bar01Beat1Indicator"
onready var BAR01_BEAT2_INDICATOR = $"Bar01Beat2Indicator"
onready var BAR01_BEAT3_INDICATOR = $"Bar01Beat3Indicator"
onready var BAR01_BEAT4_INDICATOR = $"Bar01Beat4Indicator"

var beat_indicators = [BAR01_BEAT1_INDICATOR, BAR01_BEAT2_INDICATOR, BAR01_BEAT3_INDICATOR, BAR01_BEAT4_INDICATOR]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

    var current_beat_indicator: CSGBox # Note: `CSGShape` doesn't have `material` due to `CSGMesh`?

#    for current_beat_indicator in self.beat_indicators:
#    current_beat_indicator.material.
