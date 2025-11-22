// ===============================================
// HEGEMONIA GLOBAL - ESTRUTURA: QUARTEL
// Sistema Original com Menu de Recrutamento
// ===============================================

// ✅ CORREÇÃO: Verificar se o objeto tem parent antes de chamar event_inherited
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 400;
custo_minerio = 250;

// === SISTEMA DE VIDA ===
hp_max = 120; // ✅ ATUALIZADO: Todos os quarteis têm 120 HP
hp_atual = 120; // ✅ ATUALIZADO: Todos os quarteis têm 120 HP
destrutivel = true; // ✅ Quartel pode ser destruído 

// === CONFIGURAÇÕES DE PRODUÇÃO ===
producao_por_ciclo = 0; // Não produz recursos automáticos
tipo_recurso = "militar"; // Tipo especial para identificar como estrutura militar

// === CORREÇÃO CRÍTICA: DESATIVAR ALARME DE PRODUÇÃO ===
// O quartel não deve produzir recursos automaticamente como outras estruturas
// Ele usa o sistema de FILA no Step_0, não o Alarm_0
// ✅ GARANTIR QUE ALARME ESTÁ DESATIVADO (o pai pode ter ativado)
alarm[0] = -1; // Desativa o alarme de produção automática
// ✅ VERIFICAR E DESATIVAR NOVAMENTE APÓS VARIÁVEIS
if (alarm[0] > 0) alarm[0] = -1; // Forçar desativação se ainda estiver ativo

// === CONFIGURAÇÕES DE RECRUTAMENTO ===
menu_recrutamento_ativo = false;
menu_recrutamento = noone; // ✅ Referência ao menu de recrutamento deste quartel
recrutamento_em_andamento = false;
unidade_sendo_treinada = noone;
tempo_treinamento_restante = 0;

// === VARIÁVEL DE ESTADO DE TREINAMENTO ===
esta_treinando = false;

// === CONFIGURAÇÕES DE NAÇÃO ===
nacao_proprietaria = 1; // Valor padrão - 1 = jogador, 2 = inimigo

// === CONFIGURAÇÕES DE UI ===
mostrar_menu = false;
botao_largura = 180;
botao_altura = 35;

// === SISTEMA DE UNIDADES DISPONÍVEIS ===
unidades_disponiveis = ds_list_create();
unidade_selecionada = 0; // Índice da unidade selecionada

// Adicionar unidades disponíveis
ds_list_add(unidades_disponiveis, {
    nome: "Infantaria",
    objeto: obj_infantaria,
    custo_dinheiro: 100,
    custo_populacao: 1,
    tempo_treino: 120, // ✅ CORRIGIDO: 2 segundos (120 frames) - mais rápido
    descricao: "Unidade de combate básica com rifle",
    sprite: spr_infantaria
});

ds_list_add(unidades_disponiveis, {
    nome: "Soldado Anti-Aéreo",
    objeto: obj_soldado_antiaereo,
    custo_dinheiro: 200,
    custo_populacao: 1,
    tempo_treino: 120, // ✅ CORRIGIDO: 2 segundos (120 frames) - mais rápido
    descricao: "Especialista com mísseis de longo alcance",
    sprite: spr_soldado_antiaereo,
    categoria: "terrestre"
});

ds_list_add(unidades_disponiveis, {
    nome: "Tanque",
    objeto: obj_tanque,
    custo_dinheiro: 500,
    custo_populacao: 3,
    tempo_treino: 120, // ✅ CORRIGIDO: 2 segundos (120 frames) - mais rápido
    descricao: "Unidade blindada pesada com canhão",
    sprite: spr_tanque
});

ds_list_add(unidades_disponiveis, {
    nome: "Blindado Anti-Aéreo",
    objeto: obj_blindado_antiaereo,
    custo_dinheiro: 800,
    custo_populacao: 4,
    tempo_treino: 120, // ✅ CORRIGIDO: 2 segundos (120 frames) - mais rápido
    descricao: "Veículo especializado em defesa aérea",
    sprite: spr_blindado_antiaereo,
    categoria: "terrestre"
});

// ✅ NOVO: M1A Abrams - Tanque de Elite
var _obj_abrams = asset_get_index("obj_M1A_Abrams");
var _spr_abrams = asset_get_index("spr_abrams_casco");
if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
    ds_list_add(unidades_disponiveis, {
        nome: "M1A Abrams",
        objeto: _obj_abrams,
        custo_dinheiro: 1200, // Mais caro que tanque comum (500) - unidade de elite
        custo_populacao: 5, // Mais população que tanque comum (3)
        tempo_treino: 120, // ✅ CORRIGIDO: 2 segundos (120 frames) - mais rápido
        descricao: "Tanque de elite com torre modular e projétil SABOT",
        sprite: (_spr_abrams != -1 && sprite_exists(_spr_abrams)) ? _spr_abrams : spr_tanque, // Fallback para spr_tanque se não encontrar
        categoria: "terrestre"
    });
}

// ✅ NOVO: Gepard Anti-Aéreo - Tanque Anti-Aéreo
// ✅ CORREÇÃO: Verificar nome correto do objeto (pode ser obj_Gepard_Anti_Aereo)
var _obj_gepard = asset_get_index("obj_Gepard_Anti_Aereo");
if (_obj_gepard == -1) {
    _obj_gepard = asset_get_index("obj_gepard"); // Fallback para nome alternativo
}
var _spr_gepard_casco = asset_get_index("TYPE_39_SAM_HULL");
if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
    ds_list_add(unidades_disponiveis, {
        nome: "Gepard Anti-Aéreo",
        objeto: _obj_gepard,
        custo_dinheiro: 1500, // Mais caro que Abrams - unidade especializada anti-aérea
        custo_populacao: 6, // Mais população que Abrams
        tempo_treino: 120, // ✅ CORRIGIDO: 2 segundos (120 frames) - mais rápido
        descricao: "Tanque anti-aéreo com mísseis SAM e projéteis SABOT",
        sprite: (_spr_gepard_casco != -1 && sprite_exists(_spr_gepard_casco)) ? _spr_gepard_casco : spr_tanque, // Fallback para spr_tanque se não encontrar
        categoria: "terrestre"
    });
}

// === FILA DE RECRUTAMENTO SIMPLES ===
// ✅ CORREÇÃO CRÍTICA: Garantir que cada quartel tenha sua própria fila independente
// Se a fila já existir (por herança ou outro motivo), destruir e criar uma nova
if (variable_instance_exists(id, "fila_recrutamento")) {
    if (ds_exists(fila_recrutamento, ds_type_queue)) {
        ds_queue_destroy(fila_recrutamento);
        show_debug_message("⚠️ Quartel ID: " + string(id) + " - Fila antiga destruída, criando nova fila independente");
    }
}
// ✅ SEMPRE criar uma nova fila única para este quartel
fila_recrutamento = ds_queue_create();

// ✅ GARANTIR QUE FILA ESTÁ VAZIA AO CRIAR
ds_queue_clear(fila_recrutamento);
esta_treinando = false; // ✅ GARANTIR QUE NÃO ESTÁ TREINANDO
tempo_treinamento_restante = 0; // ✅ RESETAR TIMER

// ✅ DEBUG: Confirmar que cada quartel tem sua própria fila
show_debug_message("✅ Quartel ID: " + string(id) + " - Fila de recrutamento criada (ID da fila: " + string(fila_recrutamento) + ")");

// === VARIÁVEIS PARA COMPATIBILIDADE ===
ultimo_recrutamento_tanque = false;

// Variáveis para evitar avisos GM2016
quantidade_recrutar = 1;
unidades_para_criar = 1;
unidades_criadas = 0;
recrutar_tanque = false;

// Contador para debug do Step
step_counter = 0;

// === SISTEMA DE BARRA DE VIDA ===
mostrar_barra_vida = false;     // Mostrar quando atingido
timer_barra_vida = 0;           // Timer para desaparecer
duracao_barra_vida = 300;       // 5 segundos (300 frames)
barra_vida_altura = 8;
barra_vida_largura = 80;

// === PROTEÇÃO CONTRA DESATIVAÇÃO ===
// ✅ CORREÇÃO: Garantir que quartel sempre esteja visível e ativo
visible = true;
force_always_active = true; // Nunca desativar estruturas importantes
instance_activate_object(id); // Garantir que está ativo

// ✅ DEBUG: Confirmar que quartel está ativo
show_debug_message("✅ Quartel ID: " + string(id) + " criado com force_always_active = true | Nação: " + string(nacao_proprietaria));

// ✅ ALTERNATIVA: Usar Alarm como backup para garantir execução
// Se o Step não executar, o Alarm vai chamar o Step manualmente
alarm[1] = 1; // Executar no próximo frame

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Quartéis só em terreno de campo

show_debug_message("Um quartel foi construído e está pronto para recrutar unidades.");
show_debug_message("Custo de construção: $" + string(custo_dinheiro) + " dinheiro, " + string(custo_minerio) + " minério");
show_debug_message("✅ Quartel protegido contra desativação - ID: " + string(id));