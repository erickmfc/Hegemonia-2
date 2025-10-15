// Evento Draw de obj_game_manager

draw_set_color(c_black);
draw_set_alpha(0.8);

for (var i = 0; i < global.map_width; i++) {
    for (var j = 0; j < global.map_height; j++) {
        
        var minha_nacao = global.map_grid[i][j].nacao;
        if (minha_nacao == NATIONS.NEUTRA) continue;

        var xx = i * global.tile_size;
        var yy = j * global.tile_size;

        // Cima
        if (j > 0 && global.map_grid[i][j-1].nacao != minha_nacao) {
            draw_line(xx, yy, xx + global.tile_size, yy);
        }
        // Baixo
        if (j < global.map_height - 1 && global.map_grid[i][j+1].nacao != minha_nacao) {
            draw_line(xx, yy + global.tile_size, xx + global.tile_size, yy + global.tile_size);
        }
        // Esquerda
        if (i > 0 && global.map_grid[i-1][j].nacao != minha_nacao) {
            draw_line(xx, yy, xx, yy + global.tile_size);
        }
        // Direita
        if (i < global.map_width - 1 && global.map_grid[i+1][j].nacao != minha_nacao) {
            draw_line(xx + global.tile_size, yy, xx + global.tile_size, yy + global.tile_size);
        }
    }
}

draw_set_alpha(1);
draw_set_color(c_white);

// ===============================================
// SISTEMA DE BARRAS DE VIDA INTEGRADO
// ===============================================
if (global.barras_vida_ativas) {
    
    // === FUNÇÃO LOCAL PARA DESENHAR BARRA BÁSICA ===
    function desenhar_barra_basica(_obj, _offset_y) {
        if (!instance_exists(_obj)) return;
        if (!variable_instance_exists(_obj, "hp_atual") || !variable_instance_exists(_obj, "hp_max")) return;
        if (_obj.hp_atual <= 0) return;
        
        var _barra_w = 50;
        var _barra_h = 6;
        var _barra_x = _obj.x - _barra_w/2;
        var _barra_y = _obj.y + _offset_y;
        
        // Fundo
        draw_set_color(c_maroon);
        draw_set_alpha(0.8);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
        
        // Vida atual
        var _vida_percentual = _obj.hp_atual / _obj.hp_max;
        var _vida_w = _barra_w * _vida_percentual;
        
        var _cor_vida = c_green;
        if (_vida_percentual < 0.3) _cor_vida = c_red;
        else if (_vida_percentual < 0.6) _cor_vida = c_yellow;
        
        draw_set_color(_cor_vida);
        draw_set_alpha(0.9);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _vida_w, _barra_y + _barra_h, false);
        
        // Borda
        draw_set_color(c_white);
        draw_set_alpha(1.0);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, true);
        
        // Texto HP
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(_barra_x + _barra_w/2, _barra_y - 8, string(_obj.hp_atual) + "/" + string(_obj.hp_max));
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_alpha(1.0);
    }
    
    // === FUNÇÃO LOCAL PARA DESENHAR BARRA AVANÇADA ===
    function desenhar_barra_avancada(_obj, _offset_y) {
        if (!instance_exists(_obj)) return;
        if (!variable_instance_exists(_obj, "hp_atual") || !variable_instance_exists(_obj, "hp_max")) return;
        if (_obj.hp_atual <= 0) return;
        
        var _barra_w = 60;
        var _barra_h = 8;
        var _barra_x = _obj.x - _barra_w/2;
        var _barra_y = _obj.y + _offset_y;
        
        // Fundo
        draw_set_color(c_maroon);
        draw_set_alpha(0.7);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
        
        // Vida atual
        var _vida_percentual = _obj.hp_atual / _obj.hp_max;
        var _vida_w = _barra_w * _vida_percentual;
        
        var _cor_vida = c_green;
        if (_vida_percentual < 0.3) _cor_vida = c_red;
        else if (_vida_percentual < 0.6) _cor_vida = c_yellow;
        
        draw_set_color(_cor_vida);
        draw_set_alpha(0.8);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _vida_w, _barra_y + _barra_h, false);
        
        // Borda
        draw_set_color(c_white);
        draw_set_alpha(1.0);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, true);
        
        // Texto HP
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(_barra_x + _barra_w/2, _barra_y - 12, string(_obj.hp_atual) + "/" + string(_obj.hp_max));
        
        // Estado (se existir)
        if (variable_instance_exists(_obj, "estado")) {
            var _estado_texto = "";
            var _cor_estado = c_white;
            
            switch (_obj.estado) {
                case "pousado": _estado_texto = "POUSADO"; _cor_estado = c_gray; break;
                case "decolando": _estado_texto = "DECOLANDO"; _cor_estado = c_yellow; break;
                case "patrulhando": _estado_texto = "PATRULHANDO"; _cor_estado = c_blue; break;
                case "caçando": _estado_texto = "CAÇANDO!"; _cor_estado = c_red; break;
                case "atacando": _estado_texto = "ATACANDO!"; _cor_estado = c_red; break;
                case "movendo": _estado_texto = "MOVENDO"; _cor_estado = c_lime; break;
                case "pousando": _estado_texto = "POUSANDO"; _cor_estado = c_orange; break;
                default: _estado_texto = _obj.estado; _cor_estado = c_white; break;
            }
            
            draw_set_color(_cor_estado);
            draw_text(_barra_x + _barra_w/2, _barra_y - 25, _estado_texto);
        }
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_alpha(1.0);
    }
    
    // === DESENHAR BARRAS PARA TODAS AS UNIDADES ===
    
    // F-5 CAÇA
    with (obj_caca_f5) {
        if (nacao_proprietaria == 1) {
            desenhar_barra_avancada(id, -30);
        }
    }

    // HELICÓPTERO MILITAR
    with (obj_helicoptero_militar) {
        if (nacao_proprietaria == 1) {
            desenhar_barra_avancada(id, -25);
        }
    }

    // F-6 INIMIGO
    with (obj_f6) {
        desenhar_barra_avancada(id, -30);
    }

    // UNIDADES TERRESTRES
    with (obj_infantaria) {
        if (nacao_proprietaria == 1) {
            desenhar_barra_basica(id, -20);
        }
    }

    with (obj_tanque) {
        if (nacao_proprietaria == 1) {
            desenhar_barra_basica(id, -25);
        }
    }

    with (obj_blindado_antiaereo) {
        if (nacao_proprietaria == 1) {
            desenhar_barra_basica(id, -25);
        }
    }

    // UNIDADES INIMIGAS
    with (obj_inimigo) {
        desenhar_barra_basica(id, -20);
    }
}
