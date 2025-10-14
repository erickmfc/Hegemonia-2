/// Research Center - Create Event
/// Centro de Pesquisa Industrial - Inicialização

show_debug_message("Research Center (obj_research_center) initialized.");

// Research names array (12 fixed researches)
research_names = [
    "Aluminio", "Borracha", "Centro", "Cobre", "Litio", "Mina",
    "Ouro", "Petroleo", "Serraria", "Silicio", "Titanio", "Uranio"
];

// Corresponding sprites for each research
research_sprites = [
    spr_build_icon_aluminio, spr_build_icon_borracha, spr_build_icon_centro, spr_build_icon_cobre,
    spr_build_icon_litio, spr_build_icon_mina, spr_build_icon_ouro, spr_build_icon_petroleo,
    spr_build_icon_serraria, spr_build_icon_silicio, spr_build_icon_titanio, spr_build_icon_uranio
];

// Menu layout constants - Updated for better organization
menu_width_percent = 0.7;  // Slightly wider for 4 columns
menu_height_percent = 0.6;
columns = 4;  // 4 columns instead of 2
rows = 3;     // 3 rows instead of 6
button_width = 120;
button_height = 30;

// Research timing (tempo reduzido para testes)
research_duration_seconds = 30; // 30 segundos para testes (era 86400)
research_timer_steps = game_get_speed(gamespeed_fps) * research_duration_seconds;

// Initialize alarm for research processing (cada 1 segundo durante testes)
alarm[0] = game_get_speed(gamespeed_fps) * 1; // Check every 1 second for tests

show_debug_message("Research Center initialized with " + string(array_length(research_names)) + " research options.");

// === VERIFICAÇÃO DAS VARIÁVEIS GLOBAIS ===
show_debug_message("Verificando integração com sistema global...");
if (variable_global_exists("nacao_recursos")) {
    show_debug_message("✓ global.nacao_recursos encontrado");
    if (ds_exists(global.nacao_recursos, ds_type_map)) {
        show_debug_message("✓ global.nacao_recursos é um ds_map válido com " + string(ds_map_size(global.nacao_recursos)) + " entradas");
        
        // === DEBUG: Mostrar todas as chaves existentes ===
        show_debug_message("=== CHAVES EM global.nacao_recursos ===");
        var first_key = ds_map_find_first(global.nacao_recursos);
        var current_key = first_key;
        var count = 0;
        
        while (!is_undefined(current_key)) {
            var value = global.nacao_recursos[? current_key];
            show_debug_message("  [" + string(count) + "] '" + string(current_key) + "' = " + string(value));
            current_key = ds_map_find_next(global.nacao_recursos, current_key);
            count++;
        }
        show_debug_message("========================================");
        
        // === DEBUG: Verificar chaves esperadas ===
        show_debug_message("=== VERIFICANDO CHAVES ESPERADAS ===");
        for (var i = 0; i < array_length(research_names); i++) {
            var expected_key = research_names[i];
            var exists = ds_map_exists(global.nacao_recursos, expected_key);
            show_debug_message("  '" + expected_key + "': " + (exists ? "✓ OK" : "✗ FALTANDO"));
        }
        show_debug_message("========================================");
    } else {
        show_debug_message("✗ ERRO: global.nacao_recursos não é um ds_map válido!");
    }
} else {
    show_debug_message("✗ ERRO: global.nacao_recursos não existe!");
}

if (variable_global_exists("research_timers")) {
    show_debug_message("✓ global.research_timers encontrado");
} else {
    show_debug_message("✗ ERRO: global.research_timers não existe!");
}

if (variable_global_exists("dinheiro")) {
    show_debug_message("✓ global.dinheiro: $" + string(global.dinheiro));
} else {
    show_debug_message("✗ ERRO: global.dinheiro não existe!");
}