// Explosão no solo (poeira + chamas)
// ✅ CORREÇÃO: Inicializar sem_som como false por padrão
if (!variable_instance_exists(id, "sem_som")) {
    sem_som = false; // Inicializar como false se não existir
}

// ✅ CORREÇÃO: NÃO tocar som no Create - será verificado no Step Event
// Isso permite que sem_som seja definido ANTES do som tocar
som_tocado = false; // Flag para controlar se o som já foi tocado

// Poeira
for (var i = 0; i < 12; i++) {
    var fx = instance_create_layer(x, y, "Efeitos", obj_fumaca_missil);
    fx.image_blend = c_gray;
    fx.vspeed = random_range(-2, -0.5);
    fx.hspeed = random_range(-1.5, 1.5);
}

// Fogo central
part_type = part_type_create();
part_type_shape(part_type, pt_shape_explosion);
part_type_size(part_type, 0.8, 1.5, 0, 0);
part_type_color1(part_type, c_red);
part_type_color3(part_type, c_red, c_yellow, c_orange);
part_type_alpha2(part_type, 1, 0);
part_type_speed(part_type, 1, 4, 0, 0);
part_type_direction(part_type, 0, 360, 0, 0);
part_type_life(part_type, 15, 25);

part_sys = part_system_create();
part_system_depth(part_sys, depth - 1);

// ✅ OTIMIZAÇÃO: Reduzir partículas baseado em LOD
var _lod_level = scr_get_lod_level();
var _particle_count = 40;
if (_lod_level == 1) _particle_count = 20; // Metade em zoom médio
else if (_lod_level == 0) _particle_count = 5; // Mínimo em zoom muito afastado

part_particles_create(part_sys, x, y, part_type, _particle_count);

alarm[0] = 36; // ✅ REDUZIDO: 0.6 segundos (era 90 frames = 1.5 segundos)
