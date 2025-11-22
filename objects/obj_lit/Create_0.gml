// ===============================================
// HEGEMONIA GLOBAL - MÍSSIL LIT (LIGHT INTERCEPTOR TACTICAL)
// Míssil Híbrido Avançado - Ar-Ar / Terra-Terra / Marítimo
// ===============================================

// === CARACTERÍSTICAS DO LIT ===
// • Versátil: Funciona contra múltiplos tipos de alvo
// • Inteligente: Sistema de predição e rastreamento
// • Rápido: Velocidade adaptativa baseada no tipo de alvo
// • Explosivo: Dano em área balanceado

show_debug_message("🔥 ===== MÍSSIL LIT CRIADO =====");

// === PROPRIEDADES BASE ===
dano = 80;                          // Dano base (ajustado por tipo de alvo)
alvo = noone;                       // Alvo a ser interceptado
dono = noone;                       // Unidade que disparou
timer_vida = 500;                   // Tempo de vida: 8.3 segundos (muito maior que outros)
distancia_inicial = 0;              // Distância quando foi disparado

// ✅ APLICAR MULTIPLICADOR DE DANO DO DONO (sistema de gerações)
if (instance_exists(dono) && variable_instance_exists(dono, "dano_multiplier")) {
    dano = floor(dano * dono.dano_multiplier);
    dano_area = floor(dano_area * dono.dano_multiplier);
}

// === SISTEMA ADAPTATIVO ===
tipo_alvo = "desconhecido";         // "aereo", "terrestre", "maritimo", "submarino"
velocidade_adaptativa = true;       // Muda velocidade conforme o alvo
velocidade_base = 10;               // Velocidade padrão
speed = velocidade_base;

// === RASTREAMENTO E PREDIÇÃO ===
predicao_ativa = true;              // Ativa predição de posição
precisao_rastreamento = 0.95;       // 95% de precisão (muito alta)
correcao_trajetoria_frames = 3;     // Corrige a cada 3 frames
contador_correcao = 0;

// === DANO EM ÁREA (ESPECIAL DO LIT) ===
dano_area = 1500;                   // Dano em área MAIOR que outros
raio_dano_area = 400;               // Raio de 400px (maior explosão)

// === EFEITOS VISUAIS ===
image_xscale = 0.4;                 // Escala do sprite (50% menor - era 0.8)
image_yscale = 0.4;
image_blend = make_color_rgb(255, 200, 0);  // Amarelo ouro (cor especial do LIT)
image_alpha = 1.0;
depth = -1001;
visible = true;

// === SISTEMA DE DETECÇÃO DE TIPO DE ALVO ===
func_detectar_tipo_alvo = function() {
    if (!instance_exists(alvo)) return "desconhecido";
    
    var _nome_alvo = object_get_name(alvo.object_index);
    
    // Aéreos
    if (_nome_alvo == "obj_helicoptero_militar" || 
        _nome_alvo == "obj_caca_f5" || 
        _nome_alvo == "obj_f6" ||
        _nome_alvo == "obj_f15" ||
        _nome_alvo == "obj_c100") {
        return "aereo";
    }
    
    // Marítimos/Navios
    if (_nome_alvo == "obj_Constellation" || 
        _nome_alvo == "obj_Independence" || 
        _nome_alvo == "obj_RonaldReagan" ||
        _nome_alvo == "obj_navio_base" ||
        _nome_alvo == "obj_wwhendrick" ||
        _nome_alvo == "obj_lancha_patrulha") {
        return "maritimo";
    }
    
    // Submarinos
    if (_nome_alvo == "obj_submarino_base" || _nome_alvo == "obj_submarino") {
        return "submarino";
    }
    
    // Terrestres
    if (_nome_alvo == "obj_tanque" || 
        _nome_alvo == "obj_infantaria" || 
        _nome_alvo == "obj_M1A_Abrams" ||
        _nome_alvo == "obj_gepard" ||
        _nome_alvo == "obj_soldado_antiaereo" ||
        _nome_alvo == "obj_blindado_antiaereo") {
        return "terrestre";
    }
    
    return "desconhecido";
}

// === SISTEMA DE VELOCIDADE ADAPTATIVA ===
func_ajustar_velocidade = function() {
    if (!velocidade_adaptativa) return;
    
    switch(tipo_alvo) {
        case "aereo":
            speed = 12;           // Mais rápido contra aéreos (precisão)
            break;
        case "maritimo":
            speed = 8;            // Velocidade moderada para navios
            break;
        case "submarino":
            speed = 7;            // Mais lento contra submarinos (precisão subaquática)
            break;
        case "terrestre":
            speed = 10;           // Velocidade alta contra terrestres
            break;
        default:
            speed = velocidade_base;
            break;
    }
}

// === DETECÇÃO INICIAL ===
tipo_alvo = func_detectar_tipo_alvo();
func_ajustar_velocidade();

// === VARIÁVEIS DE DEBUG ===
show_debug_message("🎯 Tipo de alvo detectado: " + tipo_alvo);
show_debug_message("⚡ Velocidade: " + string(speed) + "px/frame");
show_debug_message("💥 Dano: " + string(dano) + " | Dano em Área: " + string(dano_area) + "px (raio: " + string(raio_dano_area) + ")");