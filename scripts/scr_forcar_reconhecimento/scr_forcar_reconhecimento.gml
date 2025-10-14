/// @function scr_forcar_reconhecimento(_unidade_id, _area_x, _area_y, _raio)
/// @description Força uma unidade a realizar reconhecimento em uma área específica
/// @param {Id.Instance} _unidade_id ID da unidade que vai fazer reconhecimento
/// @param {Real} _area_x Coordenada X da área de reconhecimento
/// @param {Real} _area_y Coordenada Y da área de reconhecimento
/// @param {Real} _raio Raio da área de reconhecimento
/// @return {Bool} Retorna true se o reconhecimento foi iniciado

function scr_forcar_reconhecimento(_unidade_id, _area_x, _area_y, _raio) {
    // ===============================================
    // HEGEMONIA GLOBAL - FORÇAR RECONHECIMENTO
    // Sistema para forçar unidades a fazer reconhecimento
    // ===============================================
    
    if (!instance_exists(_unidade_id)) {
        show_debug_message("❌ Unidade não encontrada para reconhecimento");
        return false;
    }
    
    show_debug_message("🔍 Forçando reconhecimento em área: (" + string(_area_x) + ", " + string(_area_y) + ")");
    
    // Determinar tipo de unidade e aplicar lógica específica
    switch (_unidade_id.object_index) {
        case obj_caca_f5:
            scr_reconhecimento_f5(_unidade_id, _area_x, _area_y, _raio);
            break;
            
        case obj_helicoptero_militar:
            scr_reconhecimento_helicoptero(_unidade_id, _area_x, _area_y, _raio);
            break;
            
        case obj_lancha_patrulha:
            scr_reconhecimento_naval(_unidade_id, _area_x, _area_y, _raio);
            break;
            
        default:
            scr_reconhecimento_generico(_unidade_id, _area_x, _area_y, _raio);
            break;
    }
    
    return true;
}

/// @function scr_reconhecimento_f5(_f5_id, _area_x, _area_y, _raio)
/// @description Reconhecimento específico para F-5
/// @param {Id.Instance} _f5_id ID do F-5
/// @param {Real} _area_x Coordenada X da área
/// @param {Real} _area_y Coordenada Y da área
/// @param {Real} _raio Raio da área
/// @return {undefined}

function scr_reconhecimento_f5(_f5_id, _area_x, _area_y, _raio) {
    with (_f5_id) {
        // Cancelar outras missões
        alvo_seguir = noone;
        estado = ESTADO_F5.VOANDO;
        
        // Definir área de reconhecimento
        area_reconhecimento_x = _area_x;
        area_reconhecimento_y = _area_y;
        raio_reconhecimento = _raio;
        modo_reconhecimento = true;
        
        // Criar pontos de patrulha em círculo
        ds_list_clear(pontos_patrulha);
        var _pontos = 8; // 8 pontos em círculo
        for (var i = 0; i < _pontos; i++) {
            var _angulo = (360 / _pontos) * i;
            var _px = _area_x + lengthdir_x(_raio, _angulo);
            var _py = _area_y + lengthdir_y(_raio, _angulo);
            ds_list_add(pontos_patrulha, [_px, _py]);
        }
        
        // Iniciar patrulha de reconhecimento
        estado = ESTADO_F5.PATRULHA;
        indice_patrulha_atual = 0;
        var _ponto = pontos_patrulha[| 0];
        destino_x = _ponto[0];
        destino_y = _ponto[1];
        
        show_debug_message("✈️ F-5 iniciando reconhecimento aéreo");
    }
}

/// @function scr_reconhecimento_helicoptero(_heli_id, _area_x, _area_y, _raio)
/// @description Reconhecimento específico para Helicóptero
/// @param {Id.Instance} _heli_id ID do Helicóptero
/// @param {Real} _area_x Coordenada X da área
/// @param {Real} _area_y Coordenada Y da área
/// @param {Real} _raio Raio da área
/// @return {undefined}

function scr_reconhecimento_helicoptero(_heli_id, _area_x, _area_y, _raio) {
    with (_heli_id) {
        // Cancelar outras missões
        alvo_seguir = noone;
        estado = "movendo";
        
        // Definir área de reconhecimento
        area_reconhecimento_x = _area_x;
        area_reconhecimento_y = _area_y;
        raio_reconhecimento = _raio;
        modo_reconhecimento = true;
        
        // Criar pontos de patrulha em círculo
        ds_list_clear(pontos_patrulha);
        var _pontos = 6; // 6 pontos em círculo
        for (var i = 0; i < _pontos; i++) {
            var _angulo = (360 / _pontos) * i;
            var _px = _area_x + lengthdir_x(_raio, _angulo);
            var _py = _area_y + lengthdir_y(_raio, _angulo);
            ds_list_add(pontos_patrulha, [_px, _py]);
        }
        
        // Iniciar patrulha de reconhecimento
        estado = "patrulhando";
        indice_patrulha_atual = 0;
        var _ponto = pontos_patrulha[| 0];
        destino_x = _ponto[0];
        destino_y = _ponto[1];
        
        show_debug_message("🚁 Helicóptero iniciando reconhecimento");
    }
}

/// @function scr_reconhecimento_naval(_navio_id, _area_x, _area_y, _raio)
/// @description Reconhecimento específico para unidades navais
/// @param {Id.Instance} _navio_id ID da unidade naval
/// @param {Real} _area_x Coordenada X da área
/// @param {Real} _area_y Coordenada Y da área
/// @param {Real} _raio Raio da área
/// @return {undefined}

function scr_reconhecimento_naval(_navio_id, _area_x, _area_y, _raio) {
    with (_navio_id) {
        // Cancelar outras missões
        alvo = noone;
        estado = "movendo";
        
        // Definir área de reconhecimento
        area_reconhecimento_x = _area_x;
        area_reconhecimento_y = _area_y;
        raio_reconhecimento = _raio;
        modo_reconhecimento = true;
        
        // Criar pontos de patrulha em círculo
        ds_list_clear(pontos_patrulha);
        var _pontos = 4; // 4 pontos em quadrado
        for (var i = 0; i < _pontos; i++) {
            var _angulo = (360 / _pontos) * i;
            var _px = _area_x + lengthdir_x(_raio, _angulo);
            var _py = _area_y + lengthdir_y(_raio, _angulo);
            ds_list_add(pontos_patrulha, [_px, _py]);
        }
        
        // Iniciar patrulha de reconhecimento
        estado = "patrulhando";
        indice_patrulha_atual = 0;
        var _ponto = pontos_patrulha[| 0];
        destino_x = _ponto[0];
        destino_y = _ponto[1];
        
        show_debug_message("🚢 Unidade naval iniciando reconhecimento");
    }
}

/// @function scr_reconhecimento_generico(_unidade_id, _area_x, _area_y, _raio)
/// @description Reconhecimento genérico para qualquer unidade
/// @param {Id.Instance} _unidade_id ID da unidade
/// @param {Real} _area_x Coordenada X da área
/// @param {Real} _area_y Coordenada Y da área
/// @param {Real} _raio Raio da área
/// @return {undefined}

function scr_reconhecimento_generico(_unidade_id, _area_x, _area_y, _raio) {
    with (_unidade_id) {
        // Movimento simples para a área
        destino_x = _area_x;
        destino_y = _area_y;
        estado = "movendo";
        
        show_debug_message("🔍 Unidade genérica movendo para área de reconhecimento");
    }
}

/// @function scr_cancelar_reconhecimento(_unidade_id)
/// @description Cancela o reconhecimento de uma unidade
/// @param {Id.Instance} _unidade_id ID da unidade
/// @return {undefined}

function scr_cancelar_reconhecimento(_unidade_id) {
    if (!instance_exists(_unidade_id)) {
        return;
    }
    
    with (_unidade_id) {
        modo_reconhecimento = false;
        area_reconhecimento_x = 0;
        area_reconhecimento_y = 0;
        raio_reconhecimento = 0;
        
        // Voltar ao estado normal
        if (variable_instance_exists(id, "estado")) {
            estado = "parado";
        }
        
        show_debug_message("❌ Reconhecimento cancelado");
    }
}