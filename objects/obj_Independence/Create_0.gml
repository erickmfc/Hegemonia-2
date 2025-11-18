/// @description Inicialização da Fragata Independence
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE (HERDA DE NAVIO_BASE)
// Fragata com Dobro de Vida e 0.9x Velocidade da Constellation
// ===============================================

// ✅ CORREÇÃO GM2040: Herdar do pai com verificação
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === CONFIGURAÇÕES BÁSICAS ===
nome_unidade = "Independence";
descricao = "Fragata com canhão e mísseis SkyFury/Ironclad";
custo = 1000;

// === VARIÁVEIS DE CONTROLE E NAVEGAÇÃO ===
// ✅ CORREÇÃO: Inicializar variáveis de controle que faltavam
if (!variable_instance_exists(id, "modo_combate")) {
    modo_combate = LanchaMode.PASSIVO;
}
if (!variable_instance_exists(id, "pontos_patrulha")) {
    pontos_patrulha = ds_list_create();
}
if (!variable_instance_exists(id, "indice_patrulha_atual")) {
    indice_patrulha_atual = 0;
}
if (!variable_instance_exists(id, "direcao_patrulha")) {
    direcao_patrulha = 1; // 1 = horário (avançar), -1 = anti-horário (retroceder)
}
if (!variable_instance_exists(id, "timer_verificacao_inimigos")) {
    timer_verificacao_inimigos = 0;
}
if (!variable_instance_exists(id, "intervalo_verificacao_inimigos")) {
    intervalo_verificacao_inimigos = 30; // Verificar inimigos a cada 30 frames
}
if (!variable_instance_exists(id, "estado_anterior")) {
    estado_anterior = LanchaState.PARADO;
}
if (!variable_instance_exists(id, "selecionado")) {
    selecionado = false;
}

// === VARIÁVEIS DE MOVIMENTO E DESTINO ===
// ✅ CORREÇÃO: Inicializar variáveis de destino que faltavam
if (!variable_instance_exists(id, "destino_x")) {
    destino_x = x;
}
if (!variable_instance_exists(id, "destino_y")) {
    destino_y = y;
}
if (!variable_instance_exists(id, "alvo_x")) {
    alvo_x = x;
}
if (!variable_instance_exists(id, "alvo_y")) {
    alvo_y = y;
}
if (!variable_instance_exists(id, "alvo_unidade")) {
    alvo_unidade = noone;
}
if (!variable_instance_exists(id, "estado")) {
    estado = LanchaState.PARADO;
}
if (!variable_instance_exists(id, "velocidade_rotacao")) {
    velocidade_rotacao = 0.8; // Velocidade de rotação em graus por frame
}
if (!variable_instance_exists(id, "reload_timer")) {
    reload_timer = 0;
}

// === CONFIGURAÇÕES DE COMBATE ===
// ✅ CORREÇÃO: Copiar stats de ataque do Constellation
hp_atual = 1600; // Dobro da Constellation (800 * 2)
hp_max = 1600;
velocidade_movimento = 1.2; // IGUAL ao Constellation
radar_alcance = 1000; // IGUAL ao Constellation
missil_alcance = 1000; // IGUAL ao Constellation
missil_max_alcance = 1000; // Alcance máximo de mísseis
alcance_ataque = missil_alcance;
alcance_visao = radar_alcance; // Alcance de visão igual ao radar
dano_ataque = 1000; // ✅ CORREÇÃO: IGUAL ao Constellation (1000)
reload_time = 120; // ✅ CORREÇÃO: IGUAL ao Constellation (120)

// Variáveis de mísseis
missil_timer = 0;
missil_cooldown = 90;

// === VARIÁVEIS DE FEEDBACK ===
ultima_acao = "nenhuma";
cor_feedback = c_white;
feedback_timer = 0;

// === SISTEMA DE CANHÃO ===
canhao_instancia = noone; // Instância do canhão
canhao_offset_x = 0; // Offset X do canhão (centro do navio)
canhao_offset_y = 0; // Offset Y do canhão (centro do navio)

// === SISTEMA DE METRALHADORA (CANHÃO) ===
metralhadora_ativa = false;
metralhadora_timer = 0;
metralhadora_intervalo = 3; // 3 frames entre tiros = ~20 tiro/segundo
metralhadora_duracao = 180; // 3 segundos de metralhadora (180 frames)
metralhadora_tiros = 0;
metralhadora_max_tiros = 60; // 60 tiros × 3 frames = 180 frames = 3 segundos
metralhadora_cooldown_timer = 0; // Timer de pausa
metralhadora_cooldown_duration = 180; // 3 segundos de pausa (180 frames)

// === SISTEMA DE MÍSSEIS ===
// ✅ CORREÇÃO: Habilitar sistema padrão do obj_navio_base (igual ao Constellation)
pode_disparar_missil = true; // Independence usa sistema padrão do obj_navio_base (órbita inteligente)
// Sistema de múltiplos alvos (Step_1.gml) foi desabilitado para usar sistema padrão

// ✅ CORREÇÃO: Usar sistema padrão do obj_navio_base (igual ao Constellation)
// O sistema de ataque padrão já está implementado no obj_navio_base com órbita inteligente
// Não precisa sobrescrever func_atacar_alvo - o sistema padrão funciona perfeitamente

// === SISTEMA DE DEBUG ===
debug_timer = 0;

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

// === GARANTIR VISIBILIDADE E APARÊNCIA ===
// ✅ CORREÇÃO: Garantir que o navio seja visível e tenha sprite
visible = true;
image_alpha = 1.0;
if (sprite_index == -1 || !sprite_exists(sprite_index)) {
    var _spr_independence = asset_get_index("spr_Independence");
    if (_spr_independence != -1 && sprite_exists(_spr_independence)) {
        sprite_index = _spr_independence;
    }
}

// === GARANTIR NAÇÃO ===
if (!variable_instance_exists(id, "nacao_proprietaria")) {
    nacao_proprietaria = 1; // Jogador por padrão
}

// === GARANTIR TERRAIN ===
if (!variable_instance_exists(id, "terrenos_permitidos")) {
    terrenos_permitidos = [TERRAIN.AGUA]; // Só água
}

// === DEBUG DE CRIAÇÃO ===
show_debug_message("🚢 Independence criado - HP: " + string(hp_atual) + "/" + string(hp_max) + " | Velocidade: " + string(velocidade_movimento) + " | Posição: (" + string(x) + ", " + string(y) + ")");