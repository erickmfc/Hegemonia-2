/// @function scr_inicializar_sistema()
/// @description Inicializa o sistema básico do jogo
/// @return {undefined}

function scr_inicializar_sistema() {
    // ===============================================
    // HEGEMONIA GLOBAL - INICIALIZAÇÃO BÁSICA
    // Sistema de inicialização básica do jogo
    // ===============================================
    
    show_debug_message("🚀 Inicializando sistema básico...");
    
    // Inicializar variáveis globais básicas
    global.game_frame = 0;
    global.debug_enabled = true;
    global.modo_construcao = false;
    global.construindo_agora = noone;
    global.unidade_selecionada = noone;
    
    // ✅ CORREÇÃO GM2039: scr_enums_navais contém apenas enums que são globais automaticamente
    // Não precisa chamar - os enums já estão disponíveis quando o script é incluído no projeto
    
    // Inicializar sistema de recursos
    scr_inicializar_recursos();
    
    // Inicializar sistema de UI
    scr_inicializar_ui();
    
    // Inicializar sistema de debug
    scr_inicializar_debug();
    
    show_debug_message("✅ Sistema básico inicializado com sucesso");
}

/// @function scr_inicializar_recursos()
/// @description Inicializa o sistema de recursos
/// @return {undefined}

function scr_inicializar_recursos() {
    show_debug_message("💰 Inicializando sistema de recursos...");
    
    // Inicializar dinheiro
    global.dinheiro = 50000;
    
    // Inicializar recursos da nação
    global.nacao_recursos = ds_map_create();
    global.nacao_recursos[? "Minério"] = 1500;
    global.nacao_recursos[? "Petróleo"] = 1000;
    global.nacao_recursos[? "Alumínio"] = 200;
    global.nacao_recursos[? "Cobre"] = 300;
    global.nacao_recursos[? "Lítio"] = 75;
    global.nacao_recursos[? "Ouro"] = 100;
    global.nacao_recursos[? "Titânio"] = 50;
    global.nacao_recursos[? "Urânio"] = 25;
    global.nacao_recursos[? "Borracha"] = 150;
    global.nacao_recursos[? "Madeira"] = 500;
    global.nacao_recursos[? "Silício"] = 100;
    global.nacao_recursos[? "Aço"] = 400;
    
    show_debug_message("✅ Sistema de recursos inicializado");
}

/// @function scr_inicializar_ui()
/// @description Inicializa o sistema de UI
/// @return {undefined}

function scr_inicializar_ui() {
    show_debug_message("🎨 Inicializando sistema de UI...");
    
    // Configurar fonte padrão
    if (font_exists(fnt_ui_main)) {
        draw_set_font(fnt_ui_main);
        show_debug_message("✅ Fonte fnt_ui_main aplicada");
    } else {
        show_debug_message("⚠️ Fonte fnt_ui_main não encontrada");
    }
    
    // Configurar escala de UI
    global.ui_scale = 1.2;
    global.text_quality = "high";
    
    // Configurar alinhamento padrão
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    show_debug_message("✅ Sistema de UI inicializado");
}

/// @function scr_inicializar_debug()
/// @description Inicializa o sistema de debug
/// @return {undefined}

function scr_inicializar_debug() {
    show_debug_message("🔍 Inicializando sistema de debug...");
    
    // Configurar sistema de debug
    global.debug_timer_global = 0;
    global.debug_frame_count = 0;
    global.debug_max_per_frame = 10;
    global.debug_current_frame = 0;
    
    show_debug_message("✅ Sistema de debug inicializado");
}

/// @function scr_verificar_sistema()
/// @description Verifica se o sistema está funcionando corretamente
/// @return {Bool} Retorna true se o sistema está OK

function scr_verificar_sistema() {
    show_debug_message("🔍 Verificando sistema...");
    
    var _sistema_ok = true;
    
    // Verificar recursos
    if (!ds_map_exists(global.nacao_recursos, "Minério")) {
        show_debug_message("❌ Sistema de recursos não inicializado");
        _sistema_ok = false;
    }
    
    // Verificar UI
    if (global.ui_scale <= 0) {
        show_debug_message("❌ Sistema de UI não inicializado");
        _sistema_ok = false;
    }
    
    // Verificar debug
    if (!variable_global_exists("debug_enabled")) {
        show_debug_message("❌ Sistema de debug não inicializado");
        _sistema_ok = false;
    }
    
    if (_sistema_ok) {
        show_debug_message("✅ Sistema verificado - tudo OK");
    } else {
        show_debug_message("❌ Sistema com problemas detectados");
    }
    
    return _sistema_ok;
}

/// @function scr_resetar_sistema()
/// @description Reseta o sistema para o estado inicial
/// @return {undefined}

function scr_resetar_sistema() {
    show_debug_message("🔄 Resetando sistema...");
    
    // Resetar variáveis globais
    global.game_frame = 0;
    global.modo_construcao = false;
    global.construindo_agora = noone;
    global.unidade_selecionada = noone;
    
    // Resetar recursos
    global.dinheiro = 50000;
    if (ds_map_exists(global.nacao_recursos, "Minério")) {
        global.nacao_recursos[? "Minério"] = 1500;
    }
    
    // Resetar debug
    global.debug_timer_global = 0;
    global.debug_frame_count = 0;
    
    show_debug_message("✅ Sistema resetado com sucesso");
}