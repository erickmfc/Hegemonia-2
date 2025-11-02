/// @description Organiza unidades em formações táticas estratégicas
/// @param {real} _ia_id ID da IA
/// @param {real} _alvo_x Alvo X
/// @param {real} _alvo_y Alvo Y
/// @param {string} _tipo_formacao Tipo: "linha", "cerco", "emboscada", "avanco_coordenado"
/// @return {array} Array com grupos de unidades organizados

function scr_ia_formacao_tatica(_ia_id, _alvo_x, _alvo_y, _tipo_formacao = "linha") {
    var _ia = _ia_id;
    
    // Coletar todas as unidades da IA
    var _infantaria = [];
    var _tanques = [];
    var _antiaereos = [];
    var _blindados = [];
    
    var _idx_inf = 0;
    var _idx_tanq = 0;
    var _idx_aa = 0;
    var _idx_blind = 0;
    
    // Coletar infantaria
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _infantaria[_idx_inf] = id;
            _idx_inf++;
        }
    }
    
    // Coletar tanques
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _tanques[_idx_tanq] = id;
            _idx_tanq++;
        }
    }
    
    // Coletar soldados antiaéreos
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _antiaereos[_idx_aa] = id;
            _idx_aa++;
        }
    }
    
    // Coletar blindados antiaéreos
    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _blindados[_idx_blind] = id;
            _idx_blind++;
        }
    }
    
    var _grupos_formacao = [];
    
    // === FORMAÇÃO EM LINHA (Padrão) ===
    if (_tipo_formacao == "linha") {
        // Infantaria na frente, tanques atrás
        var _linha_frontal = array_length(_infantaria);
        var _linha_tanques = array_length(_tanques);
        
        // Calcular centro da formação
        var _dir_para_alvo = point_direction(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y);
        var _dist_para_alvo = point_distance(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y);
        var _ponto_intermedio_x = _ia.base_x + lengthdir_x(_dist_para_alvo * 0.6, _dir_para_alvo);
        var _ponto_intermedio_y = _ia.base_y + lengthdir_y(_dist_para_alvo * 0.6, _dir_para_alvo);
        
        // Infantaria em linha frontal
        var _espacamento = 60;
        var _offset_x_base = -((_linha_frontal - 1) * _espacamento) / 2;
        
        for (var i = 0; i < array_length(_infantaria); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _pos_x = _ponto_intermedio_x + lengthdir_x(_offset_x_base + (i * _espacamento), _dir_para_alvo + 90);
            var _pos_y = _ponto_intermedio_y + lengthdir_y(_offset_x_base + (i * _espacamento), _dir_para_alvo + 90);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "frontal"
            });
        }
        
        // Tanques em linha atrás (offset de 100px)
        for (var i = 0; i < array_length(_tanques); i++) {
            if (!instance_exists(_tanques[i])) continue;
            
            var _pos_x = _ponto_intermedio_x + lengthdir_x(_offset_x_base + (i * _espacamento), _dir_para_alvo + 90) - lengthdir_x(100, _dir_para_alvo);
            var _pos_y = _ponto_intermedio_y + lengthdir_y(_offset_x_base + (i * _espacamento), _dir_para_alvo + 90) - lengthdir_y(100, _dir_para_alvo);
            
            array_push(_grupos_formacao, {
                unidade: _tanques[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "tanque",
                linha: "suporte"
            });
        }
        
        // Antiaéreos nos flancos
        var _flanco_esquerdo = _ponto_intermedio_x + lengthdir_x(_offset_x_base - 150, _dir_para_alvo + 90);
        var _flanco_direito = _ponto_intermedio_x + lengthdir_x(_offset_x_base + (_linha_frontal * _espacamento) + 150, _dir_para_alvo + 90);
        
        for (var i = 0; i < array_length(_antiaereos); i++) {
            if (!instance_exists(_antiaereos[i])) continue;
            
            var _flanco_x = (i mod 2 == 0) ? _flanco_esquerdo : _flanco_direito;
            var _flanco_y = _ponto_intermedio_y;
            
            array_push(_grupos_formacao, {
                unidade: _antiaereos[i],
                destino_x: _flanco_x,
                destino_y: _flanco_y,
                tipo: "antiaereo",
                linha: "flanco"
            });
        }
    }
    
    // === FORMAÇÃO DE CERCO ===
    else if (_tipo_formacao == "cerco") {
        var _raio_cerco = 250;
        var _total_unidades = array_length(_infantaria) + array_length(_tanques);
        var _angulo_step = 360 / max(_total_unidades, 1);
        
        var _idx = 0;
        
        // Posicionar infantaria em círculo
        for (var i = 0; i < array_length(_infantaria); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _angulo = _idx * _angulo_step;
            var _pos_x = _alvo_x + lengthdir_x(_raio_cerco, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio_cerco, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "cerco"
            });
            _idx++;
        }
        
        // Posicionar tanques em círculo mais externo
        for (var i = 0; i < array_length(_tanques); i++) {
            if (!instance_exists(_tanques[i])) continue;
            
            var _angulo = _idx * _angulo_step;
            var _pos_x = _alvo_x + lengthdir_x(_raio_cerco + 100, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio_cerco + 100, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _tanques[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "tanque",
                linha: "cerco_externo"
            });
            _idx++;
        }
    }
    
    // === FORMAÇÃO DE EMBOSCADA ===
    else if (_tipo_formacao == "emboscada") {
        // Posicionar unidades em "V" com foco no alvo
        var _dir_para_alvo = point_direction(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y);
        var _dist_intermedia = point_distance(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y) * 0.7;
        
        var _centro_x = _ia.base_x + lengthdir_x(_dist_intermedia, _dir_para_alvo);
        var _centro_y = _ia.base_y + lengthdir_y(_dist_intermedia, _dir_para_alvo);
        
        // Formação em "V" com infantaria
        for (var i = 0; i < array_length(_infantaria); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _angulo_offset = (i - array_length(_infantaria) / 2) * 15; // 15 graus entre cada
            var _dist_offset = 150 + (abs(_angulo_offset) * 2);
            
            var _pos_x = _centro_x + lengthdir_x(_dist_offset, _dir_para_alvo + _angulo_offset);
            var _pos_y = _centro_y + lengthdir_y(_dist_offset, _dir_para_alvo + _angulo_offset);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "emboscada"
            });
        }
        
        // Tanques atrás do centro
        for (var i = 0; i < array_length(_tanques); i++) {
            if (instance_exists(_tanques[i])) {
                var _pos_x = _centro_x - lengthdir_x(120, _dir_para_alvo);
                var _pos_y = _centro_y - lengthdir_y(120, _dir_para_alvo);
                
                array_push(_grupos_formacao, {
                    unidade: _tanques[i],
                    destino_x: _pos_x,
                    destino_y: _pos_y,
                    tipo: "tanque",
                    linha: "reserva"
                });
            }
        }
    }
    
    // === FORMAÇÃO AVANÇO COORDENADO ===
    else if (_tipo_formacao == "avanco_coordenado") {
        // Formação compacta em retângulo
        var _largura = ceil(sqrt(array_length(_infantaria) + array_length(_tanques)));
        var _espacamento = 70;
        
        var _dir_para_alvo = point_direction(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y);
        var _dist = point_distance(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y) * 0.65;
        var _centro_x = _ia.base_x + lengthdir_x(_dist, _dir_para_alvo);
        var _centro_y = _ia.base_y + lengthdir_y(_dist, _dir_para_alvo);
        
        var _idx = 0;
        
        // Organizar em grid
        for (var i = 0; i < array_length(_infantaria); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _col = _idx mod _largura;
            var _linha = _idx div _largura;
            
            var _offset_x = (_col - _largura / 2) * _espacamento;
            var _offset_y = (_linha - _largura / 2) * _espacamento;
            
            var _pos_x = _centro_x + lengthdir_x(_offset_x, _dir_para_alvo + 90) + lengthdir_x(_offset_y * 0.3, _dir_para_alvo);
            var _pos_y = _centro_y + lengthdir_y(_offset_x, _dir_para_alvo + 90) + lengthdir_y(_offset_y * 0.3, _dir_para_alvo);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "coordenado"
            });
            _idx++;
        }
        
        // Tanques atrás
        for (var i = 0; i < array_length(_tanques); i++) {
            if (!instance_exists(_tanques[i])) continue;
            
            var _col = _idx mod _largura;
            var _linha = _idx div _largura;
            
            var _offset_x = (_col - _largura / 2) * _espacamento;
            var _offset_y = (_linha - _largura / 2) * _espacamento - 150; // Atrás
            
            var _pos_x = _centro_x + lengthdir_x(_offset_x, _dir_para_alvo + 90) + lengthdir_x(_offset_y * 0.3, _dir_para_alvo);
            var _pos_y = _centro_y + lengthdir_y(_offset_x, _dir_para_alvo + 90) + lengthdir_y(_offset_y * 0.3, _dir_para_alvo);
            
            array_push(_grupos_formacao, {
                unidade: _tanques[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "tanque",
                linha: "coordenado"
            });
            _idx++;
        }
    }
    
    return _grupos_formacao;
}
