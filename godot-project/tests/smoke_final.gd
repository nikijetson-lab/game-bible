extends SceneTree
var _scenes := [
	"res://scenes/locations/greyford/TavernInterior.tscn","res://scenes/locations/greyford/RufinRoom.tscn",
	"res://scenes/locations/greyford/CraftsmenQuarter.tscn","res://scenes/locations/greyford/PortTavernInterior.tscn",
	"res://scenes/locations/greyford/GreyfordGate.tscn","res://scenes/locations/greyford/AlteyaHiddenRoom.tscn",
	"res://scenes/locations/greyford/GreyfordStreet.tscn","res://scenes/locations/sonk_ferry/SonkFerry.tscn",
	"res://scenes/locations/sonk_ferry/FloodedChamber.tscn","res://scenes/locations/sonk_ferry/FloodedChapel.tscn",
	"res://scenes/locations/sonk_ferry/SaltWarehouse.tscn","res://scenes/locations/deep_bog/DeepBog.tscn",
	"res://scenes/locations/deep_bog/MadFerry.tscn","res://scenes/locations/deep_bog/FloodedAbbey.tscn",
	"res://scenes/locations/hazemoor/SwampPath.tscn","res://scenes/locations/tykhy_shelist/TykhyShelist.tscn",
	"res://scenes/locations/tykhy_shelist/ForbiddenGlade.tscn","res://scenes/locations/valkorn/PortQuarter.tscn",
	"res://scenes/locations/valkorn/Undercity.tscn","res://scenes/locations/valkorn/GuildWarehouse.tscn",
	"res://scenes/locations/valkorn/BlackArchive.tscn","res://scenes/locations/greyford/GreyfordStreet.tscn",
	"res://scenes/locations/sonk_ferry/SonkFerry.tscn",
]
func _init() -> void:
	var ok:=0; var fail:=0
	for path in _scenes:
		var p:PackedScene=load(path)
		if p==null: push_error("FAIL:"+path); fail+=1
		else: var i:=p.instantiate(); i.queue_free(); ok+=1
	print("FINAL: "+str(ok)+"/"+str(ok+fail)+" OK")
	quit(0 if fail==0 else 1)
