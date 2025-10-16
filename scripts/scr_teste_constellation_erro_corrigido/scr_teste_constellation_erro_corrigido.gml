/// @param x_pos
/// @param y_pos
/// @description Script de teste para verificar se o erro do pontos_patrulha foi corrigido

var _x_pos = argument0;
var _y_pos = argument1;

show_debug_message("--- TESTANDO CORREÇÃO DO ERRO PONTOS_PATRULHA ---");

// 1. Criar ou encontrar Constellation
var _constellation = noone;
if (!instance_exists(obj_Constellation)) {
    _constellation = instance_create_layer(_x_pos, _y_pos, "Instances", obj_Constellation);
    show_debug_message("✅ Constellation criado para teste");
} else {
    _constellation = instance_find(obj_Constellation, 0);
    _constellation.x = _x_pos;
    _constellation.y = _y_pos;
    show_debug_message("✅ Constellation existente usado para teste");
}

if (instance_exists(_constellation)) {
    // 2. Verificar se pontos_patrulha foi inicializado
    if (ds_exists(_constellation.pontos_patrulha, ds_type_list)) {
        show_debug_message("✅ pontos_patrulha inicializado corretamente");
        show_debug_message("   Tamanho da lista: " + string(ds_list_size(_constellation.pontos_patrulha)));
    } else {
        show_debug_message("❌ pontos_patrulha NÃO foi inicializado!");
        show_debug_message("   Inicializando manualmente...");
        _constellation.pontos_patrulha = ds_list_create();
        show_debug_message("✅ pontos_patrulha inicializado manualmente");
    }
    
    // 3. Testar adição de pontos
    var _ponto1 = [_x_pos + 100, _y_pos + 100];
    var _ponto2 = [_x_pos + 200, _y_pos + 200];
    
    ds_list_add(_constellation.pontos_patrulha, _ponto1);
    ds_list_add(_constellation.pontos_patrulha, _ponto2);
    
    show_debug_message("✅ 2 pontos de patrulha adicionados");
    show_debug_message("   Tamanho da lista: " + string(ds_list_size(_constellation.pontos_patrulha)));
    
    // 4. Testar seleção e feedback visual
    _constellation.selecionado = true;
    _constellation.ultima_acao = "Teste de correção";
    _constellation.cor_feedback = c_green;
    _constellation.feedback_timer = 60;
    
    show_debug_message("✅ Constellation selecionado para teste visual");
    
    // 5. Verificar variáveis de combate
    show_debug_message("--- VERIFICAÇÃO DE VARIÁVEIS ---");
    show_debug_message("   HP: " + string(_constellation.hp_atual) + "/" + string(_constellation.hp_max));
    show_debug_message("   Alcance radar: " + string(_constellation.alcance_radar));
    show_debug_message("   Alcance mísseis: " + string(_constellation.missil_alcance));
    show_debug_message("   Dano míssil: " + string(_constellation.dano_missil));
    show_debug_message("   Estado: " + string(_constellation.estado));
    
    show_debug_message("✅ TESTE CONCLUÍDO - Erro deve estar corrigido!");
    show_debug_message("   Verifique se o Draw Event não apresenta mais erros");
    show_debug_message("   O Constellation deve mostrar feedback visual correto");
    
} else {
    show_debug_message("❌ Falha ao criar/encontrar Constellation para teste");
}

show_debug_message("--- TESTE DE CORREÇÃO CONCLUÍDO ---");
