// ===============================================
// TESTE MANUAL DE CRIAÇÃO DE LANCHA PATRULHA
// ===============================================

show_debug_message("🧪 INICIANDO TESTE MANUAL DE CRIAÇÃO");

// Verificar se objeto existe
if (object_exists(obj_lancha_patrulha)) {
    show_debug_message("✅ obj_lancha_patrulha existe");
    
    // Tentar criar lancha em posição fixa
    var _test_x = 300;
    var _test_y = 300;
    
    show_debug_message("📍 Tentando criar lancha em: (" + string(_test_x) + ", " + string(_test_y) + ")");
    
    var _lancha_criada = instance_create(_test_x, _test_y, obj_lancha_patrulha);
    
    if (instance_exists(_lancha_criada)) {
        show_debug_message("✅ Lancha criada com sucesso! ID: " + string(_lancha_criada));
        
        // Verificar propriedades
        show_debug_message("🔍 HP: " + string(_lancha_criada.hp_atual) + "/" + string(_lancha_criada.hp_max));
        show_debug_message("🔍 Posição: (" + string(_lancha_criada.x) + ", " + string(_lancha_criada.y) + ")");
        show_debug_message("🔍 Nação: " + string(_lancha_criada.nacao_proprietaria));
        
    } else {
        show_debug_message("❌ ERRO: Falha ao criar lancha!");
    }
    
} else {
    show_debug_message("❌ ERRO: obj_lancha_patrulha não existe!");
}

// Verificar quantas lanchas existem na sala
var _total_lanchas = instance_number(obj_lancha_patrulha);
show_debug_message("📊 Total de lanchas na sala: " + string(_total_lanchas));

show_debug_message("🧪 TESTE MANUAL CONCLUÍDO");
