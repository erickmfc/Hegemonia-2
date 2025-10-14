// =========================================================
// HEGEMONIA GLOBAL - QUARTEL
// Sistema de Criação de Unidades com Lista
// =========================================================

// Verificar se temos variáveis de recrutamento múltiplo
if (!variable_instance_exists(id, "unidades_para_criar")) {
    unidades_para_criar = 1;
}
if (!variable_instance_exists(id, "unidades_criadas")) {
    unidades_criadas = 0;
}

// Incrementar contador de unidades criadas
unidades_criadas++;

show_debug_message("==== UNIDADE " + string(unidades_criadas) + "/" + string(unidades_para_criar) + " PRONTA ====");
show_debug_message("Unidade pronta para o combate!");
show_debug_message("Quartel ID: " + string(id));

// Calcular posição da unidade (espalhar as unidades em formação)
var _offset_x = ((unidades_criadas - 1) mod 3) * 40; // 3 unidades por linha
var _offset_y = floor((unidades_criadas - 1) / 3) * 40; // Novas linhas a cada 3 unidades
var _spawn_x = x + sprite_width + _offset_x;
var _spawn_y = y + sprite_height + _offset_y;

// Criar unidade conforme tipo selecionado (SISTEMA NOVO)
var _unidade_data = ds_list_find_value(unidades_disponiveis, unidade_selecionada);
var _obj_unidade = obj_infantaria; // Padrão

if (_unidade_data != undefined) {
    _obj_unidade = _unidade_data.objeto;
    show_debug_message("Criando unidade: " + _unidade_data.nome + " (Objeto: " + string(_obj_unidade) + ")");
} else {
    show_debug_message("AVISO: Dados da unidade não encontrados, usando infantaria como padrão");
}

var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "Instances", _obj_unidade);

// Verifica se a unidade foi criada com sucesso
if (instance_exists(_unidade_criada)) {
    // A unidade pertence à mesma nação do quartel
    // Verificar se a variável nacao_proprietaria existe antes de usar
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        _unidade_criada.nacao_proprietaria = self.nacao_proprietaria;
    } else {
        // Definir um valor padrão se a variável não existir
        _unidade_criada.nacao_proprietaria = 1; // 1 = jogador
    }
    
    // Incrementar o contador de militares totais
    if (variable_global_exists("militares_totais")) {
        global.militares_totais += 1;
    } else {
        global.militares_totais = 1;
    }
    
    show_debug_message("Unidade criada com sucesso!");
    show_debug_message("Unidade ID: " + string(_unidade_criada));
    show_debug_message("Posição da unidade: (" + string(_unidade_criada.x) + ", " + string(_unidade_criada.y) + ")");
    show_debug_message("Nação da unidade: " + string(_unidade_criada.nacao_proprietaria));
    show_debug_message("Total de militares: " + string(global.militares_totais));
} else {
    show_debug_message("ERRO: Falha ao criar a unidade!");
}

// Verificar se ainda há mais unidades para criar
if (unidades_criadas < unidades_para_criar) {
    // Ainda há mais unidades - reativar o alarme
    alarm[0] = 60; // 1 segundo entre cada unidade (para dar tempo de ver a criação)
    show_debug_message("Próxima unidade em 1 segundo...");
} else {
    // Todas as unidades foram criadas - liberar o quartel
    esta_treinando = false;
    unidades_para_criar = 1; // Reset para próximo uso
    unidades_criadas = 0;    // Reset para próximo uso
    ultimo_recrutamento_tanque = false;
    
    show_debug_message("=== RECRUTAMENTO MÚTIPLO CONCLUÍDO ===");
    show_debug_message("Todas as " + string(unidades_criadas) + " unidades foram criadas!");
    show_debug_message("Quartel liberado para novo recrutamento.");
    show_debug_message("======================================");
}
