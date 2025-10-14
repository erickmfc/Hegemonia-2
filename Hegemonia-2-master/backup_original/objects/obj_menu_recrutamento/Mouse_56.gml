// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO
// Bloco 4, Fase 3: Mouse Event Modernizado
// ===============================================

// Evento Mouse GUI Left Pressed de obj_menu_recrutamento

// Prevenir fechamento imediato (evita bug de duplo clique)
if (delay_abertura > 0) {
    show_debug_message("Menu ainda em delay de abertura. Ignorando clique.");
    return;
}

// USAR COORDENADAS GUI PARA COMPATIBILIDADE COM ZOOM
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

show_debug_message("=== CLIQUE DETECTADO NO MENU DE RECRUTAMENTO ===");
show_debug_message("Posição do mouse: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");

// === DIMENSÕES DO MENU (IGUAIS AO DRAW GUI) ===
var _mw = display_get_gui_width() * 0.5;
var _mh = display_get_gui_height() * 0.6;
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

// === 1. VERIFICAR BOTÃO FECHAR PRIMEIRO (PRIORIDADE MÁXIMA) ===
// (usar mesmas dimensões do Draw GUI)
var _close_w0 = 80;
var _close_h0 = 35;
var _close_w = _close_w0 * 1.15;
var _close_h = _close_h0 * 1.15;
var _close_x = _mx + _mw - _close_w0 - 20 - ((_close_w - _close_w0) / 2);
var _close_y = _my + _mh - 60 - ((_close_h - _close_h0) / 2);

if (_mouse_gui_x >= _close_x && _mouse_gui_x <= _close_x + _close_w &&
    _mouse_gui_y >= _close_y && _mouse_gui_y <= _close_y + _close_h) {
    
    show_debug_message("Botão FECHAR clicado - fechando menu");
    global.menu_recrutamento_aberto = false;
    instance_destroy();
    return;
}

// === 2. VERIFICAR CLIQUE FORA DO MENU ===
if (_mouse_gui_x < _mx || _mouse_gui_x > _mx + _mw ||
    _mouse_gui_y < _my || _mouse_gui_y > _my + _mh) {
    
    show_debug_message("Clique fora do menu - fechando");
    global.menu_recrutamento_aberto = false;
    instance_destroy();
    return;
}

// === 3. VERIFICAR BOTÕES DE RECRUTAMENTO (1, 5, 10) ===
var _card_width = _mw * 0.8;
var _card_height = _mh * 0.5;
var _card_x = _mx + (_mw - _card_width) / 2;
var _card_y = _my + 120;

// Aplicar mesmos aumentos do Draw
_card_width = _card_width * 1.15;
_card_height = _card_height * 1.30;
_card_x = _mx + (_mw - _card_width) / 2;

// Recalcular baseline das seções como no Draw
var _name_y = _card_y + 90;
var _cost_y = _name_y + 25;
var _time_y = _cost_y + 20;
var _buttons_y = _time_y + 35;

var _button_height_orig = 35;
var _button_height = _button_height_orig * 1.05; // +5%
var _button_spacing = 10;
var _button_width = (_card_width - 40 - 2 * _button_spacing) / 3;
var _button_start_y = _buttons_y + 25;
_button_start_y -= (_button_height_orig * 0.05); // subir 5% do original (igual Draw)

// Botão 1 UNIDADE
var _btn1_x = _card_x + 20;
var _btn1_y = _button_start_y;
var _btn1_w = _button_width;
var _btn1_h = _button_height;

// Botão 5 UNIDADES
var _btn5_x = _btn1_x + _button_width + _button_spacing;
var _btn5_y = _button_start_y;
var _btn5_w = _button_width;
var _btn5_h = _button_height;

// Botão 10 UNIDADES
var _btn10_x = _btn5_x + _button_width + _button_spacing;
var _btn10_y = _button_start_y;
var _btn10_w = _button_width;
var _btn10_h = _button_height;

// Verificar clique no botão 1 UNIDADE
if (_mouse_gui_x >= _btn1_x && _mouse_gui_x <= _btn1_x + _btn1_w &&
    _mouse_gui_y >= _btn1_y && _mouse_gui_y <= _btn1_y + _btn1_h) {
    
    // Obter custos diretamente (sem criar instância temporária)
    var _custo_dinheiro = 100;
    var _custo_populacao = 1;
    
    if (global.dinheiro >= _custo_dinheiro * 1 && global.populacao >= _custo_populacao * 1) {
        show_debug_message("*** BOTÃO DE RECRUTAMENTO x1 CLICADO ***");
        
        // Verificar se o quartel existe e não está treinando
        if (instance_exists(id_do_quartel)) {
            if (id_do_quartel.esta_treinando) {
                show_debug_message("Quartel já está treinando uma unidade!");
            } else {
                show_debug_message("Enviando ordem de recrutamento para 1 unidade - Quartel ID: " + string(id_do_quartel));
                
                // Definir a quantidade no quartel
                id_do_quartel.quantidade_recrutar = 1;
                
                // Enviar ordem para o quartel
                with (id_do_quartel) {
                    event_perform(ev_other, ev_user0);
                }
            }
        } else {
            show_debug_message("ERRO: Quartel não encontrado (ID: " + string(id_do_quartel) + ")");
        }
        
        // Fechar o menu após a ação
        global.menu_recrutamento_aberto = false;
        instance_destroy();
    } else {
        show_debug_message("Recursos insuficientes para 1 unidade!");
    }
    return;
}

// Verificar clique no botão 5 UNIDADES
if (_mouse_gui_x >= _btn5_x && _mouse_gui_x <= _btn5_x + _btn5_w &&
    _mouse_gui_y >= _btn5_y && _mouse_gui_y <= _btn5_y + _btn5_h) {
    
    // Obter custos diretamente (sem criar instância temporária)
    var _custo_dinheiro = 100;
    var _custo_populacao = 1;
    
    if (global.dinheiro >= _custo_dinheiro * 5 && global.populacao >= _custo_populacao * 5) {
        show_debug_message("*** BOTÃO DE RECRUTAMENTO x5 CLICADO ***");
        
        // Verificar se o quartel existe e não está treinando
        if (instance_exists(id_do_quartel)) {
            if (id_do_quartel.esta_treinando) {
                show_debug_message("Quartel já está treinando uma unidade!");
            } else {
                show_debug_message("Enviando ordem de recrutamento para 5 unidades - Quartel ID: " + string(id_do_quartel));
                
                // Definir a quantidade no quartel
                id_do_quartel.quantidade_recrutar = 5;
                
                // Enviar ordem para o quartel
                with (id_do_quartel) {
                    event_perform(ev_other, ev_user0);
                }
            }
        } else {
            show_debug_message("ERRO: Quartel não encontrado (ID: " + string(id_do_quartel) + ")");
        }
        
        // Fechar o menu após a ação
        global.menu_recrutamento_aberto = false;
        instance_destroy();
    } else {
        show_debug_message("Recursos insuficientes para 5 unidades!");
    }
    return;
}

// Verificar clique no botão 10 UNIDADES
if (_mouse_gui_x >= _btn10_x && _mouse_gui_x <= _btn10_x + _btn10_w &&
    _mouse_gui_y >= _btn10_y && _mouse_gui_y <= _btn10_y + _btn10_h) {
    
    // Obter custos diretamente (sem criar instância temporária)
    var _custo_dinheiro = 100;
    var _custo_populacao = 1;
    
    if (global.dinheiro >= _custo_dinheiro * 10 && global.populacao >= _custo_populacao * 10) {
        show_debug_message("*** BOTÃO DE RECRUTAMENTO x10 CLICADO ***");
        
        // Verificar se o quartel existe e não está treinando
        if (instance_exists(id_do_quartel)) {
            if (id_do_quartel.esta_treinando) {
                show_debug_message("Quartel já está treinando uma unidade!");
            } else {
                show_debug_message("Enviando ordem de recrutamento para 10 unidades - Quartel ID: " + string(id_do_quartel));
                
                // Definir a quantidade no quartel
                id_do_quartel.quantidade_recrutar = 10;
                
                // Enviar ordem para o quartel
                with (id_do_quartel) {
                    event_perform(ev_other, ev_user0);
                }
            }
        } else {
            show_debug_message("ERRO: Quartel não encontrado (ID: " + string(id_do_quartel) + ")");
        }
        
        // Fechar o menu após a ação
        global.menu_recrutamento_aberto = false;
        instance_destroy();
    } else {
        show_debug_message("Recursos insuficientes para 10 unidades!");
    }
    return;
}

// === BOTÕES DE QUANTIDADE PARA TANQUE === (usar mesmos cálculos do Draw)
var _tank_y = _button_start_y + _button_height + 30;
var _tank_btn_w = 45;
var _tank_btn_h = 28;
var _tank_btn_spacing = 5;
var _tank_btn_start_x = _card_x + (_card_width * 0.70);
var _tank_btn_y = _tank_y + 65;

// Custos para tanque
var _tank_custo_dinheiro = 500;
var _tank_custo_populacao = 3;

// Botão 1 tanque
var _tank_btn1_x = _tank_btn_start_x;
if (_mouse_gui_x >= _tank_btn1_x && _mouse_gui_x <= _tank_btn1_x + _tank_btn_w &&
    _mouse_gui_y >= _tank_btn_y && _mouse_gui_y <= _tank_btn_y + _tank_btn_h) {
    if (global.dinheiro >= _tank_custo_dinheiro && global.populacao >= _tank_custo_populacao) {
        if (instance_exists(id_do_quartel)) {
            if (!id_do_quartel.esta_treinando) {
                id_do_quartel.quantidade_recrutar = 1;
                id_do_quartel.recrutar_tanque = true;
                with (id_do_quartel) {
                    event_perform(ev_other, ev_user0);
                }
                global.menu_recrutamento_aberto = false;
                instance_destroy();
            }
        }
    }
    return;
}

// Botão 6 tanques
var _tank_btn6_x = _tank_btn_start_x + _tank_btn_w + _tank_btn_spacing;
if (_mouse_gui_x >= _tank_btn6_x && _mouse_gui_x <= _tank_btn6_x + _tank_btn_w &&
    _mouse_gui_y >= _tank_btn_y && _mouse_gui_y <= _tank_btn_y + _tank_btn_h) {
    var _custo_total_d = _tank_custo_dinheiro * 6;
    var _custo_total_p = _tank_custo_populacao * 6;
    if (global.dinheiro >= _custo_total_d && global.populacao >= _custo_total_p) {
        if (instance_exists(id_do_quartel)) {
            if (!id_do_quartel.esta_treinando) {
                id_do_quartel.quantidade_recrutar = 6;
                id_do_quartel.recrutar_tanque = true;
                with (id_do_quartel) {
                    event_perform(ev_other, ev_user0);
                }
                global.menu_recrutamento_aberto = false;
                instance_destroy();
            }
        }
    }
    return;
}

// Botão 10 tanques
var _tank_btn10_x = _tank_btn_start_x + (_tank_btn_w + _tank_btn_spacing) * 2;
if (_mouse_gui_x >= _tank_btn10_x && _mouse_gui_x <= _tank_btn10_x + _tank_btn_w &&
    _mouse_gui_y >= _tank_btn_y && _mouse_gui_y <= _tank_btn_y + _tank_btn_h) {
    var _custo_total_d = _tank_custo_dinheiro * 10;
    var _custo_total_p = _tank_custo_populacao * 10;
    if (global.dinheiro >= _custo_total_d && global.populacao >= _custo_total_p) {
        if (instance_exists(id_do_quartel)) {
            if (!id_do_quartel.esta_treinando) {
                id_do_quartel.quantidade_recrutar = 10;
                id_do_quartel.recrutar_tanque = true;
                with (id_do_quartel) {
                    event_perform(ev_other, ev_user0);
                }
                global.menu_recrutamento_aberto = false;
                instance_destroy();
            }
        }
    }
    return;
}
// === 4. CLIQUE DENTRO DO CARD MAS FORA DO BOTÃO ===
if (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_width &&
    _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_height) {
    
    show_debug_message("Clique dentro do card da infantaria (mas fora do botão)");
    // Não fazer nada, apenas manter o menu aberto
    return;
}

// === 5. CLIQUE EM QUALQUER OUTRO LUGAR DENTRO DO PAINEL ===
show_debug_message("Clique dentro do painel, mas fora dos elementos interativos");
// Manter o menu aberto