/// @function scr_inicializar_sistema_simples()
/// @description Inicializa o sistema de forma simples e direta
/// @return {undefined}

function scr_inicializar_sistema_simples() {
    // ===============================================
    // HEGEMONIA GLOBAL - INICIALIZAÇÃO SIMPLES
    // Sistema de inicialização simples e direta
    // ===============================================
    
    show_debug_message("🚀 Inicializando sistema simples...");
    
    // Inicializar variáveis globais essenciais
    global.game_frame = 0;
    global.debug_enabled = true;
    global.modo_construcao = false;
    global.unidade_selecionada = noone;
    
    // Inicializar recursos básicos
    global.dinheiro = 50000;
    global.nacao_recursos = ds_map_create();
    global.nacao_recursos[? "Minério"] = 1500;
    global.nacao_recursos[? "Petróleo"] = 1000;
    
    // Inicializar UI básica
    global.ui_scale = 1.0;
    global.text_quality = "medium";
    
    // Inicializar sistema de debug
    global.debug_timer_global = 0;
    global.debug_frame_count = 0;
    
    show_debug_message("✅ Sistema simples inicializado com sucesso");
}

/// @function scr_inicializar_sistema_simples_rapido()
/// @description Inicialização ultra-rápida para testes
/// @return {undefined}

function scr_inicializar_sistema_simples_rapido() {
    show_debug_message("⚡ Inicialização rápida...");
    
    // Apenas o essencial
    global.game_frame = 0;
    global.debug_enabled = true;
    global.dinheiro = 100000;
    global.unidade_selecionada = noone;
    
    show_debug_message("✅ Inicialização rápida concluída");
}

/// @function scr_inicializar_sistema_simples_minimo()
/// @description Inicialização mínima para debug
/// @return {undefined}

function scr_inicializar_sistema_simples_minimo() {
    show_debug_message("🔧 Inicialização mínima...");
    
    // Mínimo absoluto
    global.game_frame = 0;
    global.debug_enabled = true;
    
    show_debug_message("✅ Inicialização mínima concluída");
}