class_name ParticleManager extends Node2D

const ON_HIT_PARTICLE_NODE = preload("res://Scenes/on_hit_particle_node.tscn")

func spawn_on_hit_particle(projectile_node: ProjectileNode):
	var new_on_hit_particle = ON_HIT_PARTICLE_NODE.instantiate()
	new_on_hit_particle.position = projectile_node.position
	add_child(new_on_hit_particle)
