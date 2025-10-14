// ===============================================
// HEGEMONIA GLOBAL - CONTROLADOR DE PRODUÇÃO NAVAL
// Sistema Independente do Step Event
// ===============================================

// === CONFIGURAÇÕES BÁSICAS ===
monitorando = true;
timer_monitoramento = 0;
intervalo_verificacao = 1; // Verificar a cada frame
producoes_processadas = 0;

// === DEBUG ===
debug_ativo = true;
ultima_verificacao = 0;

show_debug_message("🎮 Controlador de Produção Naval criado!");
show_debug_message("   - ID: " + string(id));
show_debug_message("   - Monitorando: " + string(monitorando));
