# 📊 ANÁLISE E PLANO DE MELHORIA - IA PRESIDENTE 1

## 🔍 ANÁLISE DO CÓDIGO ATUAL

### ✅ Pontos Fortes
- ✅ Sistema de decisão rápido (60 frames)
- ✅ Prioridade militar alta (80%)
- ✅ Sistema de defesa implementado
- ✅ Detecção de território
- ✅ Balanceamento ofensiva/defesa

### ❌ Problemas Identificados

#### Problema 1: Unidades não recebem comando de movimento
- **Sintoma**: Soldado aparece no mapa mas fica parado
- **Causa**: Unidades são criadas mas não recebem destino/comando
- **Localização**: `scr_ia_atacar.gml` pode não estar movendo unidades
- **Impacto**: Exército do presidente fica estático

#### Problema 2: Seleção de unidades básica
- **Sintoma**: Presidente recruta infantaria quando tem recursos para tanques/aviões
- **Causa**: Lógica de recrutamento não prioriza unidades de elite
- **Localização**: `Step_0.gml` linha 278-494 (recrutar_unidades)
- **Impacto**: Exército fraco e ineficaz

#### Problema 3: Falta coordenação de ataque
- **Sintoma**: Unidades atacam individualmente sem estratégia
- **Causa**: Não há sistema de formação/esquadrão
- **Localização**: `scr_ia_atacar.gml` (se existir)
- **Impacto**: Perdas desnecessárias

#### Problema 4: Sem estratégia adaptativa
- **Sintoma**: IA não adapta táticas ao exército do jogador
- **Causa**: Não analisa composição do exército inimigo
- **Localização**: Falta script de análise inteligente
- **Impacto**: IA previsível e fraca

---

## 🎯 PLANO DE MELHORIA - 7 FASES

### FASE 1: SISTEMA DE CLASSIFICAÇÃO DE UNIDADES

**Objetivo**: Criar escala de poder para priorizar unidades de elite

**Criar arquivo**: `scripts/scr_ia_classificar_poder_unidades/scr_ia_classificar_poder_unidades.gml`

```gml
// === TIER S (Elite) - Prioridade Máxima ===
// Valor: 1000+, Poder de fogo: Máximo
enum TierUnidade {
    S_RONALD_REAGAN,      // Porta-aviões (poder naval supremo)
    S_INDEPENDENCE,       // Cruzador pesado (destruidor de armadas)
    S_CONSTELLATION,      // Fragata avançada (versátil)
    S_F15,               // Caça de elite (superioridade aérea)
    S_BLINDADO_ANTIAEREO, // Defesa aérea pesada (2 armas)
    
    A_F6,                 // Caça (interceptor)
    A_HELICOPTERO,        // Helicóptero (ataque)
    A_TANQUE,             // Blindado (força terrestre)
    A_SUBMARINO,          // Submarino (ataque naval furtivo)
    
    B_SOLDADO_ANTIAEREO,  // Defesa básica
    B_LANCHA_PATRULHA,    // Patrulha naval
    B_CACA_F5,            // Caça básico
    
    C_INFANTARIA          // Última opção
}

function classificar_poder_unidade(_obj_tipo) {
    switch(_obj_tipo) {
        case obj_RonaldReagan:         return TierUnidade.S_RONALD_REAGAN;
        case obj_Independence:         return TierUnidade.S_INDEPENDENCE;
        case obj_Constellation:        return TierUnidade.S_CONSTELLATION;
        case obj_f15:                  return TierUnidade.S_F15;
        case obj_blindado_antiaereo:   return TierUnidade.S_BLINDADO_ANTIAEREO;
        case obj_f6:                   return TierUnidade.A_F6;
        case obj_helicoptero_militar:  return TierUnidade.A_HELICOPTERO;
        case obj_tanque:               return TierUnidade.A_TANQUE;
        case obj_submarino_base:       return TierUnidade.A_SUBMARINO;
        case obj_soldado_antiaereo:    return TierUnidade.B_SOLDADO_ANTIAEREO;
        case obj_lancha_patrulha:      return TierUnidade.B_LANCHA_PATRULHA;
        case obj_caca_f5:              return TierUnidade.B_CACA_F5;
        case obj_infantaria:           return TierUnidade.C_INFANTARIA;
        default:                       return TierUnidade.C_INFANTARIA;
    }
}

function obter_valor_poder(_tier) {
    switch(_tier) {
        case TierUnidade.S_RONALD_REAGAN:      return 1000;
        case TierUnidade.S_INDEPENDENCE:       return 900;
        case TierUnidade.S_CONSTELLATION:      return 850;
        case TierUnidade.S_F15:                return 800;
        case TierUnidade.S_BLINDADO_ANTIAEREO: return 750;
        case TierUnidade.A_F6:                 return 600;
        case TierUnidade.A_HELICOPTERO:        return 550;
        case TierUnidade.A_TANQUE:             return 500;
        case TierUnidade.A_SUBMARINO:          return 450;
        case TierUnidade.B_SOLDADO_ANTIAEREO:  return 250;
        case TierUnidade.B_LANCHA_PATRULHA:    return 200;
        case TierUnidade.B_CACA_F5:            return 150;
        case TierUnidade.C_INFANTARIA:         return 50;
        default:                               return 0;
    }
}
```

---

### FASE 2: SELEÇÃO INTELIGENTE DE UNIDADES

**Objetivo**: Escolher melhor unidade baseada em situação

**Criar arquivo**: `scripts/scr_ia_selecionar_melhor_unidade/scr_ia_selecionar_melhor_unidade.gml`

```gml
/// @function scr_ia_selecionar_melhor_unidade(_presidente_id)
/// @description Seleciona a melhor unidade para recrutar baseada em recursos e estratégia

function scr_ia_selecionar_melhor_unidade(_presidente_id) {
    with (_presidente_id) {
        var _unidade_selecionada = noone;
        var _max_poder = 0;
        
        // === ANÁLISE 1: Recursos disponíveis ===
        var _recursosAltos = (global.dinheiro > 100000);
        var _recursosMedios = (global.dinheiro > 50000);
        
        // === ANÁLISE 2: Composição do exército do jogador ===
        var _exército_jogador = analizar_exército_jogador();
        
        // === PRIORIDADES BASEADAS NO EXÉRCITO INIMIGO ===
        
        // Se jogador tem muitos aviões → priorizar defesa aérea (TIER S)
        if (_exército_jogador.avioes > _exército_jogador.terrestres * 0.5) {
            return obj_blindado_antiaereo; // Contra aviões
        }
        
        // Se jogador tem muitos navios → priorizar submarinos ou aviões
        if (_exército_jogador.navios > 3) {
            if (_recursosAltos) {
                return obj_f15; // Aviões para bombardeio naval
            } else {
                return obj_submarino_base; // Submarinos para ataque furtivo
            }
        }
        
        // Se jogador tem muitos tanques → priorizar aviões
        if (_exército_jogador.terrestres > _exército_jogador.avioes * 2) {
            if (_recursosAltos) {
                return obj_f15;
            } else {
                return obj_f6;
            }
        }
        
        // === PADRÃO: Balanceamento ===
        if (_recursosAltos) {
            // 50% de chance de unidade Tier S/A
            var _sorte = random(100);
            if (_sorte < 50) return obj_f15; // Aviões
            if (_sorte < 75) return obj_tanque; // Tanques
            if (_sorte < 90) return obj_blindado_antiaereo; // Defesa aérea
            return obj_infantaria;
        } else if (_recursosMedios) {
            var _sorte = random(100);
            if (_sorte < 40) return obj_tanque;
            if (_sorte < 70) return obj_f6;
            if (_sorte < 85) return obj_soldado_antiaereo;
            return obj_infantaria;
        } else {
            return obj_infantaria;
        }
    }
}

function analizar_exército_jogador() {
    var _analise = {
        terrestres: 0,
        avioes: 0,
        navios: 0,
        defesa_aerea: 0
    };
    
    // Contar unidades do jogador
    with (obj_infantaria) {
        if (nacao_proprietaria == 1) _analise.terrestres++;
    }
    with (obj_tanque) {
        if (nacao_proprietaria == 1) _analise.terrestres++;
    }
    with (obj_f15) {
        if (nacao_proprietaria == 1) _analise.avioes++;
    }
    with (obj_f6) {
        if (nacao_proprietaria == 1) _analise.avioes++;
    }
    with (obj_soldado_antiaereo) {
        if (nacao_proprietaria == 1) _analise.defesa_aerea++;
    }
    with (obj_RonaldReagan) {
        if (nacao_proprietaria == 1) _analise.navios++;
    }
    
    return _analise;
}
```

---

### FASE 3: SISTEMA DE ATAQUE COORDENADO

**Objetivo**: Fazer unidades atacarem juntas com estratégia

**Criar arquivo**: `scripts/scr_ia_ataque_coordenado/scr_ia_ataque_coordenado.gml`

```gml
/// @function scr_ia_ataque_coordenado(_presidente_id)
/// @description Coordena ataque de unidades em grupo

function scr_ia_ataque_coordenado(_presidente_id) {
    with (_presidente_id) {
        
        // === 1. ENCONTRAR ALVO ===
        var _alvo = encontrar_alvo_prioritario();
        if (_alvo == noone) return false;
        
        // === 2. SELECIONAR UNIDADES DE ATAQUE ===
        var _unidades_ataque = ds_list_create();
        
        with (obj_infantaria) {
            if (nacao_proprietaria == 2) {
                ds_list_add(_unidades_ataque, id);
            }
        }
        with (obj_tanque) {
            if (nacao_proprietaria == 2) {
                ds_list_add(_unidades_ataque, id);
            }
        }
        with (obj_f15) {
            if (nacao_proprietaria == 2) {
                ds_list_add(_unidades_ataque, id);
            }
        }
        
        // Precisamos de pelo menos 3 unidades
        if (ds_list_size(_unidades_ataque) < 3) {
            ds_list_destroy(_unidades_ataque);
            return false;
        }
        
        // === 3. COORDENAR ATAQUE EM GRUPO ===
        var _ponto_reuniao_x = _alvo.x - 200;
        var _ponto_reuniao_y = _alvo.y - 200;
        
        // Primeira onda: unidades rápidas se reúnem
        for (var i = 0; i < ds_list_size(_unidades_ataque); i++) {
            var _unidade = _unidades_ataque[| i];
            if (instance_exists(_unidade)) {
                // Comando: ir para ponto de reunião
                _unidade.alvo = noone;
                _unidade.x_destino = _ponto_reuniao_x + random(-100, 100);
                _unidade.y_destino = _ponto_reuniao_y + random(-100, 100);
                _unidade.em_movimento = true;
            }
        }
        
        // Após reunião (5 segundos), atacar juntas
        with (_presidente_id) {
            timer_ataque_coordenado = 300; // 5 segundos
            alvo_coordenado = _alvo;
            unidades_ataque_coordenado = _unidades_ataque;
        }
        
        return true;
    }
}

function encontrar_alvo_prioritario() {
    // Prioridade 1: Estruturas econômicas do jogador
    with (obj_fazenda) {
        if (nacao_proprietaria == 1) return id;
    }
    with (obj_mina) {
        if (nacao_proprietaria == 1) return id;
    }
    
    // Prioridade 2: Unidades do jogador
    with (obj_tanque) {
        if (nacao_proprietaria == 1) return id;
    }
    
    // Se não encontrar, retorna noone
    return noone;
}
```

---

### FASE 4: COMANDO INTELIGENTE DE UNIDADES

**Objetivo**: Garantir que unidades criadas recebem ordem

**Modificar**: `objects/obj_presidente_1/Step_0.gml`

Adicionar após criar unidade:

```gml
// ✅ NOVO: GARANTIR QUE UNIDADE CRIADA RECEBE COMANDO
if (_sucesso && instance_exists(_nova_unidade)) {
    // Definir comando inicial
    if (has_target_for_attack) {
        _nova_unidade.alvo = encontrar_alvo_prioritario();
        _nova_unidade.em_movimento = true;
    } else {
        // Se não tem alvo, ir para ponto de defesa
        _nova_unidade.x_destino = base_x + random(-500, 500);
        _nova_unidade.y_destino = base_y + random(-500, 500);
        _nova_unidade.em_movimento = true;
    }
}
```

---

### FASE 5: MELHORIAS NO RECRUTAMENTO

**Objetivo**: Priorizar unidades de elite

**Modificar**: `objects/obj_presidente_1/Step_0.gml` - Case "recrutar_unidades"

```gml
case "recrutar_unidades":
    // ✅ NOVO: Usar seleção inteligente
    var _melhor_unidade = scr_ia_selecionar_melhor_unidade(id);
    
    // Tentar recrutar a melhor unidade
    _sucesso = false;
    
    if (_melhor_unidade != noone) {
        // Procurar estrutura apropriada para recrutar
        var _estrutura_recruta = encontrar_estrutura_recruta(_melhor_unidade);
        
        if (_estrutura_recruta != noone) {
            // Comandar recrutamento
            _estrutura_recruta.fila_recrutamento = _melhor_unidade;
            _sucesso = true;
        }
    }
    break;
```

---

### FASE 6: DEBUG E TESTES

**Adicionar em**: `objects/obj_presidente_1/Create_0.gml`

```gml
// === DEBUG DE RECRUTAMENTO ===
debug_recrutamento = true;
debug_ataque = true;

// === CONFIGURAÇÕES DE TESTE ===
teste_modo_agressivo = true;      // Forçar modo agressivo
teste_recrutar_elite = true;       // Forçar recrutamento de elite
teste_coordenar_ataques = true;    // Forçar ataques coordenados
```

---

### FASE 7: MONITORAMENTO DE PERFORMANCE

**Criar arquivo**: `scripts/scr_ia_monitorar_performance/scr_ia_monitorar_performance.gml`

```gml
function scr_ia_monitorar_performance(_presidente_id) {
    with (_presidente_id) {
        if (!variable_instance_exists(id, "stats_performance")) {
            stats_performance = {
                unidades_recrutadas: 0,
                ataques_coordenados: 0,
                alvos_eliminados: 0,
                taxa_sucesso_ataque: 0,
                recursos_gastos: 0
            };
        }
        
        // Adicionar logs
        if (debug_recrutamento) {
            show_debug_message("📊 IA Presidente: " + string(array_length(lista_unidades)) + " unidades | " + 
                             "$" + string(global.dinheiro));
        }
    }
}
```

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### FASE 1: Classificação
- [ ] Criar `scr_ia_classificar_poder_unidades.gml`
- [ ] Definir enums de tier
- [ ] Testar classificação

### FASE 2: Seleção
- [ ] Criar `scr_ia_selecionar_melhor_unidade.gml`
- [ ] Implementar análise de exército
- [ ] Testar seleção adaptativa

### FASE 3: Coordenação
- [ ] Criar `scr_ia_ataque_coordenado.gml`
- [ ] Implementar formação de grupo
- [ ] Testar ataque em grupo

### FASE 4: Comando
- [ ] Adicionar comando inicial a unidades
- [ ] Garantir movimento após criação
- [ ] Testar movimento de unidades

### FASE 5: Recrutamento
- [ ] Integrar seleção inteligente
- [ ] Priorizar elite
- [ ] Testar recrutamento

### FASE 6: Debug
- [ ] Adicionar flags de debug
- [ ] Implementar logs
- [ ] Testar mensagens

### FASE 7: Performance
- [ ] Monitorar stats
- [ ] Adicionar telemetria
- [ ] Analisar resultados

---

## 🎯 RESULTADO ESPERADO

Após implementação:

✅ Presidente recruta unidades de elite (F-15, tanques, etc)
✅ Unidades criadas recebem comando imediatamente
✅ Ataques coordenados e eficazes
✅ IA adapta táticas ao exército do jogador
✅ Sem unidades paradas no mapa
✅ Desafio maior e mais inteligente

---

## 🔧 PRÓXIMAS ETAPAS

1. Implementar FASE 1 e 2 (classificação + seleção)
2. Testar recrutamento de elite
3. Implementar FASE 3 e 4 (coordenação + comando)
4. Testar ataques coordenados
5. Implementar FASE 5-7 (refinamento)
6. Teste final e balanceamento

**Quer que eu comece a implementar?**

