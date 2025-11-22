// ===============================================
// HEGEMONIA GLOBAL - NAVIO DE CARGA (Step)
// ===============================================

// Herdar lógica básica de navegação
event_inherited();

// === 1. NAVEGAÇÃO NORMAL ===
if (estado == LanchaState.PARADO && ds_list_size(rota_waypoints) > 0) {
    // Começar a navegar
    estado = LanchaState.MOVENDO;
    indice_waypoint_atual = 0;
    var _waypoint = rota_waypoints[| indice_waypoint_atual];
    destino_x = _waypoint.x;
    destino_y = _waypoint.y;
    target_x = _waypoint.x;
    target_y = _waypoint.y;
}

// === 2. MOVIMENTO ENTRE WAYPOINTS ===
if (estado == LanchaState.MOVENDO && ds_list_size(rota_waypoints) > 0) {
    var _waypoint = rota_waypoints[| indice_waypoint_atual];
    var _dist = point_distance(x, y, _waypoint.x, _waypoint.y);
    
    if (_dist < 30) {
        // Chegou no waypoint
        estado = LanchaState.PARADO;
        timer_espera = tempo_espera_waypoint;
    }
}

// === 3. ESPERA NOS WAYPOINTS ===
if (estado == LanchaState.PARADO && timer_espera > 0) {
    timer_espera--;
    if (timer_espera <= 0 && ds_list_size(rota_waypoints) > 0) {
        // Ir para próximo waypoint
        indice_waypoint_atual = (indice_waypoint_atual + 1) % ds_list_size(rota_waypoints);
        estado = LanchaState.MOVENDO;
        var _proximo = rota_waypoints[| indice_waypoint_atual];
        destino_x = _proximo.x;
        destino_y = _proximo.y;
        target_x = _proximo.x;
        target_y = _proximo.y;
    }
}

// === 4. VERIFICAR DESTRUIÇÃO ===
if (hp_atual <= 0) {
    // Despawnar carga quando navio é destruído
    show_debug_message("💥 Navio de Carga destruído! Perdeu " + string(valor_carga) + " 💰");
    instance_destroy();
}

// === 5. SEGURANÇA: NUNCA ATACA ===
// Navios de carga são passivos
modo_combate = LanchaMode.PASSIVO;
estado_anterior = estado;
