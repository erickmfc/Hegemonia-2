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
    
    // === ✅ NOVAS FORMAÇÕES PARA ESTRATÉGIAS ATUALIZADAS ===
    
    // === FORMAÇÃO ASSALTO MASSIVO ===
    else if (_tipo_formacao == "assalto_massivo") {
        // Formação densa com todos os tipos de unidades
        var _espacamento = 50; // Espaçamento reduzido para formação densa
        var _largura = 12; // Largura fixa para formação massiva
        
        var _dir_para_alvo = point_direction(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y);
        var _dist = point_distance(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y) * 0.6;
        var _centro_x = _ia.base_x + lengthdir_x(_dist, _dir_para_alvo);
        var _centro_y = _ia.base_y + lengthdir_y(_dist, _dir_para_alvo);
        
        var _idx = 0;
        
        // Infantaria na frente (2 primeiras linhas)
        for (var i = 0; i < array_length(_infantaria); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _col = _idx mod _largura;
            var _linha = _idx div _largura;
            
            var _offset_x = (_col - _largura / 2) * _espacamento;
            var _offset_y = (_linha - 1) * _espacamento; // 2 linhas de infantaria
            
            var _pos_x = _centro_x + lengthdir_x(_offset_x, _dir_para_alvo + 90) + lengthdir_x(_offset_y, _dir_para_alvo);
            var _pos_y = _centro_y + lengthdir_y(_offset_x, _dir_para_alvo + 90) + lengthdir_y(_offset_y, _dir_para_alvo);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "assalto_frente"
            });
            _idx++;
        }
        
        // Tanques atrás (3 linhas)
        var _tanque_idx = 0;
        for (var i = 0; i < array_length(_tanques); i++) {
            if (!instance_exists(_tanques[i])) continue;
            
            var _col = _tanque_idx mod _largura;
            var _linha = (_tanque_idx div _largura) + 2; // Começar na linha 3
            
            var _offset_x = (_col - _largura / 2) * _espacamento;
            var _offset_y = _linha * _espacamento;
            
            var _pos_x = _centro_x + lengthdir_x(_offset_x, _dir_para_alvo + 90) + lengthdir_x(_offset_y, _dir_para_alvo);
            var _pos_y = _centro_y + lengthdir_y(_offset_x, _dir_para_alvo + 90) + lengthdir_y(_offset_y, _dir_para_alvo);
            
            array_push(_grupos_formacao, {
                unidade: _tanques[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "tanque",
                linha: "assalto_tanques"
            });
            _tanque_idx++;
        }
        
        // Antiaéreos espalhados (última linha)
        for (var i = 0; i < array_length(_antiaereos); i++) {
            if (!instance_exists(_antiaereos[i])) continue;
            
            var _pos_x = _centro_x + lengthdir_x((i - array_length(_antiaereos)/2) * 100, _dir_para_alvo + 90) + lengthdir_x(300, _dir_para_alvo);
            var _pos_y = _centro_y + lengthdir_y((i - array_length(_antiaereos)/2) * 100, _dir_para_alvo + 90) + lengthdir_y(300, _dir_para_alvo);
            
            array_push(_grupos_formacao, {
                unidade: _antiaereos[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "antiaereo",
                linha: "assalto_reserva"
            });
        }
    }
    
    // === FORMAÇÃO DISPERSÃO TÁTICA ===
    else if (_tipo_formacao == "dispersao_tatica") {
        // Espalhar unidades para atingir múltiplos alvos
        var _raio_min = 200;
        var _raio_max = 500;
        var _total_unidades = array_length(_infantaria) + array_length(_tanques);
        
        var _idx = 0;
        
        // Infantaria espalhada em arco
        for (var i = 0; i < array_length(_infantaria); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _angulo = random_range(0, 360);
            var _raio = random_range(_raio_min, _raio_max);
            
            var _pos_x = _alvo_x + lengthdir_x(_raio, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "dispersao_leve"
            });
            _idx++;
        }
        
        // Tanques em grupos menores
        var _grupos_tanques = ceil(array_length(_tanques) / 3);
        for (var i = 0; i < array_length(_tanques); i++) {
            if (!instance_exists(_tanques[i])) continue;
            
            var _grupo = i mod _grupos_tanques;
            var _angulo = (_grupo * 120) + random_range(-30, 30);
            var _raio = random_range(_raio_min + 100, _raio_max - 50);
            
            var _pos_x = _alvo_x + lengthdir_x(_raio, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _tanques[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "tanque",
                linha: "dispersao_pesada"
            });
        }
        
        // Antiaéreos protegendo flancos
        for (var i = 0; i < array_length(_antiaereos); i++) {
            if (!instance_exists(_antiaereos[i])) continue;
            
            var _angulo = (i mod 2 == 0) ? 90 : 270;
            var _raio = _raio_max + 50;
            
            var _pos_x = _alvo_x + lengthdir_x(_raio, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _antiaereos[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "antiaereo",
                linha: "dispersao_protecao"
            });
        }
    }
    
    // === FORMAÇÃO CERCO COMPLETO ===
    else if (_tipo_formacao == "cerco_completo") {
        // Círculo completo e denso ao redor do alvo
        var _raio_interno = 180;
        var _raio_externo = 280;
        var _total_unidades = array_length(_infantaria) + array_length(_tanques);
        
        // Camada interna com infantaria
        for (var i = 0; i < array_length(_infantaria); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _angulo = (i * 360) / max(array_length(_infantaria), 1);
            var _raio = _raio_interno + random_range(-20, 20);
            
            var _pos_x = _alvo_x + lengthdir_x(_raio, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "cerco_interno"
            });
        }
        
        // Camada externa com tanques
        for (var i = 0; i < array_length(_tanques); i++) {
            if (!instance_exists(_tanques[i])) continue;
            
            var _angulo = (i * 360) / max(array_length(_tanques), 1);
            var _raio = _raio_externo + random_range(-30, 30);
            
            var _pos_x = _alvo_x + lengthdir_x(_raio, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _tanques[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "tanque",
                linha: "cerco_externo"
            });
        }
        
        // Antiaéreos em posições estratégicas
        for (var i = 0; i < array_length(_antiaereos); i++) {
            if (!instance_exists(_antiaereos[i])) continue;
            
            var _angulo = (i * 180) / max(array_length(_antiaereos), 1);
            var _raio = _raio_externo + 100;
            
            var _pos_x = _alvo_x + lengthdir_x(_raio, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _antiaereos[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "antiaereo",
                linha: "cerco_protecao"
            });
        }
    }
    
    // === FORMAÇÃO EMBOSCADA EM V ===
    else if (_tipo_formacao == "emboscada_em_V") {
        // Formação em V para emboscada eficaz
        var _dir_para_alvo = point_direction(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y);
        var _dist = point_distance(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y) * 0.5;
        var _centro_x = _ia.base_x + lengthdir_x(_dist, _dir_para_alvo);
        var _centro_y = _ia.base_y + lengthdir_y(_dist, _dir_para_alvo);
        
        // Braço esquerdo do V
        var _idx_esq = 0;
        for (var i = 0; i < ceil(array_length(_infantaria) / 2); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _angulo = _dir_para_alvo - 45 - (_idx_esq * 10);
            var _dist_v = 150 + (_idx_esq * 80);
            
            var _pos_x = _centro_x + lengthdir_x(_dist_v, _angulo);
            var _pos_y = _centro_y + lengthdir_y(_dist_v, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "emboscada_V_esq"
            });
            _idx_esq++;
        }
        
        // Braço direito do V
        var _idx_dir = 0;
        for (var i = ceil(array_length(_infantaria) / 2); i < array_length(_infantaria); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _angulo = _dir_para_alvo + 45 + (_idx_dir * 10);
            var _dist_v = 150 + (_idx_dir * 80);
            
            var _pos_x = _centro_x + lengthdir_x(_dist_v, _angulo);
            var _pos_y = _centro_y + lengthdir_y(_dist_v, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "emboscada_V_dir"
            });
            _idx_dir++;
        }
        
        // Tanques no centro do V (ponto de mira)
        for (var i = 0; i < array_length(_tanques); i++) {
            if (!instance_exists(_tanques[i])) continue;
            
            var _offset_x = (i - array_length(_tanques)/2) * 100;
            var _pos_x = _centro_x + lengthdir_x(_offset_x, _dir_para_alvo + 90);
            var _pos_y = _centro_y + lengthdir_y(_offset_x, _dir_para_alvo + 90);
            
            array_push(_grupos_formacao, {
                unidade: _tanques[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "tanque",
                linha: "emboscada_V_centro"
            });
        }
        
        // Antiaéreos protegendo as pontas do V
        if (array_length(_antiaereos) > 0) {
            var _angulo_esq = _dir_para_alvo - 45;
            var _angulo_dir = _dir_para_alvo + 45;
            
            for (var i = 0; i < array_length(_antiaereos); i++) {
                if (!instance_exists(_antiaereos[i])) continue;
                
                var _angulo = (i mod 2 == 0) ? _angulo_esq : _angulo_dir;
                var _raio = 200;
                
                var _pos_x = _centro_x + lengthdir_x(_raio, _angulo);
                var _pos_y = _centro_y + lengthdir_y(_raio, _angulo);
                
                array_push(_grupos_formacao, {
                    unidade: _antiaereos[i],
                    destino_x: _pos_x,
                    destino_y: _pos_y,
                    tipo: "antiaereo",
                    linha: "emboscada_V_protecao"
                });
            }
        }
    }
    
    // === FORMAÇÃO PINCER BÁSICO ===
    else if (_tipo_formacao == "pincer_basico") {
        // Ataque limitado em pinça (dois grupos)
        var _dir_para_alvo = point_direction(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y);
        var _dist = point_distance(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y) * 0.7;
        
        // Grupo esquerdo
        var _idx_esq = 0;
        for (var i = 0; i < ceil(array_length(_infantaria) / 2); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _angulo = _dir_para_alvo - 30;
            var _dist_offset = 100 + (_idx_esq * 60);
            
            var _pos_x = _alvo_x + lengthdir_x(_dist, _dir_para_alvo) + lengthdir_x(_dist_offset, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_dist, _dir_para_alvo) + lengthdir_y(_dist_offset, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "pincer_esq"
            });
            _idx_esq++;
        }
        
        // Grupo direito
        var _idx_dir = 0;
        for (var i = ceil(array_length(_infantaria) / 2); i < array_length(_infantaria); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _angulo = _dir_para_alvo + 30;
            var _dist_offset = 100 + (_idx_dir * 60);
            
            var _pos_x = _alvo_x + lengthdir_x(_dist, _dir_para_alvo) + lengthdir_x(_dist_offset, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_dist, _dir_para_alvo) + lengthdir_y(_dist_offset, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "pincer_dir"
            });
            _idx_dir++;
        }
        
        // Tanques divididos entre os dois grupos
        for (var i = 0; i < array_length(_tanques); i++) {
            if (!instance_exists(_tanques[i])) continue;
            
            var _lado = (i mod 2 == 0) ? -15 : 15;
            var _angulo = _dir_para_alvo + _lado;
            var _dist_tanque = _dist + 80;
            
            var _pos_x = _alvo_x + lengthdir_x(_dist_tanque, _dir_para_alvo) + lengthdir_x(50, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_dist_tanque, _dir_para_alvo) + lengthdir_y(50, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _tanques[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "tanque",
                linha: "pincer_suporte"
            });
        }
        
        // Antiaéreos protegendo os flancos
        for (var i = 0; i < array_length(_antiaereos); i++) {
            if (!instance_exists(_antiaereos[i])) continue;
            
            var _angulo = (i mod 2 == 0) ? _dir_para_alvo - 90 : _dir_para_alvo + 90;
            var _raio = 150;
            
            var _pos_x = _alvo_x + lengthdir_x(_raio, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _antiaereos[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "antiaereo",
                linha: "pincer_protecao"
            });
        }
    }
    
    // === FORMAÇÃO DEFENSIVA ===
    else if (_tipo_formacao == "defensiva") {
        // Formação defensiva esperando reforços
        var _raio_defesa = 300;
        var _dir_para_alvo = point_direction(_ia.base_x, _ia.base_y, _alvo_x, _alvo_y);
        
        // Infantaria em posições defensivas (meio-círculo)
        for (var i = 0; i < array_length(_infantaria); i++) {
            if (!instance_exists(_infantaria[i])) continue;
            
            var _angulo = _dir_para_alvo + 180 + random_range(-60, 60); // Voltado para base
            var _raio = random_range(_raio_defesa - 50, _raio_defesa + 50);
            
            var _pos_x = _alvo_x + lengthdir_x(_raio, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _infantaria[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "infantaria",
                linha: "defesa_frente"
            });
        }
        
        // Tanques em posições de artilharia
        for (var i = 0; i < array_length(_tanques); i++) {
            if (!instance_exists(_tanques[i])) continue;
            
            var _angulo = _dir_para_alvo + 180 + random_range(-30, 30);
            var _raio = _raio_defesa + 100 + random_range(-50, 50);
            
            var _pos_x = _alvo_x + lengthdir_x(_raio, _angulo);
            var _pos_y = _alvo_y + lengthdir_y(_raio, _angulo);
            
            array_push(_grupos_formacao, {
                unidade: _tanques[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "tanque",
                linha: "defesa_artilharia"
            });
        }
        
        // Antiaéreos protegendo o céu
        for (var i = 0; i < array_length(_antiaereos); i++) {
            if (!instance_exists(_antiaereos[i])) continue;
            
            var _angulo = _dir_para_alvo + 180;
            var _raio = _raio_defesa - 100;
            
            var _pos_x = _alvo_x + lengthdir_x(_raio, _angulo + (i * 45));
            var _pos_y = _alvo_y + lengthdir_y(_raio, _angulo + (i * 45));
            
            array_push(_grupos_formacao, {
                unidade: _antiaereos[i],
                destino_x: _pos_x,
                destino_y: _pos_y,
                tipo: "antiaereo",
                linha: "defesa_antiaerea"
            });
        }
    }
    
    return _grupos_formacao;
}
