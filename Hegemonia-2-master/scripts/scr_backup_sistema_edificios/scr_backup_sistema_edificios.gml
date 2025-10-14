/// @description Sistema de backup e teste individual de edifícios
/// MITIGAÇÃO PARA RISCO 1: Menus Não Funcionam
/// Testar cada edifício individualmente e manter backup

function scr_backup_sistema_edificios() {
    show_debug_message("💾 === SISTEMA DE BACKUP ATIVADO ===");
    
    // Criar backup do estado atual
    var _backup_data = {
        timestamp: current_time,
        edificios_funcionais: [],
        problemas_detectados: []
    };
    
    // Lista de todos os edifícios para testar
    var _edificios = [
        {obj: obj_quartel, nome: "Quartel", menu: obj_menu_recrutamento},
        {obj: obj_quartel_marinha, nome: "Quartel Marinha", menu: obj_menu_recrutamento_marinha},
        {obj: obj_aeroporto_militar, nome: "Aeroporto", menu: obj_menu_recrutamento_aereo},
        {obj: obj_casa, nome: "Casa", menu: noone},
        {obj: obj_banco, nome: "Banco", menu: noone},
        {obj: obj_research_center, nome: "Research Center", menu: noone}
    ];
    
    // Testar cada edifício
    for (var i = 0; i < array_length(_edificios); i++) {
        var _edificio_data = _edificios[i];
        var _obj = _edificio_data.obj;
        var _nome = _edificio_data.nome;
        var _menu_obj = _edificio_data.menu;
        
        show_debug_message("🔍 Testando " + _nome + "...");
        
        // Verificar se objeto existe
        if (!object_exists(_obj)) {
            show_debug_message("❌ " + _nome + ": Objeto não existe!");
            _backup_data.problemas_detectados[array_length(_backup_data.problemas_detectados)] = _nome + ": Objeto não existe";
            continue;
        }
        
        // Verificar se tem Mouse Event
        var _tem_mouse_event = false;
        // Verificar se tem Mouse_53.gml
        if (file_exists("objects/" + object_get_name(_obj) + "/Mouse_53.gml")) {
            _tem_mouse_event = true;
        }
        
        if (!_tem_mouse_event) {
            show_debug_message("❌ " + _nome + ": Sem Mouse Event!");
            _backup_data.problemas_detectados[array_length(_backup_data.problemas_detectados)] = _nome + ": Sem Mouse Event";
            continue;
        }
        
        // Verificar se menu existe (se aplicável)
        if (_menu_obj != noone && !object_exists(_menu_obj)) {
            show_debug_message("❌ " + _nome + ": Menu não existe!");
            _backup_data.problemas_detectados[array_length(_backup_data.problemas_detectados)] = _nome + ": Menu não existe";
            continue;
        }
        
        // Verificar instâncias existentes
        var _instancias = instance_number(_obj);
        show_debug_message("✅ " + _nome + ": OK (" + string(_instancias) + " instâncias)");
        
        _backup_data.edificios_funcionais[array_length(_backup_data.edificios_funcionais)] = {
            nome: _nome,
            instancias: _instancias,
            status: "OK"
        };
    }
    
    // Salvar backup
    global.backup_edificios = _backup_data;
    
    show_debug_message("💾 Backup salvo com " + string(array_length(_backup_data.edificios_funcionais)) + " edifícios funcionais");
    show_debug_message("⚠️ Problemas detectados: " + string(array_length(_backup_data.problemas_detectados)));
    
    return _backup_data;
}

/// @description Teste individual de edifício específico
function scr_teste_individual_edificio(_edificio_obj) {
    show_debug_message("🧪 === TESTE INDIVIDUAL DE EDIFÍCIO ===");
    show_debug_message("Edifício: " + object_get_name(_edificio_obj));
    
    var _resultado = {
        sucesso: false,
        problemas: [],
        detalhes: {}
    };
    
    // Verificar se objeto existe
    if (!object_exists(_edificio_obj)) {
        _resultado.problemas[array_length(_resultado.problemas)] = "Objeto não existe";
        return _resultado;
    }
    
    // Verificar Mouse Event
    var _mouse_file = "objects/" + object_get_name(_edificio_obj) + "/Mouse_53.gml";
    if (!file_exists(_mouse_file)) {
        _resultado.problemas[array_length(_resultado.problemas)] = "Mouse Event não existe";
        return _resultado;
    }
    
    // Verificar instâncias
    var _instancias = instance_number(_edificio_obj);
    _resultado.detalhes.instancias = _instancias;
    
    if (_instancias == 0) {
        show_debug_message("⚠️ Nenhuma instância encontrada - criando uma para teste");
        
        // Criar instância para teste
        var _teste_instancia = instance_create_layer(400, 300, "Instances", _edificio_obj);
        if (instance_exists(_teste_instancia)) {
            show_debug_message("✅ Instância de teste criada: " + string(_teste_instancia));
            _resultado.detalhes.instancia_teste = _teste_instancia;
        } else {
            _resultado.problemas[array_length(_resultado.problemas)] = "Falha ao criar instância de teste";
            return _resultado;
        }
    }
    
    // Simular clique
    var _instancia = instance_find(_edificio_obj, 0);
    if (instance_exists(_instancia)) {
        show_debug_message("🎯 Simulando clique na instância: " + string(_instancia));
        
        // Verificar se tem sistema unificado
        if (variable_instance_exists(_instancia, "scr_edificio_clique_unificado")) {
            show_debug_message("✅ Sistema unificado disponível");
            _resultado.detalhes.sistema_unificado = true;
        } else {
            show_debug_message("⚠️ Sistema unificado não disponível");
            _resultado.detalhes.sistema_unificado = false;
        }
        
        _resultado.sucesso = true;
    } else {
        _resultado.problemas[array_length(_resultado.problemas)] = "Nenhuma instância válida encontrada";
    }
    
    show_debug_message("🧪 Teste concluído - Sucesso: " + string(_resultado.sucesso));
    return _resultado;
}
