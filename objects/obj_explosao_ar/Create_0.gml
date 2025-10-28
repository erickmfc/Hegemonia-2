// Explosão aérea (fogo e partículas)
// ✅ CORREÇÃO: Usar asset_get_index() em vez de audio_exists()
var _sound_index = asset_get_index("som_anti");
if (_sound_index != -1) {
    audio_play_sound(som_anti, 1, false);
    show_debug_message("🔊 Som de impacto aéreo: som_anti");
} else {
    show_debug_message("❌ Som som_anti não encontrado!");
}

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

alarm[0] = game_get_speed(gamespeed_fps) * 1; // 1 segundo
