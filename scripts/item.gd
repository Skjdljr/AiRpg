class_name Item
extends Resource

## The name of the item.
@export var name:String

## The icon of the item.
@export var icon:Texture2D

## The scene containing the 2d representation of the item.
@export var scene:PackedScene

## Shoppe price
@export var price:int = 5

## Instantiates the 2d representation and initializes it with the 
## current item
func instantiate() -> Node2D:
	var result : Node2D = scene.instantiate()
	if result.has_method("initialize"):
		result.initialize(self)
	return result