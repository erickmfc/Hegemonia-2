// ===============================================
// HEGEMONIA GLOBAL - NAVIO TRANSPORTE (DRAW GUI)
// Menu de Carga Interativo
// ===============================================

// CHAMAR O PAI PRIMEIRO (GARANTIR QUE BASE É EXECUTADO)
event_inherited();

// SE NÃO ESTÁ SELECIONADO, SAIR
if (!variable_instance_exists(id, "selecionado") || !selecionado) {
    exit;
}

var _cam = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);

var _proj_x = (x - _cam_x) / (_cam_w / display_get_gui_width());
var _proj_y = (y - _cam_y) / (_cam_h / display_get_gui_height());

// === 1. CAIXA DE INFORMAÇÕES RÁPIDAS ===
var _info_x = _proj_x;
var _info_y = _proj_y - 100;
var _info_w = 180;
var _info_h = 120;

draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(_info_x - _info_w/2, _info_y - _info_h/2, _info_x + _info_w/2, _info_y + _info_h/2, false);
draw_set_alpha(1.0);

draw_set_color(c_white);
draw_rectangle(_info_x - _info_w/2, _info_y - _info_h/2, _info_x + _info_w/2, _info_y + _info_h/2, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_yellow);

var _text_x = _info_x;
var _text_y = _info_y - _info_h/2 + 5;

draw_text(_text_x, _text_y, "NAVIO TRANSPORTE");
_text_y += 18;

// HP
var _hp_percent = (hp_atual / hp_max) * 100;
if (_hp_percent < 30) draw_set_color(c_red);
else if (_hp_percent < 60) draw_set_color(c_yellow);
else draw_set_color(c_white);

draw_text(_text_x, _text_y, "HP: " + string(round(_hp_percent)) + "%");
_text_y += 18;

// Estado
draw_set_color(make_color_rgb(0, 255, 255));
var _estado_texto = "PARADO";
if (variable_instance_exists(id, "estado")) {
    if (estado == LanchaState.MOVENDO) _estado_texto = "NAVEGANDO";
    else if (estado == LanchaState.PATRULHANDO) _estado_texto = "PATRULHANDO";
    else if (estado == LanchaState.ATACANDO) _estado_texto = "ATACANDO";
}

draw_text(_text_x, _text_y, "Estado: " + _estado_texto);
_text_y += 18;

// Modo combate
if (variable_instance_exists(id, "modo_combate")) {
    if (modo_combate == LanchaMode.ATAQUE) {
        draw_set_color(c_red);
        draw_text(_text_x, _text_y, "MODO ATAQUE");
    } else {
        draw_set_color(c_gray);
        draw_text(_text_x, _text_y, "MODO PASSIVO");
    }
}

// === 2. MENU DE CARGA (COMANDO J) ===
if (variable_instance_exists(id, "menu_carga_aberto") && menu_carga_aberto) {
    var _menu_x = 100;
    var _menu_y = 100;
    var _menu_w = 450;
    var _menu_h = 500;

    // Fundo do menu
    draw_set_alpha(0.95);
    draw_set_color(c_black);
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, false);

    // Borda
    draw_set_alpha(1.0);
    draw_set_color(c_yellow);
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, true);

    // Título
    draw_set_halign(fa_left);
    draw_set_color(c_yellow);
    draw_set_valign(fa_middle);
    draw_text(_menu_x + 15, _menu_y + 15, "📦 CARGA DO NAVIO");
    
    // ✅ NOVO: Mostrar todas as informações de status do navio no menu
    var _line_y = _menu_y + 40;
    
    // Status de Transporte (modo P)
    draw_set_color(c_white);
    var _modo_texto = "MODO TRANSPORTE: ";
    var _modo_cor = c_gray;
    if (variable_instance_exists(id, "estado_transporte")) {
        if (estado_transporte == NavioTransporteEstado.EMBARQUE_ATIVO) {
            _modo_texto = "MODO TRANSPORTE: 🚚 EMBARQUE ATIVO";
            _modo_cor = c_yellow;
        } else if (estado_transporte == NavioTransporteEstado.DESEMBARCANDO) {
            _modo_texto = "MODO TRANSPORTE: 📦 DESEMBARCANDO";
            _modo_cor = c_orange;
        } else if (estado_transporte == NavioTransporteEstado.EMBARQUE_OFF) {
            _modo_texto = "MODO TRANSPORTE: ✅ EMBARCADO (Fechado)";
            _modo_cor = c_lime;
        } else if (estado_transporte == NavioTransporteEstado.NAVEGANDO) {
            _modo_texto = "MODO TRANSPORTE: ⚓ NAVEGANDO";
            _modo_cor = make_color_rgb(0, 255, 255); // c_aqua
        } else {
            _modo_texto = "MODO TRANSPORTE: ⏹️ PARADO";
            _modo_cor = c_gray;
        }
    }
    draw_set_color(_modo_cor);
    draw_text(_menu_x + 15, _line_y, _modo_texto);
    _line_y += 25;
    
    // Estado de Movimento
    draw_set_color(c_white);
    var _estado_texto = "Estado: ";
    var _estado_cor = c_gray;
    if (variable_instance_exists(id, "estado")) {
        if (estado == LanchaState.ATACANDO) {
            _estado_texto = "Estado: ⚔️ ATACANDO";
            _estado_cor = c_red;
        } else if (estado == LanchaState.PATRULHANDO) {
            _estado_texto = "Estado: 🔄 PATRULHANDO";
            _estado_cor = c_orange;
        } else if (estado == LanchaState.MOVENDO) {
            _estado_texto = "Estado: ⚓ NAVEGANDO";
            _estado_cor = make_color_rgb(0, 255, 255); // c_aqua
        } else if (estado == LanchaState.DEFININDO_PATRULHA) {
            _estado_texto = "Estado: 🗺️ DEFININDO ROTA";
            _estado_cor = c_yellow;
        } else {
            _estado_texto = "Estado: ⏹️ PARADO";
            _estado_cor = c_gray;
        }
    }
    draw_set_color(_estado_cor);
    draw_text(_menu_x + 15, _line_y, _estado_texto);
    _line_y += 25;
    
    // Modo de Combate
    draw_set_color(c_white);
    var _modo_combate_texto = "Modo Combate: ";
    var _modo_combate_cor = c_gray;
    if (variable_instance_exists(id, "modo_combate")) {
        if (modo_combate == LanchaMode.ATAQUE) {
            _modo_combate_texto = "Modo Combate: ⚔️ ATAQUE";
            _modo_combate_cor = c_red;
        } else {
            _modo_combate_texto = "Modo Combate: 🛡️ PASSIVO";
            _modo_combate_cor = c_gray;
        }
    }
    draw_set_color(_modo_combate_cor);
    draw_text(_menu_x + 15, _line_y, _modo_combate_texto);
    _line_y += 30;
    var _col1_x = _menu_x + 20;
    var _col2_x = _menu_x + 200;

    // Resumo de carga
    draw_set_color(c_white);
    draw_text(_col1_x, _line_y, "✈️ Aeronaves:");
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_text(_col2_x, _line_y, string(avioes_count) + "/" + string(avioes_max));
    _line_y += 25;

    draw_set_color(c_white);
    draw_text(_col1_x, _line_y, "🚛 Veículos:");
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_text(_col2_x, _line_y, string(unidades_count) + "/" + string(unidades_max));
    _line_y += 25;

    draw_set_color(c_white);
    draw_text(_col1_x, _line_y, "👥 Soldados:");
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_text(_col2_x, _line_y, string(soldados_count) + "/" + string(soldados_max));
    _line_y += 30;

    // Barra de carga
    var _percent = ((avioes_count + unidades_count + soldados_count) / (avioes_max + unidades_max + soldados_max)) * 100;
    draw_set_color(c_gray);
    draw_rectangle(_menu_x + 20, _line_y, _menu_x + _menu_w - 20, _line_y + 15, false);

    var _cor_barra = c_green;
    if (_percent > 75) _cor_barra = c_orange;
    if (_percent >= 100) _cor_barra = c_red;

    draw_set_color(_cor_barra);
    draw_rectangle(_menu_x + 20, _line_y, _menu_x + 20 + ((_menu_w - 40) * _percent / 100), _line_y + 15, false);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_menu_x + _menu_w/2, _line_y + 2, string(round(_percent)) + "%");

    _line_y += 40;

    // === LISTA DE UNIDADES PARA SELEÇÃO ===
    draw_set_halign(fa_left);
    draw_set_color(c_yellow);
    draw_text(_col1_x, _line_y, "Selecione uma unidade para desembarcar:");
    _line_y += 25;

    var _item_height = 25;
    var _scroll_y = _line_y;
    var _item_index = 0;

    // Listar Aeronaves
    if (avioes_count > 0) {
        for (var i = 0; i < ds_list_size(avioes_embarcados); i++) {
            var _unidade_id = avioes_embarcados[| i];
            if (!instance_exists(_unidade_id)) continue;

            var _item_y = _scroll_y + (_item_index * _item_height);
            var _is_selected = (unidade_selecionada_desembarque == _unidade_id && tipo_unidade_selecionada == "aeronave");

            // Fundo do item (selecionado ou não)
            if (_is_selected) {
                draw_set_color(c_yellow);
                draw_set_alpha(0.3);
                draw_rectangle(_col1_x - 5, _item_y - 2, _menu_x + _menu_w - 20, _item_y + _item_height - 2, false);
                draw_set_alpha(1.0);
            }

            draw_set_color(_is_selected ? c_yellow : c_white);
            var _nome_unidade = "Aeronave #" + string(i + 1);
            if (variable_instance_exists(_unidade_id, "nome_unidade")) {
                _nome_unidade = _unidade_id.nome_unidade;
            }
            draw_text(_col1_x, _item_y, "✈️ " + _nome_unidade);
            _item_index++;
        }
    }

    // Listar Veículos
    if (unidades_count > 0) {
        for (var i = 0; i < ds_list_size(unidades_embarcadas); i++) {
            var _unidade_id = unidades_embarcadas[| i];
            if (!instance_exists(_unidade_id)) continue;

            var _item_y = _scroll_y + (_item_index * _item_height);
            var _is_selected = (unidade_selecionada_desembarque == _unidade_id && tipo_unidade_selecionada == "veiculo");

            if (_is_selected) {
                draw_set_color(c_yellow);
                draw_set_alpha(0.3);
                draw_rectangle(_col1_x - 5, _item_y - 2, _menu_x + _menu_w - 20, _item_y + _item_height - 2, false);
                draw_set_alpha(1.0);
            }

            draw_set_color(_is_selected ? c_yellow : c_white);
            var _nome_unidade = "Veículo #" + string(i + 1);
            if (variable_instance_exists(_unidade_id, "nome_unidade")) {
                _nome_unidade = _unidade_id.nome_unidade;
            }
            draw_text(_col1_x, _item_y, "🚛 " + _nome_unidade);
            _item_index++;
        }
    }

    // Listar Soldados
    if (soldados_count > 0) {
        for (var i = 0; i < ds_list_size(soldados_embarcados); i++) {
            var _unidade_id = soldados_embarcados[| i];
            if (!instance_exists(_unidade_id)) continue;

            var _item_y = _scroll_y + (_item_index * _item_height);
            var _is_selected = (unidade_selecionada_desembarque == _unidade_id && tipo_unidade_selecionada == "soldado");

            if (_is_selected) {
                draw_set_color(c_yellow);
                draw_set_alpha(0.3);
                draw_rectangle(_col1_x - 5, _item_y - 2, _menu_x + _menu_w - 20, _item_y + _item_height - 2, false);
                draw_set_alpha(1.0);
            }

            draw_set_color(_is_selected ? c_yellow : c_white);
            var _nome_unidade = "Soldado #" + string(i + 1);
            if (variable_instance_exists(_unidade_id, "nome_unidade")) {
                _nome_unidade = _unidade_id.nome_unidade;
            }
            draw_text(_col1_x, _item_y, "👥 " + _nome_unidade);
            _item_index++;
        }
    }

    _line_y = _menu_y + _menu_h - 120;

    // === BOTÕES DE CONTROLE ===
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Botão DESEMBARCAR SELECIONADA
    var _btn1_x = _menu_x + 100;
    var _btn1_y = _line_y;
    var _btn1_w = 140;
    var _btn1_h = 35;

    var _tem_selecao = (unidade_selecionada_desembarque != -1);
    draw_set_color(_tem_selecao ? c_yellow : c_gray);
    draw_rectangle(_btn1_x - _btn1_w/2, _btn1_y - _btn1_h/2, _btn1_x + _btn1_w/2, _btn1_y + _btn1_h/2, false);
    draw_set_color(c_black);
    draw_text(_btn1_x, _btn1_y, "DESEMBARCAR 1");

    // Botão DESEMBARCAR TODAS
    var _btn2_x = _menu_x + 250;
    var _btn2_y = _line_y;
    var _btn2_w = 140;
    var _btn2_h = 35;

    var _tem_unidades = (soldados_count + unidades_count + avioes_count > 0);
    draw_set_color(_tem_unidades ? c_orange : c_gray);
    draw_rectangle(_btn2_x - _btn2_w/2, _btn2_y - _btn2_h/2, _btn2_x + _btn2_w/2, _btn2_y + _btn2_h/2, false);
    draw_set_color(c_black);
    draw_text(_btn2_x, _btn2_y, desembarcando_todas ? "PAUSAR" : "DESEMB. TODAS");

    // Botão FECHAR
    var _btn3_x = _menu_x + 400;
    var _btn3_y = _line_y;
    var _btn3_w = 60;
    var _btn3_h = 35;

    draw_set_color(c_red);
    draw_rectangle(_btn3_x - _btn3_w/2, _btn3_y - _btn3_h/2, _btn3_x + _btn3_w/2, _btn3_y + _btn3_h/2, false);
    draw_set_color(c_white);
    draw_text(_btn3_x, _btn3_y, "FECHAR");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Resetar configurações
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
