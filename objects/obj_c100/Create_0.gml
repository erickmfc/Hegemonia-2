// ===============================================
// HEGEMONIA GLOBAL - C-100 Transporte (Create)
// ===============================================

// Herdar a configuração do F-5
event_inherited();

// Identidade
nome_unidade = "C-100";

// ✅ CORREÇÃO: Definir estado inicial explícito
estado = "pousado";

// Ajustes de performance (mais lento que F-5)
velocidade_maxima *= 0.7;
velocidade_rotacao *= 0.6;

// Guardar valores base para penalidades
velocidade_base = velocidade_maxima;
curva_base = velocidade_rotacao;

// Carga (limite de 20 unidades com pesos realistas)
capacidade_total = 20;
carga_usada = 0;
lista_carga = ds_list_create();

// ✅ Pesos realistas (definidos como constantes)
PESO_INFANTARIA = 1;
PESO_ANTIAEREO = 2;
PESO_TANQUE = 4;
PESO_BLINDADO = 3;

// Estados/flags
modo_receber_carga = false;
modo_evadindo = false;
penalidade_carga_aplicada = false;
carga_anterior = 0; // ✅ Para detectar mudanças de carga
flares_ativos = 0; // ✅ Contador de flares

// ✅ SISTEMA DE 3 MODOS
modo_transporte = "fechado";  // "fechado" -> "embarcando" -> "embarcado" -> "desembarcando"
pode_voar = true;

// ✅ Sistema de atração de unidades
unidades_indo_embarcar = ds_list_create();
raio_atracao = 150; // Raio para detectar unidades indo embarcar

// Flares (cooldown reduzido para 2 segundos)
flare_cooldown_max = 2 * room_speed;
flare_cooldown = 0;
flare_duracao = 4 * room_speed;
flare_timer_ativo = 0;

show_debug_message("✈️ C-100 criado - Transporte pronto para carga e flares");

// --- FUNÇÕES AUXILIARES DO C-100 ---

// ✅ Calcular peso com validação de tipo
calcular_peso_unidade = function(unidade) {
    if (!instance_exists(unidade)) return 0;
    
    var _nome = object_get_name(unidade.object_index);
    
    switch (_nome) {
        case "obj_infantaria": return PESO_INFANTARIA;
        case "obj_soldado_antiaereo": return PESO_ANTIAEREO;
        case "obj_tanque": return PESO_TANQUE;
        case "obj_blindado_antiaereo": return PESO_BLINDADO;
        default: return 1; // Unidades desconhecidas = 1 slot
    }
}

// ✅ Verificar se unidade é embarcável
eh_unidade_embarcavel = function(unidade) {
    if (!instance_exists(unidade)) return false;
    if (unidade.id == id) return false; // Não embarcar a si mesmo
    
    // Verificar se é do jogador
    if (!variable_instance_exists(unidade, "nacao_proprietaria")) return false;
    if (unidade.nacao_proprietaria != nacao_proprietaria) return false;
    
    // Verificar se é terrestre (não tem altitude ou está no chão)
    if (variable_instance_exists(unidade, "altura_voo")) {
        if (unidade.altura_voo > 0) return false;
    }
    
    // Verificar se não está em outro transporte
    if (variable_instance_exists(unidade, "visible")) {
        if (!unidade.visible) return false;
    }
    
    return true;
}

// ✅ Embarcar com validação completa
embarcar_unidade = function(unidade, peso) {
    if (!instance_exists(unidade)) return false;
    if (carga_usada + peso > capacidade_total) return false;
    
    // Criar registro da carga
    var _carga = {
        tipo: object_get_name(unidade.object_index),
        peso: peso,
        ref_id: unidade.id,
        x_original: unidade.x,
        y_original: unidade.y
    };
    
    // Adicionar à lista
    ds_list_add(lista_carga, _carga);
    carga_usada += peso;
    
    // Esconder unidade
    unidade.visible = false;
    if (variable_instance_exists(unidade, "active")) unidade.active = false;
    
    show_debug_message("✅ Embarcou " + _carga.tipo + " (peso: " + string(peso) + ") - " + string(carga_usada) + "/" + string(capacidade_total));
    return true;
}

// ✅ Desembarcar com validação de existência
desembarcar_tropas = function() {
    var _count = ds_list_size(lista_carga);
    if (_count == 0) return;
    
    show_debug_message("🚁 Desembarcando " + string(_count) + " unidades");
    
    for (var i = 0; i < _count; i++) {
        var _carga = lista_carga[| i];
        var _unidade = _carga.ref_id;
        
        if (instance_exists(_unidade)) {
            // Reativar unidade
            _unidade.visible = true;
            if (variable_instance_exists(_unidade, "active")) _unidade.active = true;
            
            // Posicionar em anel ao redor do C-100
            var _ang = (i * 360 / _count) + random(30);
            var _raio = 80 + random(40);
            _unidade.x = x + lengthdir_x(_raio, _ang);
            _unidade.y = y + lengthdir_y(_raio, _ang);
        }
    }
    
    // Limpar lista
    ds_list_clear(lista_carga);
    carga_usada = 0;
}

// ✅ Flares com limitação de instâncias
ativar_flares = function() {
    if (modo_evadindo) return false;
    if (flare_cooldown > 0) return false;
    if (flares_ativos > 0) return false; // Não criar novos se já existem
    
    modo_evadindo = true;
    flare_timer_ativo = flare_duracao;
    flare_cooldown = flare_cooldown_max;
    
    // Criar flares visuais
    var n = 8;
    for (var i = 0; i < n; i++) {
        var ang = image_angle + 180 + irandom_range(-40, 40);
        var fx = instance_create_layer(
            x - lengthdir_x(12, ang), 
            y - lengthdir_y(12, ang), 
            "Instances", 
            obj_fumaca_missil
        );
        
        if (instance_exists(fx)) {
            fx.is_flare = true;
            fx.heat = 100;
            fx.flare_ttl = flare_duracao;
            fx.dono = id;
            flares_ativos++;
        }
    }
    
    show_debug_message("🎆 Flares ativados (" + string(flares_ativos) + ")");
    return true;
}

// ✅ Penalidades aplicadas apenas quando carga muda
atualizar_penalidade_carga = function() {
    if (carga_usada == carga_anterior) return; // Sem mudanças
    
    if (carga_usada > 0) {
        // Aplicar penalidade
        velocidade_maxima = velocidade_base * 0.9;
        velocidade_rotacao = curva_base * 1.15;
        show_debug_message("⚠️ Penalidade aplicada: " + string(carga_usada) + " slots");
    } else {
        // Remover penalidade
        velocidade_maxima = velocidade_base;
        velocidade_rotacao = curva_base;
        show_debug_message("✅ Penalidade removida");
    }
    
    carga_anterior = carga_usada;
}