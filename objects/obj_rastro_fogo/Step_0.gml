// ===============================================
// HEGEMONIA GLOBAL - RASTRO DE FOGO DO MOTOR
// Geração Contínua de Partículas (OTIMIZADO)
// ===============================================

// === STEP EVENT ===
// ✅ OTIMIZAÇÃO: Reduzir partículas em zoom out
var _lod_level = scr_get_lod_level();
var _skip_particles = (_lod_level <= 1); // Não criar partículas em zoom afastado

if (!_skip_particles && timer_vida < tempo_vida_maximo) {
    timer_vida++;
    
    // ✅ OTIMIZAÇÃO: Quantidade reduzida baseada em LOD
    var _quantidade = intensidade_fogo;
    if (_lod_level == 1) _quantidade = floor(intensidade_fogo / 2); // Metade em zoom médio
    
    repeat (_quantidade) {
        part_particles_create(part_system, 
            x + random_range(-3, 3), 
            y + random_range(-3, 3), 
            fogo_motor, 1);
    }
} else if (_skip_particles) {
    // Não criar partículas, apenas incrementar timer
    timer_vida++;
    if (timer_vida >= tempo_vida_maximo) {
        instance_destroy();
    }
} else {
    // Auto-destruição
    instance_destroy();
}
