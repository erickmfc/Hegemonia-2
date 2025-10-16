// ===============================================
// HEGEMONIA GLOBAL - RASTRO DE FOGO DO MOTOR
// Sistema de Partículas para Propulsão
// ===============================================

// === CREATE EVENT ===
// Sistema de partículas
part_system = part_system_create();
part_system_depth(part_system, depth + 1);

// === TIPO: FOGO DO MOTOR ===
fogo_motor = part_type_create();
part_type_shape(fogo_motor, pt_shape_flare);
part_type_size(fogo_motor, 0.2, 0.5, 0, 0);
part_type_color3(fogo_motor,
    make_color_rgb(255, 100, 0),   // Vermelho-alaranjado
    make_color_rgb(255, 200, 0),   // Amarelo
    make_color_rgb(255, 255, 150)); // Amarelo claro
part_type_alpha3(fogo_motor, 0.8, 0.4, 0);
part_type_life(fogo_motor, 10, 20);
part_type_speed(fogo_motor, 1, 3, 0, 0);
part_type_direction(fogo_motor, 0, 359, 0, 0);
part_type_blend(fogo_motor, bm_add);

// === CONFIGURAÇÕES ===
timer_vida = 0;
tempo_vida_maximo = 30; // 0.5 segundos
intensidade_fogo = 2; // Partículas por frame

show_debug_message("Sistema de rastro de fogo criado");
