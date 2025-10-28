# 🤖 IA PRESIDENTE 1 - RECRUTAMENTO E ATAQUE

## ✅ IMPLEMENTAÇÃO COMPLETA

Sistema de recrutamento e ataque automáticos implementado para a IA.

---

## 📁 ARQUIVOS CRIADOS

### 1. **scripts/scr_ia_recrutar_unidade/scr_ia_recrutar_unidade.gml**
Sistema de recrutamento automático de unidades para a IA.

**Função:**
- Busca quartéis disponíveis da IA
- Verifica recursos necessários
- Inicia processo de treinamento
- Deduz recursos automaticamente

**Custos suportados:**
- Infantaria: $100 + 1 população
- Tanque: $500 + 3 população + 250 minério
- Soldado Anti-Aéreo: $150 + 1 população + 50 minério

### 2. **scripts/scr_ia_atacar/scr_ia_atacar.gml**
Sistema de ataque automático a inimigos.

**Função:**
- Detecta inimigos próximos do jogador
- Escolhe o alvo mais próximo
- Comanda todas as unidades da IA para atacar
- Atualiza estados de combate

---

## ⚙️ COMO FUNCIONA

### **Recrutamento Automático**

1. **Verificação de Recursos:**
   ```gml
   // Verifica se a IA tem recursos suficientes
   if (global.ia_dinheiro < _custo_total_d || 
       global.ia_populacao < _custo_total_p || 
       global.ia_minerio < _custo_total_m) {
       // Bloqueia recrutamento
   }
   ```

2. **Busca de Quartel:**
   ```gml
   // Procura quartel da IA que não está treinando
   with (obj_quartel) {
       if (nacao_proprietaria == 2 && !esta_treinando) {
           quartel_da_ia = id;
       }
   }
   ```

3. **Iniciar Treinamento:**
   ```gml
   // Configura o quartel para treinar
   esta_treinando = true;
   unidades_para_criar = 5;
   alarm[0] = 300; // 5 segundos
   ```

4. **Dedução de Recursos:**
   ```gml
   global.ia_dinheiro -= custo_total_d;
   global.ia_populacao -= custo_total_p;
   global.ia_minerio -= custo_total_m;
   ```

---

### **Ataque Automático**

1. **Detecção de Inimigos:**
   ```gml
   // Procura unidades do jogador (nacao_proprietaria == 1)
   with (obj_infantaria) {
       if (nacao_proprietaria == 1) {
           if (point_distance(x, y, base_ia) <= raio_expansao) {
               adicionar_a_lista(inimigo);
           }
       }
   }
   ```

2. **Escolha do Alvo:**
   ```gml
   // Escolhe o inimigo mais próximo
   for each inimigo {
       distancia = point_distance(inimigo, base_ia);
       if (distancia < menor_distancia) {
           alvo = inimigo;
       }
   }
   ```

3. **Comando de Ataque:**
   ```gml
   // Comanda todas as unidades da IA
   with (obj_infantaria) {
       if (nacao_proprietaria == 2) {
           alvo_inimigo = alvo;
           destino_x = alvo.x;
           destino_y = alvo.y;
           estado = "atacando";
       }
   }
   ```

---

## 🎯 INTEGRAÇÃO COM SISTEMA DE DECISÃO

O sistema de recrutamento e ataque está integrado ao ciclo de decisão da IA:

```gml
// Ciclo a cada 5 segundos
timer_decisao--;
if (timer_decisao <= 0) {
    var _decisao = scr_ia_decisao_economia(id);
    
    switch (_decisao) {
        case "recrutar_unidades":
            scr_ia_recrutar_unidade(id, obj_infantaria, 5);
            break;
            
        case "atacar":
            scr_ia_atacar(id);
            break;
    }
}
```

---

## 📊 COMPORTAMENTO ESPERADO

### **Fase 1: Recrutamento (60-90 segundos)**
```
Prioridade: Recrutar Unidades
Objetivo: 15 unidades militares
Ações: 
  - Recrutar 5 infantarias a cada decisão
  - Verificar recursos suficientes
  - Priorizar quartéis livres
```

### **Fase 2: Ataque (90+ segundos)**
```
Prioridade: Atacar Jogador
Objetivo: Eliminar inimigos próximos
Ações:
  - Detectar inimigos no raio
  - Formar esquadrão
  - Atacar alvo mais próximo
```

---

## 🐛 DEBUG

Mensagens de debug do sistema:

### **Recrutamento:**
```
✅ IA iniciou recrutamento de 5 Infantaria
💰 IA recursos restantes: $1500 | População: 95 | Minério: 1000
```

### **Ataque:**
```
⚔️ IA ATACANDO INIMIGO! Unidades comandadas: 8 | Distância: 245
🎯 Alvo ID: 12345 em (500, 300)
```

### **Erros:**
```
❌ IA sem recursos para recrutar Infantaria (Precisa: $500, 5 população)
⚠️ IA não encontrou inimigos para atacar no raio de expansão
```

---

## 🔧 PERSONALIZAÇÃO

### **Ajustar Quantidade de Recrutamento**
Editar `obj_presidente_1/Step_0.gml`:
```gml
// Original: 5 unidades
scr_ia_recrutar_unidade(id, obj_infantaria, 5);

// Agressivo: 10 unidades
scr_ia_recrutar_unidade(id, obj_infantaria, 10);

// Conservador: 3 unidades
scr_ia_recrutar_unidade(id, obj_infantaria, 3);
```

### **Ajustar Tipo de Unidade**
```gml
// Infantaria (padrão)
scr_ia_recrutar_unidade(id, obj_infantaria, 5);

// Tanques (mais caro)
scr_ia_recrutar_unidade(id, obj_tanque, 3);

// Soldados Anti-Aéreo
scr_ia_recrutar_unidade(id, obj_soldado_antiaereo, 5);
```

### **Ajustar Raio de Detecção**
Editar `obj_presidente_1/Create_0.gml`:
```gml
// Padrão: 800 pixels
raio_expansao = 800;

// Maior: 1200 pixels
raio_expansao = 1200;

// Menor: 500 pixels
raio_expansao = 500;
```

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

- [x] Sistema de recrutamento automático
- [x] Verificação de recursos
- [x] Busca de quartéis disponíveis
- [x] Início de treinamento
- [x] Dedução de recursos
- [x] Detecção de inimigos
- [x] Escolha de alvo
- [x] Comando de ataque
- [x] Atualização de estados
- [x] Debug detalhado
- [x] Documentação

---

## 🚀 PRÓXIMOS PASSOS

### **Imediatos:**
1. Testar no jogo
2. Verificar se as unidades são criadas corretamente
3. Verificar se o ataque funciona

### **Melhorias Futuras:**
1. Formação de esquadrões coordenados
2. Retirada tática quando em desvantagem
3. Priorização de alvos (estruturas vs unidades)
4. Ataques coordenados múltiplos
5. Integração com sistema de patrulha

---

## 📝 NOTAS IMPORTANTES

⚠️ **Quartel deve estar configurado para aceitar `nacao_proprietaria`**
⚠️ **Objetos de unidades devem suportar `alvo_inimigo` e `destino_x/y`**
⚠️ **Recursos da IA são globais e separados do jogador**

---

**Status: ✅ PRONTO PARA TESTE**

