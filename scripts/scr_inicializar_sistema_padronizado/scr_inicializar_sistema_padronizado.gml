/// @function scr_inicializar_sistema_padronizado()
/// @description Inicializa o sistema com padrões estabelecidos
/// @return {undefined}

function scr_inicializar_sistema_padronizado() {
    // ===============================================
    // HEGEMONIA GLOBAL - INICIALIZAÇÃO PADRONIZADA
    // Sistema de inicialização com padrões estabelecidos
    // ===============================================
    
    show_debug_message("🚀 Inicializando sistema padronizado...");
    
    // 1. Inicializar sistema básico
    scr_inicializar_sistema();
    
    // 2. Aplicar padrões de configuração
    scr_aplicar_padroes_configuracao();
    
    // 3. Inicializar sistemas padronizados
    scr_inicializar_sistemas_padronizados();
    
    // 4. Configurar padrões de UI
    scr_configurar_padroes_ui();
    
    // 5. Configurar padrões de gameplay
    scr_configurar_padroes_gameplay();
    
    // 6. Verificar conformidade com padrões
    scr_verificar_padroes();
    
    show_debug_message("✅ Sistema padronizado inicializado com sucesso");
}

/// @function scr_aplicar_padroes_configuracao()
/// @description Aplica padrões de configuração estabelecidos
/// @return {undefined}

function scr_aplicar_padroes_configuracao() {
    show_debug_message("⚙️ Aplicando padrões de configuração...");
    
    // Padrões de performance
    global.fps_target = 60;
    global.fps_minimo = 30;
    global.fps_maximo = 120;
    
    // Padrões de resolução
    global.resolucao_padrao = "1920x1080";
    global.resolucao_minima = "1280x720";
    global.resolucao_maxima = "3840x2160";
    
    // Padrões de áudio
    global.volume_master = 0.8;
    global.volume_musica = 0.6;
    global.volume_efeitos = 0.7;
    global.volume_interface = 0.5;
    
    // Padrões de controle
    global.sensibilidade_mouse = 1.0;
    global.inverter_mouse_y = false;
    global.teclas_personalizadas = ds_map_create();
    
    show_debug_message("✅ Padrões de configuração aplicados");
}

/// @function scr_inicializar_sistemas_padronizados()
/// @description Inicializa sistemas com padrões estabelecidos
/// @return {undefined}

function scr_inicializar_sistemas_padronizados() {
    show_debug_message("🔧 Inicializando sistemas padronizados...");
    
    // Sistema de unidades padronizado
    scr_inicializar_unidades_padronizadas();
    
    // Sistema de construção padronizado
    scr_inicializar_construcao_padronizada();
    
    // Sistema de combate padronizado
    scr_inicializar_combate_padronizado();
    
    // Sistema de economia padronizado
    scr_inicializar_economia_padronizada();
    
    show_debug_message("✅ Sistemas padronizados inicializados");
}

/// @function scr_inicializar_unidades_padronizadas()
/// @description Inicializa sistema de unidades com padrões
/// @return {undefined}

function scr_inicializar_unidades_padronizadas() {
    show_debug_message("⚔️ Inicializando unidades padronizadas...");
    
    // Padrões de unidades terrestres
    global.padroes_terrestres = ds_map_create();
    global.padroes_terrestres[? "velocidade_base"] = 2.0;
    global.padroes_terrestres[? "hp_base"] = 100;
    global.padroes_terrestres[? "dano_base"] = 15;
    global.padroes_terrestres[? "alcance_base"] = 150;
    
    // Padrões de unidades aéreas
    global.padroes_aereos = ds_map_create();
    global.padroes_aereos[? "velocidade_base"] = 4.0;
    global.padroes_aereos[? "hp_base"] = 200;
    global.padroes_aereos[? "dano_base"] = 40;
    global.padroes_aereos[? "alcance_base"] = 450;
    
    // Padrões de unidades navais
    global.padroes_navais = ds_map_create();
    global.padroes_navais[? "velocidade_base"] = 2.5;
    global.padroes_navais[? "hp_base"] = 300;
    global.padroes_navais[? "dano_base"] = 30;
    global.padroes_navais[? "alcance_base"] = 300;
    
    show_debug_message("✅ Unidades padronizadas inicializadas");
}

/// @function scr_inicializar_construcao_padronizada()
/// @description Inicializa sistema de construção com padrões
/// @return {undefined}

function scr_inicializar_construcao_padronizada() {
    show_debug_message("🏗️ Inicializando construção padronizada...");
    
    // Padrões de construção
    global.padroes_construcao = ds_map_create();
    global.padroes_construcao[? "tempo_base"] = 180; // 3 segundos
    global.padroes_construcao[? "custo_base"] = 1000;
    global.padroes_construcao[? "alcance_minimo"] = 50;
    global.padroes_construcao[? "alcance_maximo"] = 200;
    
    // Padrões de edifícios
    global.padroes_edificios = ds_map_create();
    global.padroes_edificios[? "tamanho_padrao"] = 64;
    global.padroes_edificios[? "hp_base"] = 500;
    global.padroes_edificios[? "defesa_base"] = 10;
    
    show_debug_message("✅ Construção padronizada inicializada");
}

/// @function scr_inicializar_combate_padronizado()
/// @description Inicializa sistema de combate com padrões
/// @return {undefined}

function scr_inicializar_combate_padronizado() {
    show_debug_message("⚔️ Inicializando combate padronizado...");
    
    // Padrões de combate
    global.padroes_combate = ds_map_create();
    global.padroes_combate[? "intervalo_ataque"] = 90; // 1.5 segundos
    global.padroes_combate[? "precisao_base"] = 0.8;
    global.padroes_combate[? "critico_chance"] = 0.1;
    global.padroes_combate[? "critico_multiplier"] = 2.0;
    
    // Padrões de dano
    global.padroes_dano = ds_map_create();
    global.padroes_dano[? "terrestre_vs_terrestre"] = 1.0;
    global.padroes_dano[? "aereo_vs_terrestre"] = 1.5;
    global.padroes_dano[? "naval_vs_aereo"] = 0.7;
    global.padroes_dano[? "aereo_vs_naval"] = 1.3;
    
    show_debug_message("✅ Combate padronizado inicializado");
}

/// @function scr_inicializar_economia_padronizada()
/// @description Inicializa sistema de economia com padrões
/// @return {undefined}

function scr_inicializar_economia_padronizada() {
    show_debug_message("💰 Inicializando economia padronizada...");
    
    // Padrões de economia
    global.padroes_economia = ds_map_create();
    global.padroes_economia[? "taxa_juros"] = 0.05;
    global.padroes_economia[? "inflacao"] = 0.02;
    global.padroes_economia[? "impostos"] = 0.15;
    global.padroes_economia[? "subsidios"] = 0.1;
    
    // Padrões de recursos
    global.padroes_recursos = ds_map_create();
    global.padroes_recursos[? "producao_base"] = 10;
    global.padroes_recursos[? "consumo_base"] = 5;
    global.padroes_recursos[? "estoque_maximo"] = 10000;
    global.padroes_recursos[? "estoque_minimo"] = 100;
    
    show_debug_message("✅ Economia padronizada inicializada");
}

/// @function scr_configurar_padroes_ui()
/// @description Configura padrões de UI
/// @return {undefined}

function scr_configurar_padroes_ui() {
    show_debug_message("🎨 Configurando padrões de UI...");
    
    // Padrões de cores
    global.padroes_cores = ds_map_create();
    global.padroes_cores[? "cor_primaria"] = make_color_rgb(0, 100, 200);
    global.padroes_cores[? "cor_secundaria"] = make_color_rgb(200, 200, 200);
    global.padroes_cores[? "cor_destaque"] = make_color_rgb(255, 165, 0);
    global.padroes_cores[? "cor_erro"] = make_color_rgb(255, 0, 0);
    global.padroes_cores[? "cor_sucesso"] = make_color_rgb(0, 255, 0);
    
    // Padrões de fontes
    global.padroes_fontes = ds_map_create();
    global.padroes_fontes[? "fonte_principal"] = fnt_ui_main;
    global.padroes_fontes[? "fonte_secundaria"] = fnt_ui_secondary;
    global.padroes_fontes[? "tamanho_padrao"] = 12;
    global.padroes_fontes[? "tamanho_titulo"] = 16;
    
    // Padrões de layout
    global.padroes_layout = ds_map_create();
    global.padroes_layout[? "margem_padrao"] = 8;
    global.padroes_layout[? "espacamento_padrao"] = 4;
    global.padroes_layout[? "altura_botao"] = 32;
    global.padroes_layout[? "largura_botao"] = 120;
    
    show_debug_message("✅ Padrões de UI configurados");
}

/// @function scr_configurar_padroes_gameplay()
/// @description Configura padrões de gameplay
/// @return {undefined}

function scr_configurar_padroes_gameplay() {
    show_debug_message("🎮 Configurando padrões de gameplay...");
    
    // Padrões de dificuldade
    global.padroes_dificuldade = ds_map_create();
    global.padroes_dificuldade[? "facil"] = 0.7;
    global.padroes_dificuldade[? "normal"] = 1.0;
    global.padroes_dificuldade[? "dificil"] = 1.3;
    global.padroes_dificuldade[? "extremo"] = 1.6;
    
    // Padrões de velocidade
    global.padroes_velocidade = ds_map_create();
    global.padroes_velocidade[? "velocidade_jogo"] = 1.0;
    global.padroes_velocidade[? "velocidade_construcao"] = 1.0;
    global.padroes_velocidade[? "velocidade_pesquisa"] = 1.0;
    global.padroes_velocidade[? "velocidade_combate"] = 1.0;
    
    // Padrões de automação
    global.padroes_automatizacao = ds_map_create();
    global.padroes_automatizacao[? "auto_producao"] = false;
    global.padroes_automatizacao[? "auto_construcao"] = false;
    global.padroes_automatizacao[? "auto_pesquisa"] = false;
    global.padroes_automatizacao[? "auto_combate"] = false;
    
    show_debug_message("✅ Padrões de gameplay configurados");
}

/// @function scr_verificar_padroes()
/// @description Verifica se os padrões estão sendo aplicados corretamente
/// @return {Bool} Retorna true se os padrões estão OK

function scr_verificar_padroes() {
    show_debug_message("🔍 Verificando padrões...");
    
    var _padroes_ok = true;
    
    // Verificar padrões de configuração
    if (global.fps_target < 30 || global.fps_target > 120) {
        show_debug_message("❌ Padrão de FPS inválido");
        _padroes_ok = false;
    }
    
    // Verificar padrões de unidades
    if (!ds_map_exists(global.padroes_terrestres, "velocidade_base")) {
        show_debug_message("❌ Padrões de unidades terrestres não encontrados");
        _padroes_ok = false;
    }
    
    // Verificar padrões de UI
    if (!ds_map_exists(global.padroes_cores, "cor_primaria")) {
        show_debug_message("❌ Padrões de cores não encontrados");
        _padroes_ok = false;
    }
    
    if (_padroes_ok) {
        show_debug_message("✅ Padrões verificados - tudo OK");
    } else {
        show_debug_message("❌ Padrões com problemas detectados");
    }
    
    return _padroes_ok;
}