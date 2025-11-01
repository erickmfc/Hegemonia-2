// =============================================
// SISTEMA DE OTIMIZAÇÃO DE DRAW CALLS
// Gerencia simplificação de desenhos
// =============================================

// === CONFIGURAÇÕES ===
optimization_enabled = true; // Habilitar/desabilitar otimizações
skip_off_screen_draws = true; // Não desenhar objetos fora da tela
use_lod_draw_skip = true; // Usar LOD para pular draws em zoom out

// === ESTATÍSTICAS ===
draw_calls_saved = 0; // Número de draw calls economizados
objects_skipped = 0; // Objetos que não foram desenhados (fora da tela)

// === BATCH ARRAYS ===
batch_text_array = []; // Array para textos em batch
batch_rect_array = []; // Array para retângulos em batch
batch_circle_array = []; // Array para círculos em batch

// === TIMERS ===
stats_timer = 0;
stats_interval = 180; // Atualizar estatísticas a cada 3 segundos

// Debug
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("✅ Sistema de Otimização de Draw Calls ativado");
}
