// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema de Visualização Independente
// ===============================================

// Desenhar o quartel
draw_self();

// === INDICADOR VISUAL DE SELEÇÃO ===
if (selecionado) {
    // Destacar visualmente o quartel selecionado
    image_blend = make_color_rgb(150, 200, 255); // ✅ Azul mais claro quando selecionado
} else {
    image_blend = make_color_rgb(100, 150, 255); // ✅ Azul marinho normal
}

// === INDICADOR DE PRODUÇÃO (IGUAL AO QUARTEL MILITAR) ===
if (esta_treinando || produzindo) {
    // Desenhar barra de progresso
    var _barra_x = x - 20;
    var _barra_y = y - 30;
    var _barra_w = 40;
    var _barra_h = 5;
    
    // Fundo da barra
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
    
    // ✅ CORREÇÃO: Obter dados da unidade atual de unidades_disponiveis usando o índice da fila
    var _tempo_total = 180; // Tempo padrão (3 segundos)
    var _progresso = 0;
    
    if (ds_exists(fila_recrutamento, ds_type_queue) && !ds_queue_empty(fila_recrutamento)) {
        var _item_fila = ds_queue_head(fila_recrutamento);
        
        // ✅ CORREÇÃO: Obter índice válido (função inline para garantir funcionamento)
        var _idx_valido = -1;
        if (is_real(_item_fila) || is_int32(_item_fila)) {
            // É um número (índice válido)
            if (ds_exists(unidades_disponiveis, ds_type_list)) {
                if (_item_fila >= 0 && _item_fila < ds_list_size(unidades_disponiveis)) {
                    _idx_valido = _item_fila;
                }
            }
        } else if (is_struct(_item_fila)) {
            // É uma estrutura - procurar na lista
            if (ds_exists(unidades_disponiveis, ds_type_list)) {
                for (var _i = 0; _i < ds_list_size(unidades_disponiveis); _i++) {
                    var _data = ds_list_find_value(unidades_disponiveis, _i);
                    if (is_struct(_data)) {
                        if (variable_struct_exists(_data, "objeto") && variable_struct_exists(_item_fila, "objeto")) {
                            if (_data.objeto == _item_fila.objeto) {
                                _idx_valido = _i;
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        // Se encontrou um índice válido, obter os dados da unidade
        if (_idx_valido >= 0 && variable_instance_exists(id, "unidades_disponiveis")) {
            if (_idx_valido < ds_list_size(unidades_disponiveis)) {
                var _unidade_data = ds_list_find_value(unidades_disponiveis, _idx_valido);
                if (is_struct(_unidade_data) && variable_struct_exists(_unidade_data, "tempo_treino")) {
                    _tempo_total = _unidade_data.tempo_treino;
                }
            }
        }
        
        // Calcular progresso usando tempo_treinamento_restante
        if (variable_instance_exists(id, "tempo_treinamento_restante")) {
            _progresso = clamp(1 - (tempo_treinamento_restante / _tempo_total), 0, 1);
        } else if (variable_instance_exists(id, "timer_producao")) {
            _progresso = clamp(1 - (timer_producao / _tempo_total), 0, 1);
        }
    }
    
    // Limitar progresso entre 0 e 1
    _progresso = clamp(_progresso, 0, 1);
    
    // Desenhar barra de progresso
    draw_set_color(c_blue);
    draw_rectangle(_barra_x, _barra_y, _barra_x + (_barra_w * _progresso), _barra_y + _barra_h, false);
    
    // Resetar cor
    draw_set_color(c_white);
}

// === BARRA DE VIDA ===
// ✅ CORREÇÃO: Sempre mostrar barra de vida dos quarteis
if (true) {  // Sempre mostrar
    var _barra_x = x - barra_vida_largura / 2;
    var _barra_y = y - sprite_height / 2 - 20;
    var _porcentagem = hp_atual / hp_max;
    var _barra_largura_preenchida = barra_vida_largura * _porcentagem;
    
    // Fundo preto
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(_barra_x, _barra_y, _barra_x + barra_vida_largura, _barra_y + barra_vida_altura, false);
    
    // Cor baseada em vida
    if (_porcentagem > 0.5) {
        draw_set_color(c_lime);
    } else if (_porcentagem > 0.25) {
        draw_set_color(c_yellow);
    } else {
        draw_set_color(c_red);
    }
    
    draw_set_alpha(1.0);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_largura_preenchida, _barra_y + barra_vida_altura, false);
    
    // Borda branca
    draw_set_color(c_white);
    draw_rectangle(_barra_x, _barra_y, _barra_x + barra_vida_largura, _barra_y + barra_vida_altura, true);
    
    // Reset
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}