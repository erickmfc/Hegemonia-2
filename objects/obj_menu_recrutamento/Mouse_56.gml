// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO ULTRA-MODERNO
// Sistema de Mouse Atualizado para Layout Único
// ===============================================

// Prevenir fechamento imediato (evita bug de duplo clique)
if (delay_abertura > 0) {
    show_debug_message("Menu ainda em delay de abertura. Ignorando clique.");
    return;
}

// USAR COORDENADAS GUI PARA COMPATIBILIDADE COM ZOOM
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

show_debug_message("=== CLIQUE DETECTADO NO MENU ULTRA-MODERNO ===");
show_debug_message("Posição do mouse: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");

// === DIMENSÕES DO MENU ULTRA-MODERNO (IGUAIS AO DRAW GUI) ===
var _mw = display_get_gui_width() * 0.85;  // 85% da largura
var _mh = display_get_gui_height() * 0.75; // 75% da altura
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

// === 1. VERIFICAR BOTÃO FECHAR PRIMEIRO (PRIORIDADE MÁXIMA) ===
var _close_w = 140; // Botão maior
var _close_h = 45;
var _close_x = _mx + _mw - _close_w - 30;
var _close_y = _my + _mh - 70 + 12; // Footer mais alto + offset

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

// === 3. VERIFICAR CLIQUE NOS CARDS DAS UNIDADES MILITARES ===
var _header_h = 90;
var _info_w = 280; // Painel lateral mais largo
var _info_x = _mx + 25; // Mais espaço da borda
var _grid_x = _info_x + _info_w + 30; // Mais espaço entre painel e grid
var _grid_y = _my + _header_h + 25; // Alinhado com painel lateral
var _grid_w = _mw - _info_w - 85; // Mais espaço nas bordas
var _grid_h = _mh - _header_h - 90; // Alinhado com painel lateral

var _card_w = (_grid_w - 20) / 2;  // 2 colunas
var _card_h = (_grid_h - 20) / 2;  // 2 linhas

// Obter unidades disponíveis
var _unidades = [];
if (instance_exists(id_do_quartel)) {
    _unidades = id_do_quartel.unidades_disponiveis;
}

// Verificar clique em cada card
for (var i = 0; i < min(4, ds_list_size(_unidades)); i++) {
    var _unidade = ds_list_find_value(_unidades, i);
    var _row = i div 2;
    var _col = i mod 2;
    
    var _card_x = _grid_x + _col * (_card_w + 20);
    var _card_y = _grid_y + _row * (_card_h + 20);
    
    // Verificar se o clique foi no card
    if (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w &&
        _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h) {
        
        show_debug_message("*** CARD DA UNIDADE " + string(i) + " CLICADO ***");
        show_debug_message("Unidade: " + _unidade.nome);
        
        // Verificar se pode recrutar
        var _can_afford = (global.dinheiro >= _unidade.custo_dinheiro && global.populacao >= _unidade.custo_populacao);
        var _quartel_livre = (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando);
        var _disponivel = _can_afford && _quartel_livre;
        
        if (_disponivel) {
            show_debug_message("Recrutando 1 unidade: " + _unidade.nome);
            
            // Verificar se o quartel existe e não está treinando
            if (instance_exists(id_do_quartel)) {
                if (id_do_quartel.esta_treinando) {
                    show_debug_message("Quartel já está treinando uma unidade!");
                } else {
                    show_debug_message("Enviando ordem de recrutamento - Quartel ID: " + string(id_do_quartel));
                    
                    // Definir a quantidade e unidade no quartel
                    id_do_quartel.quantidade_recrutar = 1;
                    id_do_quartel.unidade_selecionada = i; // Selecionar a unidade clicada
                    
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
            if (!_can_afford) {
                show_debug_message("Recursos insuficientes para recrutar " + _unidade.nome);
            } else {
                show_debug_message("Quartel ocupado - não é possível recrutar agora");
            }
        }
        return;
    }
}

// === 4. CLIQUE EM QUALQUER OUTRO LUGAR DENTRO DO PAINEL ===
global.debug_log("Clique dentro do painel, mas fora dos elementos interativos");
// Manter o menu aberto
