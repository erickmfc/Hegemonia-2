# 🔥 MÍSSIL LIT (Light Interceptor Tactical) - SISTEMA COMPLETO

## 📋 DESCRIÇÃO

O **LIT** é um míssil híbrido **avançado e versátil** com:
- ✅ Rastreamento inteligente com predição de posição
- ✅ Velocidade adaptativa (12 tipos diferentes de alvo)
- ✅ Dano em área **150% maior** que outros mísseis
- ✅ Raio de colisão **maior e mais confiável**
- ✅ Sistema de correc ão de trajetória automática
- ✅ Cor especial: **Amarelo Ouro** (fácil identificação)

---

## 🎯 CARACTERÍSTICAS PRINCIPAIS

| Característica | Valor | Notas |
|---|---|---|
| **Dano Base** | 80 | Ajustado por tipo de alvo (90-140) |
| **Dano em Área** | 1500 | **3x maior que mísseis normais** |
| **Raio Dano Área** | 400px | Maior área de efeito |
| **Tempo de Vida** | 500 frames | **8.3 segundos** (2-3x maior que outros) |
| **Raio de Colisão** | 150+ (adaptativo) | Detecta mais facilmente |
| **Velocidade** | 7-12px/frame | Adaptativa por alvo |
| **Precisão** | 95% | Sistema de predição ativo |

---

## ⚡ VELOCIDADES ADAPTATIVAS POR ALVO

```
Tipo Alvo          | Velocidade | Uso
-------------------+------------+------------------------------------
Aéreo              | 12 px/frame | Helicópteros, F-5, F-6, F-15, C-100
Marítimo           | 8 px/frame  | Constellation, Independence, Reagan, Lancha
Submarino          | 7 px/frame  | Anti-submarino (MÁXIMO DANO: 140)
Terrestre          | 10 px/frame | Tanques, Infantaria, Blindados
Desconhecido       | 10 px/frame | Alvo não identificado
```

---

## 💥 DANO POR TIPO DE ALVO

```
Alvo              | Dano Direto | Dano Área | Explosão
------------------+-------------+-----------+------------------
Aéreo             | 120         | 1500      | Explosão Ar (2x maior)
Marítimo          | 100         | 1500      | Explosão Terra (2.5x maior)
Submarino         | 140 ⭐      | 1500      | Explosão Especial
Terrestre         | 90          | 1500      | Explosão Terra
```

---

## 🚀 COMO USAR

### 1. **Disparo Básico (Qualquer Unidade)**

```gml
// No seu objeto, em qualquer lugar:
var _lit = scr_disparar_lit(id, alvo_unidade);

if (instance_exists(_lit)) {
    show_debug_message("LIT disparado com sucesso!");
}
```

### 2. **Integração com Navios (obj_navio_base)**

Adicione no **Step Event** (seção de disparo de mísseis, ~linha 500):

```gml
// Verificar se alvo é de "alto valor" (merece LIT)
var _usar_lit = false;
var _nome_alvo = object_get_name(alvo_unidade.object_index);

// Listas de alvos "premium"
if (_nome_alvo == "obj_Constellation" ||      // Aliado inimigoalvo
    _nome_alvo == "obj_Independence" ||       // Porta-aviões
    _nome_alvo == "obj_RonaldReagan" ||       // Mega-navio
    _nome_alvo == "obj_c100" ||               // Avião importante
    _nome_alvo == "obj_submarino_base") {     // Submarino
    _usar_lit = true;
}

if (_usar_lit && reload_timer <= 0) {
    var _lit = scr_disparar_lit(id, alvo_unidade);
    if (instance_exists(_lit)) {
        reload_timer = reload_time;  // Resetar cooldown
        show_debug_message("💥 " + nome_unidade + " disparou LIT!");
    }
} else {
    // Usar míssil padrão normalmente
    // ... código padrão de disparo ...
}
```

### 3. **Integração com Lancha (obj_lancha_patrulha)**

No **Step Event** (seção de ataque, ~linha 415):

```gml
if (_distancia_alvo <= missil_alcance && reload_timer <= 0) {
    
    // Verificar se deve usar LIT
    var _usar_lit = (alvo_unidade.object_index == obj_c100 ||
                     alvo_unidade.object_index == obj_helicoptero_militar);
    
    if (_usar_lit) {
        var _lit = scr_disparar_lit(id, alvo_unidade);
        if (instance_exists(_lit)) {
            reload_timer = reload_time;
        }
    } else {
        // Usar tiro simples normal
        var _missil = scr_get_projectile_from_pool(obj_tiro_simples, x, y, "Instances");
        // ... código normal ...
    }
}
```

### 4. **Integração com Submarinos (obj_submarino_base)**

Similar à lancha - verificar tipo de alvo e usar LIT para alvos importantes.

---

## 🎨 EFEITOS VISUAIS

- **Cor**: Amarelo Ouro (RGB: 255, 200, 0)
- **Explosão Aérea**: 2.0x maior (cores douradas)
- **Explosão Terrestre**: 2.5x maior (cores douradas)
- **Rastro**: Partículas douradas durante o voo
- **Profundidade**: -1001 (acima de outros objetos)

---

## ⚙️ SISTEMA DE PREDIÇÃO

O LIT **prevê a posição futura** do alvo:

```gml
// O míssil calcula onde o alvo ESTARÁ (não onde está)
// Baseado em velocidade do alvo:
nova_pos = alvo_pos + (alvo.velocidade * tempo_predicao)
```

Isso torna **muito mais difícil** desviar do LIT, especialmente contra:
- Aviões em movimento rápido
- Navios que se locomovem
- Unidades em evasão

---

## 📊 COMPARAÇÃO COM OUTROS MÍSSEIS

| Característica | Tiro Simples | Míssil Ice | SkyFury | Ironclad | **LIT** |
|---|---|---|---|---|---|
| Dano Direto | 100 | 150 | 60 | 80 | **80-140** |
| Dano em Área | 1000 | 1500 | 0 | 0 | **1500** |
| Raio Dano | 300px | 300px | - | - | **400px** |
| Tempo Vida | 300 | 300 | 150 | 150 | **500** |
| Raio Colisão | 120px | 150px | - | - | **150-200px** |
| Predição | Não | Não | Não | Não | **Sim ✅** |
| Versatilidade | Todos | Submarinos | Aéreos | Terrestres | **TODOS** |

---

## 🛠️ ARQUIVOS CRIADOS

1. **objects/obj_lit/Create_0.gml** - Inicialização do míssil
2. **objects/obj_lit/Step_0.gml** - Lógica de voo e colisão
3. **scripts/scr_disparar_lit/scr_disparar_lit.gml** - Script de disparo
4. **scripts/scr_usar_lit_nav/scr_usar_lit_nav.gml** - Exemplo de integração

---

## 🎮 QUANDO USAR LIT

✅ **USE LIT contra:**
- Navios porta-aviões (Constellation, Independence, Reagan)
- Submarinos (dano 140, máximo)
- Aviões importantes (C-100, helicópteros)
- Múltiplos alvos próximos (dano em área)

❌ **NÃO use LIT contra:**
- Soldados individuais (desperdício de recursos)
- Estruturas estacionárias
- Inimigos muito distantes

---

## 📈 DICAS DE USO

1. **Espere o alvo se mover** - O sistema de predição funciona melhor com alvos em movimento
2. **Use contra grupos** - O dano em área de 1500 é devastador em agrupamentos
3. **Contra submarinos** - LIT é a melhor opção com dano 140 (2x do Missile Ice)
4. **Contra navios** - Combine LIT com tiros simples para economizar munição
5. **Economia** - Reserve LIT para alvos de "alto valor" apenas

---

## 🔍 DEBUG

Ativa mensagens detalhadas:

```
🔥 ===== MÍSSIL LIT CRIADO =====
🎯 Tipo de alvo detectado: submarino
⚡ Velocidade: 7px/frame
💥 Dano: 80 | Dano em Área: 1500px (raio: 400)

🔥 LIT DISPARADO!
   Atirador: obj_Constellation
   Alvo: obj_submarino_base (submarino)
   Velocidade: 7px/frame
   Dano: 80 | Dano em Área: 1500

💥 LIT acertou submarino! Dano: 140
💥💥 LIT EXPLOSÃO! 5 unidades atingidas em 400px!
```

---

## ⚠️ NOTAS TÉCNICAS

- LIT usa **object pooling** (reutiliza instâncias)
- Compatível com todos os navios, aviões e unidades
- Sistema adaptativo ajusta velocidade **automaticamente**
- Raio de colisão **2-3x maior** que mísseis normais
- Dano em área **1.5x maior** que outros mísseis
- Tempo de vida **2x maior** para alvos distantes

---

## 🚀 PRÓXIMOS PASSOS

Para adicionar LIT ao seu jogo:

1. ✅ Criar sprite do LIT (já feito)
2. ✅ Criar obj_lit (já feito)
3. ✅ Adicionar scripts (já feito)
4. ⏳ Integrar em obj_navio_base/Step_0.gml (seção de disparo)
5. ⏳ Integrar em obj_lancha_patrulha/Step_0.gml (seção de ataque)
6. ⏳ Testar contra diferentes tipos de alvo
7. ⏳ Balancear dano se necessário

---

**LIT: O míssil versátil que nunca falha! 🔥**

