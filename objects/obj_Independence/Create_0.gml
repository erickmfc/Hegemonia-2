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

// === CONFIGURAÇÕES DE COMBATE ===
hp_atual = 1600; // Dobro da Constellation (800 * 2)
hp_max = 1600;
velocidade_movimento = 1.95; // Mais lento que Constellation (2.5 * 0.78)
radar_alcance = 1000; // IGUAL aos outros navios
missil_alcance = 1000; // IGUAL aos outros navios
missil_max_alcance = 1000; // Alcance máximo de mísseis
alcance_ataque = missil_alcance;
alcance_visao = radar_alcance; // Alcance de visão igual ao radar
dano_ataque = 100;
reload_time = 120;

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

// === SISTEMA DE MÍSSEIS PERSONALIZADO ===
pode_disparar_missil = false; // Independence usa sistema próprio de mísseis múltiplos (Step_1.gml)
missil_timer_multi = 0; // Timer de mísseis para sistema múltiplo
missil_cooldown_multi = 90; // Cooldown de mísseis
missil_timer_hash = 0; // Timer para míssil Hash (pesado)
missil_timer_iron = 0; // Timer para míssil Ironclad

// === SOBRESCREVER func_atacar_alvo PARA NÃO USAR TIRO_SIMPLES ===
// A Independence USA MÍSSEIS (SkyFury/Ironclad) e Canhão com obj_tiro_canhao
// O sistema de ataque está no Step_1.gml
func_atacar_alvo = function() {
    // Mísseis e canhão gerenciados no Step_1.gml
    if (!instance_exists(alvo_unidade)) {
        alvo_unidade = noone;
        estado = LanchaState.PARADO;
        metralhadora_ativa = false; // Garantir que o canhão pare
        return;
    }
    
    // Apenas definir estado de ataque, sem criar NENHUM projétil aqui
    var d = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
    if (d <= missil_alcance) {
        estado = LanchaState.ATACANDO;
        // Todo o sistema de ataque está no Step_1.gml
        // - Mísseis SkyFury para alvos aéreos
        // - Mísseis Ironclad para alvos terrestres
        // - Canhão com obj_tiro_canhao para alvos terrestres/navais
    } else {
        ordem_mover(alvo_unidade.x, alvo_unidade.y);
        metralhadora_ativa = false; // Desativar canhão se fora de alcance
    }
}

// === SISTEMA DE DEBUG ===
debug_timer = 0;
