/// @function scr_inicializar_sistema_completo()
/// @description Inicializa o sistema completo do jogo com todas as funcionalidades
/// @return {undefined}

function scr_inicializar_sistema_completo() {
    // ===============================================
    // HEGEMONIA GLOBAL - INICIALIZAÇÃO COMPLETA
    // Sistema de inicialização completa do jogo
    // ===============================================
    
    show_debug_message("🚀 Inicializando sistema completo...");
    
    // 1. Inicializar sistema básico
    scr_inicializar_sistema();
    
    // 2. Inicializar sistema de unidades
    scr_inicializar_unidades();
    
    // 3. Inicializar sistema de construção
    scr_inicializar_construcao();
    
    // 4. Inicializar sistema de pesquisa
    scr_inicializar_pesquisa();
    
    // 5. Inicializar sistema de combate
    scr_inicializar_combate();
    
    // 6. Inicializar sistema de economia
    scr_inicializar_economia();
    
    // 7. Inicializar sistema de IA
    scr_inicializar_ia();
    
    // 8. Inicializar sistema de eventos
    scr_inicializar_eventos();
    
    // 9. Inicializar sistema de save/load
    scr_inicializar_save_system();
    
    // 10. Verificar integridade do sistema
    scr_verificar_sistema_completo();
    
    show_debug_message("✅ Sistema completo inicializado com sucesso");
}

/// @function scr_inicializar_unidades()
/// @description Inicializa o sistema de unidades
/// @return {undefined}

function scr_inicializar_unidades() {
    show_debug_message("⚔️ Inicializando sistema de unidades...");
    
    // Inicializar controlador de unidades
    if (!instance_exists(obj_controlador_unidades)) {
        instance_create_layer(0, 0, "Instances", obj_controlador_unidades);
        show_debug_message("✅ Controlador de unidades criado");
    }
    
    // Inicializar variáveis globais de unidades
    global.esperando_alvo_seguir = noone;
    global.definindo_patrulha = noone;
    
    // Configurar limites de população
    global.limite_populacao_total = 1000;
    global.populacao_atual = 0;
    
    show_debug_message("✅ Sistema de unidades inicializado");
}

/// @function scr_inicializar_construcao()
/// @description Inicializa o sistema de construção
/// @return {undefined}

function scr_inicializar_construcao() {
    show_debug_message("🏗️ Inicializando sistema de construção...");
    
    // Inicializar controlador de construção
    if (!instance_exists(obj_controlador_construcao)) {
        instance_create_layer(0, 0, "Instances", obj_controlador_construcao);
        show_debug_message("✅ Controlador de construção criado");
    }
    
    // Configurar sistema de construção
    global.modo_construcao = false;
    global.construindo_agora = noone;
    global.construindo_edificio = noone;
    
    // Configurar tamanho de tiles
    global.tile_size = 32;
    
    show_debug_message("✅ Sistema de construção inicializado");
}

/// @function scr_inicializar_pesquisa()
/// @description Inicializa o sistema de pesquisa
/// @return {undefined}

function scr_inicializar_pesquisa() {
    show_debug_message("🔬 Inicializando sistema de pesquisa...");
    
    // Inicializar sistema de pesquisa
    global.menu_pesquisa_aberto = false;
    global.slots_pesquisa_usados = 0;
    global.slots_pesquisa_total = 5;
    
    // Inicializar timers de pesquisa
    global.research_timers = ds_map_create();
    
    // Configurar tecnologias disponíveis
    scr_configurar_tecnologias();
    
    show_debug_message("✅ Sistema de pesquisa inicializado");
}

/// @function scr_inicializar_combate()
/// @description Inicializa o sistema de combate
/// @return {undefined}

function scr_inicializar_combate() {
    show_debug_message("⚔️ Inicializando sistema de combate...");
    
    // Configurar sistema de combate
    global.modo_combate = false;
    global.unidades_em_combate = ds_list_create();
    
    // Configurar danos base
    global.dano_base_infantaria = 10;
    global.dano_base_tanque = 25;
    global.dano_base_aereo = 40;
    global.dano_base_naval = 30;
    
    show_debug_message("✅ Sistema de combate inicializado");
}

/// @function scr_inicializar_economia()
/// @description Inicializa o sistema de economia
/// @return {undefined}

function scr_inicializar_economia() {
    show_debug_message("💰 Inicializando sistema de economia...");
    
    // Configurar sistema de economia
    global.taxa_juros = 0.05;
    global.inflacao = 0.02;
    global.producao_recursos = ds_map_create();
    
    // Configurar produção base de recursos
    global.producao_recursos[? "Minério"] = 10;
    global.producao_recursos[? "Petróleo"] = 8;
    global.producao_recursos[? "Alumínio"] = 5;
    
    show_debug_message("✅ Sistema de economia inicializado");
}

/// @function scr_inicializar_ia()
/// @description Inicializa o sistema de IA
/// @return {undefined}

function scr_inicializar_ia() {
    show_debug_message("🤖 Inicializando sistema de IA...");
    
    // Configurar sistema de IA
    global.ia_ativa = true;
    global.dificuldade_ia = "extremo"; // AUMENTADO de "normal" para "extremo"
    global.ia_agressividade = 0.9; // AUMENTADO de 0.5 para 0.9
    
    // Inicializar comportamentos de IA
    global.ia_comportamentos = ds_map_create();
    global.ia_comportamentos[? "defensivo"] = 0.1; // REDUZIDO de 0.3 para 0.1
    global.ia_comportamentos[? "agressivo"] = 0.9; // AUMENTADO de 0.7 para 0.9
    
    show_debug_message("✅ Sistema de IA inicializado");
}

/// @function scr_inicializar_eventos()
/// @description Inicializa o sistema de eventos
/// @return {undefined}

function scr_inicializar_eventos() {
    show_debug_message("📅 Inicializando sistema de eventos...");
    
    // Configurar sistema de eventos
    global.eventos_ativos = ds_list_create();
    global.eventos_pendentes = ds_queue_create();
    
    // Configurar eventos base
    scr_configurar_eventos_base();
    
    show_debug_message("✅ Sistema de eventos inicializado");
}

/// @function scr_inicializar_save_system()
/// @description Inicializa o sistema de save/load
/// @return {undefined}

function scr_inicializar_save_system() {
    show_debug_message("💾 Inicializando sistema de save/load...");
    
    // Configurar sistema de save
    global.save_slots = 5;
    global.auto_save_interval = 300; // 5 minutos
    global.auto_save_timer = 0;
    
    // Configurar dados de save
    global.save_data = ds_map_create();
    
    show_debug_message("✅ Sistema de save/load inicializado");
}

/// @function scr_configurar_tecnologias()
/// @description Configura as tecnologias disponíveis
/// @return {undefined}

function scr_configurar_tecnologias() {
    // Configurar tecnologias de pesquisa
    global.tecnologias_disponiveis = ds_map_create();
    
    // Tecnologias militares
    global.tecnologias_disponiveis[? "arma_avancada"] = false;
    global.tecnologias_disponiveis[? "blindagem_melhorada"] = false;
    global.tecnologias_disponiveis[? "radar_avancado"] = false;
    
    // Tecnologias civis
    global.tecnologias_disponiveis[? "construcao_rapida"] = false;
    global.tecnologias_disponiveis[? "economia_eficiente"] = false;
    
    show_debug_message("✅ Tecnologias configuradas");
}

/// @function scr_configurar_eventos_base()
/// @description Configura os eventos base do jogo
/// @return {undefined}

function scr_configurar_eventos_base() {
    // Configurar eventos base
    global.eventos_base = ds_map_create();
    
    // Eventos econômicos
    global.eventos_base[? "boom_economico"] = "Boom Econômico: +20% produção de recursos";
    global.eventos_base[? "recessao"] = "Recessão: -15% produção de recursos";
    
    // Eventos militares
    global.eventos_base[? "mobilizacao"] = "Mobilização: +25% velocidade de produção militar";
    global.eventos_base[? "paz"] = "Paz: -30% custos de manutenção";
    
    show_debug_message("✅ Eventos base configurados");
}

/// @function scr_verificar_sistema_completo()
/// @description Verifica se o sistema completo está funcionando
/// @return {Bool} Retorna true se tudo está OK

function scr_verificar_sistema_completo() {
    show_debug_message("🔍 Verificando sistema completo...");
    
    var _sistema_ok = true;
    
    // Verificar cada subsistema
    if (!scr_verificar_sistema()) {
        _sistema_ok = false;
    }
    
    if (!instance_exists(obj_controlador_unidades)) {
        show_debug_message("❌ Controlador de unidades não encontrado");
        _sistema_ok = false;
    }
    
    if (!instance_exists(obj_controlador_construcao)) {
        show_debug_message("❌ Controlador de construção não encontrado");
        _sistema_ok = false;
    }
    
    if (!ds_map_exists(global.research_timers, "Minério")) {
        show_debug_message("❌ Sistema de pesquisa não inicializado");
        _sistema_ok = false;
    }
    
    if (_sistema_ok) {
        show_debug_message("✅ Sistema completo verificado - tudo OK");
    } else {
        show_debug_message("❌ Sistema completo com problemas detectados");
    }
    
    return _sistema_ok;
}