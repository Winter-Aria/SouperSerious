extends Resource
class_name Base_Actor

var Max_Health : int = 20
var Health : int = Max_Health

var Block : int = 0

func Damage(_damage : int) -> void:
	Health -= _damage - Block
	
	clampi(Health, 0, 10000)

func End_Of_Turn_Reset() -> void:
	Block = 0
