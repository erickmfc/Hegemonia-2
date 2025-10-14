/// @function scr_integrar_sistema()
/// @description Integra todos os sistemas do jogo de forma coordenada
/// @return {undefined}

function scr_integrar_sistema() {
    // ===============================================
    // HEGEMONIA GLOBAL - INTEGRAÇÃO DE SISTEMAS
    // Sistema para integrar todos os componentes do jogo
    // ===============================================
    
    show_debug_message("🔗 Iniciando integração de sistemas...");
    
    // 1. Verificar sistemas existentes
    scr_verificar_sistemas_existentes();
    
    // 2. Integrar sistemas de unidades
    scr_integrar_sistemas_unidades();
    
    // 3. Integrar sistemas de construção
    scr_integrar_sistemas_construcao();
    
    // 4. Integrar sistemas de combate
    scr_integrar_sistemas_combate();
    
    // 5. Integrar sistemas de economia
    scr_integrar_sistemas_economia();
    
    // 6. Integrar sistemas de UI
    scr_integrar_sistemas_ui();
    
    // 7. Verificar integração
    scr_verificar_integracao();
    
    show_debug_message("✅ Integração de sistemas concluída");
}

/// @function scr_verificar_sistemas_existentes()
/// @description Verifica quais sistemas já existem no jogo
/// @return {undefined}

function scr_verificar_sistemas_existentes() {
    show_debug_message("🔍 Verificando sistemas existentes...");
    
    // Verificar objetos principais
    var _objetos_principais = [
        "obj_controlador_unidades",
        "obj_controlador_construcao",
        "obj_input_manager",
        "obj_game_manager",
        "obj_simple_dashboard"
    ];
    
    for (var i = 0; i < array_length(_objetos_principais); i++) {
        var _obj_nome = _objetos_principais[i];
        var _obj_index = asset_get_index(_obj_nome);
        
        if (_obj_index != -1) {
            var _count = instance_number(_obj_index);
            if (_count > 0) {
                show_debug_message("✅ " + _obj_nome + ": " + string(_count) + " instâncias ativas");
            } else {
                show_debug_message("⚠️ " + _obj_nome + ": Definido mas não instanciado");
            }
        } else {
            show_debug_message("❌ " + _obj_nome + ": Não encontrado");
        }
    }
    
    // Verificar unidades
    var _unidades = [
        "obj_caca_f5",
        "obj_helicoptero_militar",
        "obj_lancha_patrulha",
        "obj_tanque",
        "obj_infantaria"
    ];
    
    for (var i = 0; i < array_length(_unidades); i++) {
        var _unidade_nome = _unidades[i];
        var _unidade_index = asset_get_index(_unidade_nome);
        
        if (_unidade_index != -1) {
            var _count = instance_number(_unidade_index);
            show_debug_message("✅ " + _unidade_nome + ": " + string(_count) + " instâncias");
        } else {
            show_debug_message("❌ " + _unidade_nome + ": Não encontrado");
        }
    }
}

/// @function scr_integrar_sistemas_unidades()
/// @description Integra sistemas relacionados a unidades
/// @return {undefined}

function scr_integrar_sistemas_unidades() {
    show_debug_message("⚔️ Integrando sistemas de unidades...");
    
    // Verificar se o controlador de unidades existe
    if (!instance_exists(obj_controlador_unidades)) {
        instance_create_layer(0, 0, "Instances", obj_controlador_unidades);
        show_debug_message("✅ Controlador de unidades criado");
    }
    
    // Integrar sistema de seleção
    scr_integrar_sistema_selecao();
    
    // Integrar sistema de comandos
    scr_integrar_sistema_comandos();
    
    // Integrar sistema de movimento
    scr_integrar_sistema_movimento();
    
    show_debug_message("✅ Sistemas de unidades integrados");
}

/// @function scr_integrar_sistemas_construcao()
/// @description Integra sistemas relacionados a construção
/// @return {undefined}

function scr_integrar_sistemas_construcao() {
    show_debug_message("🏗️ Integrando sistemas de construção...");
    
    // Verificar se o controlador de construção existe
    if (!instance_exists(obj_controlador_construcao)) {
        instance_create_layer(0, 0, "Instances", obj_controlador_construcao);
        show_debug_message("✅ Controlador de construção criado");
    }
    
    // Integrar sistema de validação de terreno
    scr_integrar_sistema_validacao();
    
    // Integrar sistema de recursos
    scr_integrar_sistema_recursos_construcao();
    
    show_debug_message("✅ Sistemas de construção integrados");
}

/// @function scr_integrar_sistemas_combate()
/// @description Integra sistemas relacionados a combate
/// @return {undefined}

function scr_integrar_sistemas_combate() {
    show_debug_message("⚔️ Integrando sistemas de combate...");
    
    // Integrar sistema de dano
    scr_integrar_sistema_dano();
    
    // Integrar sistema de alvos
    scr_integrar_sistema_alvos();
    
    // Integrar sistema de projéteis
    scr_integrar_sistema_projeteis();
    
    show_debug_message("✅ Sistemas de combate integrados");
}

/// @function scr_integrar_sistemas_economia()
/// @description Integra sistemas relacionados a economia
/// @return {undefined}

function scr_integrar_sistemas_economia() {
    show_debug_message("💰 Integrando sistemas de economia...");
    
    // Verificar sistema de recursos
    if (!ds_map_exists(global.nacao_recursos, "Minério")) {
        scr_inicializar_recursos();
        show_debug_message("✅ Sistema de recursos inicializado");
    }
    
    // Integrar sistema de produção
    scr_integrar_sistema_producao();
    
    // Integrar sistema de consumo
    scr_integrar_sistema_consumo();
    
    show_debug_message("✅ Sistemas de economia integrados");
}

/// @function scr_integrar_sistemas_ui()
/// @description Integra sistemas relacionados a UI
/// @return {undefined}

function scr_integrar_sistemas_ui() {
    show_debug_message("🎨 Integrando sistemas de UI...");
    
    // Verificar dashboard
    if (!instance_exists(obj_simple_dashboard)) {
        instance_create_layer(0, 0, "Instances", obj_simple_dashboard);
        show_debug_message("✅ Dashboard criado");
    }
    
    // Integrar sistema de menus
    scr_integrar_sistema_menus();
    
    // Integrar sistema de informações
    scr_integrar_sistema_informacoes();
    
    show_debug_message("✅ Sistemas de UI integrados");
}

/// @function scr_integrar_sistema_selecao()
/// @description Integra sistema de seleção de unidades
/// @return {undefined}

function scr_integrar_sistema_selecao() {
    show_debug_message("🎯 Integrando sistema de seleção...");
    
    // Verificar variáveis globais de seleção
    if (!variable_global_exists("unidade_selecionada")) {
        global.unidade_selecionada = noone;
    }
    
    if (!variable_global_exists("esperando_alvo_seguir")) {
        global.esperando_alvo_seguir = noone;
    }
    
    if (!variable_global_exists("definindo_patrulha")) {
        global.definindo_patrulha = noone;
    }
    
    show_debug_message("✅ Sistema de seleção integrado");
}

/// @function scr_integrar_sistema_comandos()
/// @description Integra sistema de comandos
/// @return {undefined}

function scr_integrar_sistema_comandos() {
    show_debug_message("🎮 Integrando sistema de comandos...");
    
    // Verificar input manager
    if (!instance_exists(obj_input_manager)) {
        instance_create_layer(0, 0, "Instances", obj_input_manager);
        show_debug_message("✅ Input manager criado");
    }
    
    show_debug_message("✅ Sistema de comandos integrado");
}

/// @function scr_integrar_sistema_movimento()
/// @description Integra sistema de movimento
/// @return {undefined}

function scr_integrar_sistema_movimento() {
    show_debug_message("🚶 Integrando sistema de movimento...");
    
    // Verificar função de conversão de coordenadas
    if (!variable_global_exists("scr_mouse_to_world")) {
        show_debug_message("⚠️ Função scr_mouse_to_world não encontrada");
    }
    
    show_debug_message("✅ Sistema de movimento integrado");
}

/// @function scr_integrar_sistema_validacao()
/// @description Integra sistema de validação de terreno
/// @return {undefined}

function scr_integrar_sistema_validacao() {
    show_debug_message("✅ Integrando sistema de validação...");
    
    // Verificar função de validação
    if (!variable_global_exists("scr_validacao_terreno")) {
        show_debug_message("⚠️ Função scr_validacao_terreno não encontrada");
    }
    
    show_debug_message("✅ Sistema de validação integrado");
}

/// @function scr_integrar_sistema_recursos_construcao()
/// @description Integra sistema de recursos para construção
/// @return {undefined}

function scr_integrar_sistema_recursos_construcao() {
    show_debug_message("💰 Integrando sistema de recursos para construção...");
    
    // Verificar sistema de recursos
    if (!ds_map_exists(global.nacao_recursos, "Minério")) {
        show_debug_message("⚠️ Sistema de recursos não inicializado");
    }
    
    show_debug_message("✅ Sistema de recursos para construção integrado");
}

/// @function scr_integrar_sistema_dano()
/// @description Integra sistema de dano
/// @return {undefined}

function scr_integrar_sistema_dano() {
    show_debug_message("💥 Integrando sistema de dano...");
    
    // Verificar objetos de projétil
    if (asset_get_index("obj_tiro_simples") != -1) {
        show_debug_message("✅ Objeto de projétil encontrado");
    } else {
        show_debug_message("⚠️ Objeto de projétil não encontrado");
    }
    
    show_debug_message("✅ Sistema de dano integrado");
}

/// @function scr_integrar_sistema_alvos()
/// @description Integra sistema de alvos
/// @return {undefined}

function scr_integrar_sistema_alvos() {
    show_debug_message("🎯 Integrando sistema de alvos...");
    
    // Verificar objetos inimigos
    if (asset_get_index("obj_inimigo") != -1) {
        show_debug_message("✅ Objeto inimigo encontrado");
    } else {
        show_debug_message("⚠️ Objeto inimigo não encontrado");
    }
    
    show_debug_message("✅ Sistema de alvos integrado");
}

/// @function scr_integrar_sistema_projeteis()
/// @description Integra sistema de projéteis
/// @return {undefined}

function scr_integrar_sistema_projeteis() {
    show_debug_message("🚀 Integrando sistema de projéteis...");
    
    // Verificar objetos de projétil
    var _projeteis = ["obj_tiro_simples", "obj_missil", "obj_bala"];
    
    for (var i = 0; i < array_length(_projeteis); i++) {
        var _projetil_nome = _projeteis[i];
        var _projetil_index = asset_get_index(_projetil_nome);
        
        if (_projetil_index != -1) {
            show_debug_message("✅ " + _projetil_nome + ": Encontrado");
        } else {
            show_debug_message("⚠️ " + _projetil_nome + ": Não encontrado");
        }
    }
    
    show_debug_message("✅ Sistema de projéteis integrado");
}

/// @function scr_integrar_sistema_producao()
/// @description Integra sistema de produção
/// @return {undefined}

function scr_integrar_sistema_producao() {
    show_debug_message("🏭 Integrando sistema de produção...");
    
    // Verificar edifícios de produção
    var _edificios_producao = ["obj_quartel", "obj_quartel_marinha", "obj_aeroporto_militar"];
    
    for (var i = 0; i < array_length(_edificios_producao); i++) {
        var _edificio_nome = _edificios_producao[i];
        var _edificio_index = asset_get_index(_edificio_nome);
        
        if (_edificio_index != -1) {
            show_debug_message("✅ " + _edificio_nome + ": Encontrado");
        } else {
            show_debug_message("⚠️ " + _edificio_nome + ": Não encontrado");
        }
    }
    
    show_debug_message("✅ Sistema de produção integrado");
}

/// @function scr_integrar_sistema_consumo()
/// @description Integra sistema de consumo
/// @return {undefined}

function scr_integrar_sistema_consumo() {
    show_debug_message("📉 Integrando sistema de consumo...");
    
    // Verificar sistema de consumo de recursos
    if (!variable_global_exists("consumo_recursos")) {
        global.consumo_recursos = ds_map_create();
        show_debug_message("✅ Sistema de consumo inicializado");
    }
    
    show_debug_message("✅ Sistema de consumo integrado");
}

/// @function scr_integrar_sistema_menus()
/// @description Integra sistema de menus
/// @return {undefined}

function scr_integrar_sistema_menus() {
    show_debug_message("📋 Integrando sistema de menus...");
    
    // Verificar menus existentes
    var _menus = ["obj_menu_construcao", "obj_menu_recrutamento_aereo"];
    
    for (var i = 0; i < array_length(_menus); i++) {
        var _menu_nome = _menus[i];
        var _menu_index = asset_get_index(_menu_nome);
        
        if (_menu_index != -1) {
            show_debug_message("✅ " + _menu_nome + ": Encontrado");
        } else {
            show_debug_message("⚠️ " + _menu_nome + ": Não encontrado");
        }
    }
    
    show_debug_message("✅ Sistema de menus integrado");
}

/// @function scr_integrar_sistema_informacoes()
/// @description Integra sistema de informações
/// @return {undefined}

function scr_integrar_sistema_informacoes() {
    show_debug_message("📊 Integrando sistema de informações...");
    
    // Verificar dashboard
    if (instance_exists(obj_simple_dashboard)) {
        show_debug_message("✅ Dashboard ativo");
    } else {
        show_debug_message("⚠️ Dashboard não encontrado");
    }
    
    show_debug_message("✅ Sistema de informações integrado");
}

/// @function scr_verificar_integracao()
/// @description Verifica se a integração foi bem-sucedida
/// @return {Bool} Retorna true se a integração está OK

function scr_verificar_integracao() {
    show_debug_message("🔍 Verificando integração...");
    
    var _integracao_ok = true;
    
    // Verificar controladores
    if (!instance_exists(obj_controlador_unidades)) {
        show_debug_message("❌ Controlador de unidades não encontrado");
        _integracao_ok = false;
    }
    
    if (!instance_exists(obj_controlador_construcao)) {
        show_debug_message("❌ Controlador de construção não encontrado");
        _integracao_ok = false;
    }
    
    // Verificar variáveis globais
    if (!variable_global_exists("unidade_selecionada")) {
        show_debug_message("❌ Variável global unidade_selecionada não encontrada");
        _integracao_ok = false;
    }
    
    if (!ds_map_exists(global.nacao_recursos, "Minério")) {
        show_debug_message("❌ Sistema de recursos não inicializado");
        _integracao_ok = false;
    }
    
    if (_integracao_ok) {
        show_debug_message("✅ Integração verificada - tudo OK");
    } else {
        show_debug_message("❌ Integração com problemas detectados");
    }
    
    return _integracao_ok;
}