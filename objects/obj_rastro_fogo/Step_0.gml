// ===============================================
// HEGEMONIA GLOBAL - RASTRO DE FOGO DO MOTOR
// Geração Contínua de Partículas
// ===============================================

// === STEP EVENT ===
// Criar partículas de fogo continuamente
if (timer_vida < tempo_vida_maximo) {
    timer_vida++;
    
    // Criar fogo com variação
    var _quantidade = intensidade_fogo + irandom(1);
    repeat (_quantidade) {
        part_particles_create(part_system, 
            x + random_range(-3, 3), 
            y + random_range(-3, 3), 
            fogo_motor, 1);
    }
} else {
    // Auto-destruição
    instance_destroy();
}
