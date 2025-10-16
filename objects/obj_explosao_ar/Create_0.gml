// Explosão aérea (fogo e partículas)
audio_play_sound(som_anti, 1, false);

// Efeito de luz / partículas
part_type = part_type_create();
part_type_shape(part_type, pt_shape_explosion);
part_type_size(part_type, 0.5, 1.5, 0, 0);
part_type_color1(part_type, c_orange);
part_type_alpha2(part_type, 1, 0);
part_type_speed(part_type, 2, 5, 0, 0);
part_type_direction(part_type, 0, 360, 0, 0);
part_type_life(part_type, 15, 25);

part_sys = part_system_create();
part_system_depth(part_sys, depth - 1);
part_particles_create(part_sys, x, y, part_type, 40);

alarm[0] = room_speed * 1; // 1 segundo
