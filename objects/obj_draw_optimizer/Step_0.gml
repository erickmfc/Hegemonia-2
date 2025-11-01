// =============================================
// STEP - Atualizar estatísticas periodicamente
// =============================================

if (!optimization_enabled) exit;

// Limpar arrays de batch (serão preenchidos novamente no próximo frame)
batch_text_array = [];
batch_rect_array = [];
batch_circle_array = [];

// Atualizar estatísticas periodicamente
stats_timer--;
if (stats_timer <= 0) {
    stats_timer = stats_interval;
    
    // Resetar contadores (serão atualizados pelos objetos)
    objects_skipped = 0;
}
