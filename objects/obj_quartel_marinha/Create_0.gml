// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema 100% Independente (SEM HERANÇA)
// ===============================================

// === CONFIGURAÇÕES BÁSICAS ===
custo_dinheiro = 600;
custo_minerio = 400;
hp_max = 120; // ✅ ATUALIZADO: Todos os quarteis têm 120 HP
hp_atual = 120; // ✅ ATUALIZADO: Todos os quarteis têm 120 HP
nacao_proprietaria = 1;

// === SISTEMA DE BARRA DE VIDA ===
mostrar_barra_vida = false;
timer_barra_vida = 0;
duracao_barra_vida = 300; // 5 segundos
barra_vida_altura = 8;
barra_vida_largura = 80;

// === SISTEMA DE PRODUÇÃO NAVAL (IGUAL AO QUARTEL MILITAR) ===
fila_recrutamento = ds_queue_create(); // ✅ CORREÇÃO: Usar fila_recrutamento igual ao quartel militar
fila_producao = fila_recrutamento; // ✅ COMPATIBILIDADE: Manter fila_producao para compatibilidade
timer_producao = 0;
produzindo = false;
esta_treinando = false; // ✅ CORREÇÃO: Variável de controle de treinamento (igual ao quartel militar)
tempo_treinamento_restante = 0; // ✅ CORREÇÃO: Timer de treinamento (igual ao quartel militar)
unidades_produzidas = 0;

// === CONFIGURAÇÕES DE UNIDADES NAVAL SIMPLIFICADAS ===
unidades_disponiveis = ds_list_create();

// ✅ Lancha Patrulha - 4 segundos máximo
if (object_exists(obj_lancha_patrulha)) {
    var _sprite_lancha = noone;
    // Tentar obter o sprite do objeto diretamente
    var _sprite_index = object_get_sprite(obj_lancha_patrulha);
    if (_sprite_index != -1 && sprite_exists(_sprite_index)) {
        _sprite_lancha = _sprite_index;
    } else {
        // Fallback: tentar pelo nome do sprite
        var _sprite_name = asset_get_index("spr_lancha_patrulha");
        if (_sprite_name != -1 && sprite_exists(_sprite_name)) {
            _sprite_lancha = _sprite_name;
        } else {
            // Último fallback: usar spr_lancha
            var _sprite_alt = asset_get_index("spr_lancha");
            if (_sprite_alt != -1 && sprite_exists(_sprite_alt)) {
                _sprite_lancha = _sprite_alt;
            }
        }
    }
    
    ds_list_add(unidades_disponiveis, {
        nome: "Lancha Patrulha",
        objeto: obj_lancha_patrulha,
        sprite: _sprite_lancha,
        custo_dinheiro: 50,
        custo_populacao: 1,
        tempo_treino: 180,    // ✅ MUDADO: 3 SEGUNDOS (180 frames) - MÁXIMO
        descricao: "Unidade naval rápida para patrulhamento"
    });
    show_debug_message("✅ Lancha Patrulha adicionada à lista de unidades! Sprite: " + string(_sprite_lancha));
} else {
    show_debug_message("❌ ERRO: obj_lancha_patrulha não existe!");
}

// ✅ Constellation - 4 segundos máximo (se existir)
if (object_exists(obj_Constellation)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Constellation",
        objeto: obj_Constellation,
        sprite: spr_Constellation,
        custo_dinheiro: 2500,
        custo_populacao: 12,
        tempo_treino: 180,    // ✅ MUDADO: 3 SEGUNDOS (180 frames) - MÁXIMO
        descricao: "Navio de guerra avançado com sistema de mísseis"
    });
    show_debug_message("✅ Constellation adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_Constellation não existe!");
}

// ✅ Independence - 4 segundos máximo (se existir)
if (object_exists(obj_Independence)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Independence",
        objeto: obj_Independence,
        sprite: spr_Independence,
        custo_dinheiro: 5000,
        custo_populacao: 20,
        tempo_treino: 180,    // ✅ MUDADO: 3 SEGUNDOS (180 frames) - MÁXIMO
        descricao: "Fragata pesada com mísseis Hash, Sky e Lit. Sistema de canhão avançado"
    });
    show_debug_message("✅ Independence adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_Independence não existe!");
}

// ✅ Ww-Hendrick - 4 segundos máximo (se existir)
if (object_exists(obj_wwhendrick)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Ww-Hendrick",
        objeto: obj_wwhendrick,
        sprite: spr_wwhendrick,
        custo_dinheiro: 2500,
        custo_populacao: 12,
        tempo_treino: 180,    // ✅ MUDADO: 3 SEGUNDOS (180 frames) - MÁXIMO
        descricao: "Submarino furtivo com sistema de submersão. Controles: O/P/K/L | Clique para submergir/emergir"
    });
    show_debug_message("✅ Ww-Hendrick adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_wwhendrick não existe!");
}

// ✅ Porta-Aviões Ronald Reagan - 4 segundos máximo (se existir)
if (object_exists(obj_RonaldReagan)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Ronald Reagan",
        objeto: obj_RonaldReagan,
        sprite: spr_RonaldReagan,
        custo_dinheiro: 12000,
        custo_populacao: 60,
        tempo_treino: 180,    // ✅ MUDADO: 3 SEGUNDOS (180 frames) - MÁXIMO
        descricao: "Porta-Aviões nuclear. Transporta 35 aviões, 20 veículos e 100 soldados (155 unidades). HP: 4000."
    });
    show_debug_message("✅ Porta-Aviões Ronald Reagan adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_RonaldReagan não existe!");
}

// Verificar se obj_canhao existe
if (object_exists(obj_canhao)) {
    show_debug_message("✅ obj_canhao existe!");
} else {
    show_debug_message("❌ ERRO: obj_canhao não existe!");
}

// NOTA: obj_tiro_canhao será criado quando necessário pela Independence

// === SISTEMA DE SELEÇÃO ===
selecionado = false;
menu_recrutamento = noone;
unidade_selecionada = 0; // ✅ CORREÇÃO: Índice da unidade selecionada (igual ao quartel militar)

// === CONFIGURAÇÕES VISUAIS ===
image_blend = make_color_rgb(100, 150, 255); // Azul marinho

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.AGUA; // Quartel naval só em água

show_debug_message("Quartel de Marinha construído e pronto para produção naval!");