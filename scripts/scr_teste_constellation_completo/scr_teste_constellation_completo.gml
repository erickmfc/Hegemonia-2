/// @param x_pos
/// @param y_pos
/// @description Script de teste completo para o obj_Constellation funcional

var _x_pos = argument0;
var _y_pos = argument1;

show_debug_message("--- INICIANDO TESTE COMPLETO DO CONSTELLATION ---");

// 1. Encontrar ou criar uma instância do Constellation
var _constellation = noone;
if (!instance_exists(obj_Constellation)) {
    _constellation = instance_create_layer(_x_pos, _y_pos, "Instances", obj_Constellation);
    show_debug_message("Criado obj_Constellation de teste em (" + string(_x_pos) + ", " + string(_y_pos) + ")");
} else {
    _constellation = instance_find(obj_Constellation, 0);
    _constellation.x = _x_pos;
    _constellation.y = _y_pos;
    show_debug_message("Usando obj_Constellation existente em (" + string(_x_pos) + ", " + string(_y_pos) + ")");
}

if (instance_exists(_constellation)) {
    // 2. Simular seleção
    _constellation.selecionado = true;
    _constellation.ultima_acao = "Teste iniciado";
    _constellation.cor_feedback = c_blue;
    _constellation.feedback_timer = 60;
    
    show_debug_message("✅ Constellation selecionado para teste!");

    // 3. Testar movimento
    _constellation.destino_x = _x_pos + 200;
    _constellation.destino_y = _y_pos + 100;
    _constellation.estado = "movendo";
    show_debug_message("✅ Constellation: Ordem de movimento para (" + string(_constellation.destino_x) + ", " + string(_constellation.destino_y) + ")");

    // 4. Adicionar pontos de patrulha
    var _ponto1 = [_x_pos + 300, _y_pos + 200];
    var _ponto2 = [_x_pos + 100, _y_pos + 300];
    var _ponto3 = [_x_pos - 100, _y_pos + 100];
    
    ds_list_add(_constellation.pontos_patrulha, _ponto1);
    ds_list_add(_constellation.pontos_patrulha, _ponto2);
    ds_list_add(_constellation.pontos_patrulha, _ponto3);
    
    show_debug_message("✅ Constellation: 3 pontos de patrulha adicionados.");

    // 5. Testar patrulha
    _constellation.estado = "patrulhando";
    _constellation.indice_patrulha_atual = 0;
    show_debug_message("✅ Constellation: Patrulha iniciada.");

    // 6. Criar um alvo inimigo para teste de combate
    var _alvo_teste = noone;
    if (!instance_exists(obj_inimigo)) {
        _alvo_teste = instance_create_layer(_x_pos + 400, _y_pos + 400, "Instances", obj_inimigo);
        _alvo_teste.nacao_proprietaria = 2; // Inimigo
        show_debug_message("Criado obj_inimigo de teste para Constellation.");
    } else {
        _alvo_teste = instance_find(obj_inimigo, 0);
        _alvo_teste.x = _x_pos + 400;
        _alvo_teste.y = _y_pos + 400;
        _alvo_teste.nacao_proprietaria = 2; // Inimigo
    }

    if (instance_exists(_alvo_teste)) {
        _constellation.alvo_unidade = _alvo_teste;
        _constellation.estado = "atacando";
        show_debug_message("✅ Constellation: Alvo inimigo definido e estado de ataque ativado.");
        show_debug_message("   Distância ao alvo: " + string(round(point_distance(_constellation.x, _constellation.y, _alvo_teste.x, _alvo_teste.y))) + "px");
        show_debug_message("   Alcance de mísseis: " + string(_constellation.missil_alcance) + "px");
    } else {
        show_debug_message("❌ Constellation: Não foi possível criar/encontrar alvo inimigo para teste de ataque.");
    }

    // 7. Mostrar informações do sistema
    show_debug_message("--- INFORMAÇÕES DO SISTEMA CONSTELLATION ---");
    show_debug_message("   HP: " + string(_constellation.hp_atual) + "/" + string(_constellation.hp_max));
    show_debug_message("   Velocidade: " + string(_constellation.velocidade_movimento));
    show_debug_message("   Alcance radar: " + string(_constellation.alcance_radar));
    show_debug_message("   Alcance mísseis: " + string(_constellation.missil_alcance));
    show_debug_message("   Dano míssil: " + string(_constellation.dano_missil));
    show_debug_message("   Tempo recarga: " + string(_constellation.reload_time) + " frames");
    show_debug_message("   Pontos patrulha: " + string(ds_list_size(_constellation.pontos_patrulha)));

    // 8. Instruções para o usuário
    show_debug_message("--- INSTRUÇÕES DE TESTE ---");
    show_debug_message("1. O Constellation está selecionado (círculo azul)");
    show_debug_message("2. Use as teclas para testar:");
    show_debug_message("   - [S]: Parar");
    show_debug_message("   - [A]: Atacar inimigo próximo");
    show_debug_message("   - [P]: Iniciar patrulha");
    show_debug_message("3. Use o mouse para testar:");
    show_debug_message("   - Clique esquerdo: Adicionar ponto de patrulha");
    show_debug_message("   - Clique direito: Mover para posição");
    show_debug_message("4. Observe o feedback visual:");
    show_debug_message("   - Círculo azul: Selecionado");
    show_debug_message("   - Linha ciano: Movimento");
    show_debug_message("   - Linha vermelha: Ataque");
    show_debug_message("   - Círculos azuis: Pontos de patrulha");
    show_debug_message("   - Círculo vermelho: Alcance de mísseis");
    show_debug_message("   - Círculo azul grande: Alcance de radar");

} else {
    show_debug_message("❌ Falha ao criar/encontrar obj_Constellation para teste.");
}

show_debug_message("--- TESTE COMPLETO DO CONSTELLATION CONCLUÍDO ---");
show_debug_message("O Constellation está pronto para demonstração!");
