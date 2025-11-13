// Colisão com alvo aéreo ou parede
// ✅ CORREÇÃO: Verificar se explosão já foi criada para evitar múltiplas criações
if (!variable_instance_exists(id, "explosao_criada")) {
    explosao_criada = false;
}
if (!explosao_criada && object_exists(obj_explosao_ar)) {
    explosao_criada = true; // Marcar como criada
    var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
    if (instance_exists(_explosao)) {
        if (variable_instance_exists(id, "sem_som")) {
            _explosao.sem_som = sem_som; // Passa flag para explosão
        }
        _explosao.image_blend = make_color_rgb(255,150,0);
        _explosao.image_xscale = 1.2;
        _explosao.image_yscale = 1.2;
        _explosao.alarm[0] = 90; // ✅ CORREÇÃO: 1.5 segundos (90 frames)
    }
}
// ✅ Som removido - sem som de impacto
instance_destroy();
