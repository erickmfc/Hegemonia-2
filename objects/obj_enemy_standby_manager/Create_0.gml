// =============================================
// SISTEMA DE STANDBY PARA UNIDADES INIMIGAS
// Gerencia unidades inimigas fora da câmera
// =============================================

// === CONFIGURAÇÕES ===
standby_enabled = true; // Habilitar sistema de standby
standby_distance = 1200; // Distância da câmera para entrar em standby (pixels)
activation_distance = 800; // Distância para ativar novamente (pixels)
check_interval = 60; // Verificar a cada 60 frames (1 segundo a 60fps)

// === ESTATÍSTICAS ===
units_in_standby = 0; // Unidades em standby
units_activated = 0; // Unidades ativadas

// === TIMER ===
timer_check = 0;

// Debug
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("✅ Sistema de Standby para Unidades Inimigas ativado");
    show_debug_message("📋 Distância standby: " + string(standby_distance) + "px");
}
